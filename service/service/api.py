from flask import Blueprint, jsonify


api = Blueprint('api', __name__)


@api.route('/version')
def version():
    """
    swagger: swagger/version.yml
    """
    return jsonify({
        "release": 1
    })
