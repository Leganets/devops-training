from flask import Flask, jsonify, request
from calculator import add, subtract, multiply, divide

app = Flask(__name__)


@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200


@app.route('/calculate', methods=['POST'])
def calculate():
    data = request.json
    operation = data.get('operation')
    a = data.get('a')
    b = data.get('b')

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
