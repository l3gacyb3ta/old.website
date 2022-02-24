from flask import (
    render_template, Blueprint
)
from .comments import get_comments_by_id


bp = Blueprint("view",__name__)

@bp.route("/view/<id>")
def test(id):
    comments = get_comments_by_id(str(id))
    return render_template("view_comment.html", comments=comments, postid=id)
