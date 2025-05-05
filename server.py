from flask import Flask
import ssl

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello from Flask with mTLS!"

if __name__ == "__main__":
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.load_cert_chain(certfile="server.crt", keyfile="server.key")
    context.load_verify_locations(cafile="ca.crt")  # Trust this CA
    context.verify_mode = ssl.CERT_REQUIRED  # Require client certs

    app.run(host='0.0.0.0', port=5001, ssl_context=context)
