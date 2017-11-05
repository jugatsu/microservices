from flask import Flask, request, Response
from pymongo import MongoClient
from bson.objectid import ObjectId
from bson.json_util import dumps
from helpers import health
import os
import prometheus_client
import time

CONTENT_TYPE_LATEST = str('text/plain; version=0.0.4; charset=utf-8')
REQUEST_DB_LATENCY = prometheus_client.Histogram('post_read_db_seconds', 'Request DB time')
POST_COUNT = prometheus_client.Counter('post_count', 'A counter of new posts')

mongo_host = os.getenv('POST_DATABASE_HOST', '127.0.0.1')
mongo_port = os.getenv('POST_DATABASE_PORT', '27017')
mongo_database = os.getenv('POST_DATABASE', 'test')

client = MongoClient(mongo_host, int(mongo_port)).user_posts
mongo_db = client.posts

app = Flask(__name__)


@app.route('/metrics')
def metrics():
    return Response(prometheus_client.generate_latest(), mimetype=CONTENT_TYPE_LATEST)

@app.route("/posts")
def posts():
    posts = mongo_db.find().sort('created_at', -1)
    return dumps(posts)


@app.route("/vote", methods=['POST'])
def vote():
    post_id = request.values.get("id")
    vote_type = request.values.get("type")
    post = mongo_db.find_one({'_id': ObjectId(post_id)})
    post['votes'] += int(vote_type)
    mongo_db.update_one({'_id': ObjectId(post_id)}, {"$set": {"votes": post['votes']}})
    return 'OK'


@app.route("/add_post", methods=['POST'])
def add_post():
    title = request.values.get("title")
    link = request.values.get("link")
    created_at = request.values.get("created_at")
    mongo_db.insert({"title": title, "link": link, "created_at": created_at, "votes": 0})
    POST_COUNT.inc()
    return 'OK'


@app.route("/post/<id>")
def get_post(id):
    start_time = time.time()
    post = mongo_db.find_one({'_id': ObjectId(id)})
    stop_time = time.time()  # + 0.3
    resp_time = stop_time - start_time
    REQUEST_DB_LATENCY.observe(resp_time)
    return dumps(post)


@app.route("/healthcheck")
def healthcheck():
    return health(mongo_host, mongo_port)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
