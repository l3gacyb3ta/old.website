import sqlite3
import click
from flask import current_app, g
from flask.cli import with_appcontext

# https://stackoverflow.com/questions/3300464/how-can-i-get-dict-from-sqlite-query
def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d

def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )

        g.db.row_factory = dict_factory
    g.db.execute("PRAGMA foreign_keys = ON;")
    return g.db

def close_db(e=None):
    db = g.pop('db', None)
    if db is not None:
        db.close()

migrations = [
"""
DROP TABLE IF EXISTS comments;

CREATE TABLE comments
  (
     postid  STRING NOT NULL,
     author  STRING NOT NULL DEFAULT "username",
     website STRING,
     comment STRING NOT NULL,
     timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
  );  
""",
]

def init_db():
    db = get_db()
    for i in range(0, len(migrations)):
        db.executescript(migrations[i])
        db.execute(f"PRAGMA user_version = {i+1}")
        db.commit()
        click.echo(f"migration {i}")

@click.command("migrate")
@with_appcontext
def migrate_command():
    """update database scheme etc"""
    init_db()
    click.echo("ok")

def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(migrate_command)

