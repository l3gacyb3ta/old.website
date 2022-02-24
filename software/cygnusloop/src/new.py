from flask import (
    Blueprint, render_template, request
)
from .comments import create_comment


bp = Blueprint("new",__name__)

@bp.route("/new/<id>")
def new(id):
    return render_template("new.html", postid=id)

@bp.route("/submit/<id>", methods=["GET", "POST"])
def submit(id):
    if request.method == "POST":
        req = request.form

        if req["comment"] == "":
            return "No empty ;-;"
        else:
            create_comment(id, req["name"], req["website"], req["comment"])
            return "Submitted! <a href=\"/view/"+id+"\">Return to comments</a>"

        return render_template("submited.html", name=req["name"])
    
    else:
        return "whatcha doin ya silly goose"
