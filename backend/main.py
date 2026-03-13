from flask import Flask, request
import openai
import requests

app = Flask(__name__)

@app.route('/hunt', methods=['GET'])
def hunt():
    # Code for interacting with SerpApi and OpenAI goes here
    return "Hunting leads..."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)