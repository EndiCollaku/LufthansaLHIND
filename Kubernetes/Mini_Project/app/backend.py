from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/user")
def user():
    return jsonify({
        "id": 1,
        "name": "Endi",
        "email": "endi@example.com"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
