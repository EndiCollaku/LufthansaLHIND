from flask import Flask
import requests

app = Flask(__name__)

@app.route("/")
def index():
    try:
        response = requests.get("http://user-service/user")
        user = response.json()
        return f"<h1>Hello {user['name']}</h1><p>Email: {user['email']}</p>"
    except Exception as e:
        return f"<p>Failed to connect to user-service: {e}</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
