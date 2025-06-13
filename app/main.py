from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "CI/CD is working!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

#ok
#ok2
#ok3
#ok4
#ok5