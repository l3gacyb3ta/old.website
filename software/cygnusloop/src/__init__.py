from flask import (
    Flask
)
from .db import get_db
from timeago import format as time_since
from datetime import datetime
import os

def create_app():
    app = Flask(__name__, instance_relative_config=True, static_folder="web/static", template_folder='web/templates')
    app.config.from_mapping(
        SECRET_KEY="dev",
        DATABASE=os.path.join(app.instance_path, "database.db"),
    )
    app.config.from_pyfile("config.py", silent=True)
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    app.jinja_env.trim_blocks = True
    app.jinja_env.lstrip_blocks = True

    from . import db
    db.init_app(app)

    from . import view
    app.register_blueprint(view.bp)

    from . import new
    app.register_blueprint(new.bp)

    return app

app = create_app()

@app.template_filter("since")
def since(text):
    """Convert a string to all caps."""
    return time_since(text, datetime.utcnow())