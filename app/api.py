import os
import logging
from flask import Flask, jsonify, request
from calculator import add, subtract, multiply, divide
APP_ENV = os.getenv("APP_ENV", "development")
LOG_LEVEL = os.getenv("LOG_LEVEL", "info").upper()
logging.basicConfig(level=getattr(logging, LOG_LEVEL, logging.INFO),
                    format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)
app = Flask(__name__)
logger.info("App starting: APP_ENV=%s, LOG_LEVEL=%s", APP_ENV, LOG_LEVEL)


@app.route('/health', methods=['GET'])
def health():
    logger.debug("Health check hit")
    return jsonify({"status": "healthy", "env": APP_ENV}), 200


@app.route('/calculate', methods=['POST'])
def calculate():
    data = request.json
    operation = data.get('operation')
    a = data.get('a')
    b = data.get('b')
    logger.debug("calculate: op=%s a=%s b=%s", operation, a, b)
    if operation == 'add':
        result = add(a, b)
    elif operation == 'subtract':
        result = subtract(a, b)
    elif operation == 'multiply':
        result = multiply(a, b)
    elif operation == 'divide':
        result = divide(a, b)
    else:
        return jsonify({"error": "Invalid operation"}), 400
    return jsonify({"result": result}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
