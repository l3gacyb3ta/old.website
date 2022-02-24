from .db import get_db
from flask import (
    Blueprint, render_template
)

def get_comments_by_id(post_id : str) -> dict:
    """Get all the comments from the """
    db = get_db()
    tags = db.execute("""SELECT * FROM comments WHERE postid = ? ORDER BY timestamp DESC""",(post_id,)).fetchall()

    return tags

def create_comment(post_id : str, author : str, website : str, comment : str) -> None:
    """Create a comment, given the data passed through, and save it in the database"""
    db = get_db()

    db.execute("""INSERT INTO comments(postid, author, website, comment) VALUES(?, ?, ?, ?);""",(post_id, author, website, comment,))
    db.commit()

bp = Blueprint("thread", __name__, url_prefix="/thread")

