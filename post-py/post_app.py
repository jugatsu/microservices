from flask import Flask, request
from pymongo import MongoClient
from bson.objectid import ObjectId
from bson.json_util import dumps
import os


mongo_host = os.getenv('POST_DATABASE_HOST', '127.0.0.1')
mongo_port = os.getenv('POST_DATABASE_PORT', '27017')
mongo_database = os.getenv('POST_DATABASE', 'test')

client = MongoClient(mongo_host, int(mongo_port)).user_posts
mongo_db = client.posts

app = Flask(__name__)


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
    return 'OK'


@app.route("/post/<id>")
def get_post(id):
    post = mongo_db.find_one({'_id': ObjectId(id)})
    return dumps(post)



if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
