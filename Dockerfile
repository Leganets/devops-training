FROM python:3.9-alpine

WORKDIR /app

# Установить build-зависимости
RUN apk add --no-cache gcc musl-dev libffi-dev

# Копируем и устанавливаем зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Удаляем build-зависимости (экономим место)
RUN apk del gcc musl-dev libffi-dev

# Копируем код
COPY app/ .

# Создаём непривилегированного пользователя
RUN adduser -D appuser
USER appuser

# Открываем порт
EXPOSE 5000

# Health check через HTTP (127.0.0.1 вместо localhost для wget и flask)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:5000/health || exit 1

# Запускаем Flask API
CMD ["python", "api.py"]
