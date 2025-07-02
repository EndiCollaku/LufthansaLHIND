from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

app.config['ENV'] = os.getenv('FLASK_ENV', 'production')
app.config['APP_NAME'] = os.getenv('APP_NAME', 'InventoryApp')

POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_DB = os.getenv('POSTGRES_DB')
POSTGRES_HOST = os.getenv('POSTGRES_HOST', 'postgres')

app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:5432/{POSTGRES_DB}"


app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    quantity = db.Column(db.Integer)

# Instead of @app.before_first_request, do this:
with app.app_context():
    db.create_all()

@app.route('/api/products', methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify([{'id': p.id, 'name': p.name, 'quantity': p.quantity} for p in products])

@app.route('/api/products', methods=['POST'])
def add_product():
    data = request.json
    print("Received data:", data)   # Add this line
    product = Product(name=data['name'], quantity=data['quantity'])
    db.session.add(product)
    db.session.commit()
    return jsonify({'message': 'Product added'}), 201

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'})

@app.route('/api/products/<int:id>', methods=['DELETE'])
def delete_product(id):
    product = Product.query.get_or_404(id)
    db.session.delete(product)
    db.session.commit()
    return jsonify({'message': 'Product deleted'})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
