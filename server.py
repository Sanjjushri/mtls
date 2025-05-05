from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello from Flask with mTLS!"

if __name__ == "__main__":
    context = ('server.crt', 'server.key')  # Server's certificate and key
    app.run(host='0.0.0.0', port=5001, ssl_context=context)
