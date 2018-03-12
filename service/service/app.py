import flask

from service.api import api
from flask_swagger import swagger


app = flask.Flask(__name__)
app.register_blueprint(api, url_prefix='/api')


@app.route('/api/spec')
def spec():
    swag = swagger(app, from_file_keyword='swagger')
    swag['info']['title'] = "Todo API"
    swag['info']['version'] = "1.0"
    return flask.jsonify(swag)


app.config['JSONIFY_PRETTYPRINT_REGULAR'] = False
