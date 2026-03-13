from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

@app.route('/hunt', methods=['GET'])
def hunt():
    query = request.args.get('query')
    api_key = 'YOUR_SERPAPI_KEY'
    url = f'https://serpapi.com/search.json?engine=google_maps&q={query}&api_key={api_key}'
    response = requests.get(url)
    data = response.json()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)