from flask import Blueprint, jsonify, abort, request
from ..models import Tweet, User, db
import hashlib
import secrets


bp = Blueprint('users', __name__, url_prefix='/users')


@bp.route('', methods=['GET'])  # decorator takes path and list of HTTP verbs
def index():
    users = User.query.all()  # ORM performs SELECT query
    result = []
    for u in users:
        result.append(u.serialize())  # build list of Tweets as dictionaries
    return jsonify(result)  # return JSON response


@bp.route('', methods=['POST'])  # decorator takes path and list of HTTP verbs
def create():
    print(request.json['username'])
    if "username" not in request.json or "password" not in request.json:
        return abort(400)

    if len(request.json["username"]) < 3 and len(request.json["password"]) < 8:
        return abort(400)

    u = User(
        username=request.json['username'],
        password=request.json['password']
    )
    db.session.add(u)  # prepare CREATE statement
    db.session.commit()  # execute CREATE statement
    return jsonify(u.serialize())


@bp.route('/<int:id>', methods=['DELETE'])
def delete(id: int):
    u = User.query.get_or_404(id)
    print(u)
    try:
        db.session.delete(u)  # prepare DELETE statement
        db.session.commit()  # execute DELETE statement
        return jsonify(True)
    except:
        # something went wrong :(
        return jsonify(False)


def scramble(password: str):
    """Hash and salt the given password"""
    salt = secrets.token_hex(16)
    return hashlib.sha512((password + salt).encode('utf-8')).hexdigest()


@bp.route('/<int:id>', methods=['PATCH'])
def update(id:int):
    u = User.query.get_or_404(id)
    if "username" in request.json["username"]:
        u.username = request.json["username"]

    if "password" in request.json["password"]:
        u.password =scramble(request.json["password"])
    return jsonify(u.serialize())

@bp.route('/<int:id>/liked_tweets', methods=['GET'])
def liked_tweets(id: int):
    u = User.query.get_or_404(id)
    arr = []
    for t in u.liked_tweets:
        arr.append(t.serialize())

    return jsonify(arr)
