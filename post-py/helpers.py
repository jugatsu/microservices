from pymongo import MongoClient
from pymongo.errors import ConnectionFailure
from json import dumps

def health(mongo_host, mongo_port):
    postdb = MongoClient(mongo_host, int(mongo_port), serverSelectionTimeoutMS=2000)
    try:
        postdb.admin.command('ismaster')
    except ConnectionFailure:
        postdb_status = 0
    else:
        postdb_status = 1

    status = postdb_status

    with open('VERSION') as f:
        version = f.read()

    healthcheck = {
        'status': status,
        'dependent_services': {
            'postdb': postdb_status
        },
        'version': version.rstrip('\n')
    }
    return dumps(healthcheck)
