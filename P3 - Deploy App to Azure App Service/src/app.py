# app.py
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    """Renders a sample page."""
    return "Hello, Future Cloud Solution Architect! This is a simple app for P3-Deploy App to Azure App Service. I am so happy to see you here! :)"

if __name__ == '__main__':
    HOST = os.environ.get('SERVER_HOST', 'localhost')
    try:
        PORT = int(os.environ.get('SERVER_PORT', '5555'))
    except ValueError:
        PORT = 5555
    app.run(HOST, PORT)
