from flask import (
    render_template, Blueprint
)
from .comments import get_comments_by_id
from datetime import datetime
from timeago import format as time_since

bp = Blueprint("view",__name__)

def since(text):
    """Convert a string to all caps."""
    return time_since(text, datetime.utcnow())
bp.add_app_template_filter(since, "since")

@bp.route("/view/<id>")
def test(id):
    comments = get_comments_by_id(str(id))
    return render_template("view_comment.html", comments=comments, postid=id)
