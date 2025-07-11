from flask import Flask, request, render_template, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Prometheus metrics
REQUEST_COUNT = Counter('flask_app_request_count', 'Total number of HTTP requests', ['method', 'endpoint'])

@app.route('/')
def hello_world():
    REQUEST_COUNT.labels(method='GET', endpoint='/').inc()
    return 'Hello from Flask!'

@app.route('/login', methods=['GET', 'POST'])
def login():
    REQUEST_COUNT.labels(method=request.method, endpoint='/login').inc()
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username == 'admin' and password == 'password':
            return f"Welcome, {username}!"
        else:
            return "Invalid credentials"
    return render_template('login.html')

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
