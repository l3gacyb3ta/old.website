# cygnus loop
loop into cygnus with this new comments system!

## Stack
```
┌───────────────────────────────────────┐
│                                       │
│                                       │
│     nebula : through an iframe        │
│                                       │
│                                       │
└───────▲───────────────────────────────┘
        │
        │
┌───────┴───────┐        ┌──────────────┐
│               │        │              │
│               ├───────►│              │
│   Flask       │        │   SQLite db  │
│               │◄───────┤              │
│               │        │              │
└───────▲───────┘        └──────────────┘
        │
        │
┌───────┴───────────────────────────────┐
│                                       │
│                                       │
│            Pythonanywhere             │
│                                       │
│                                       │
└───────────────────────────────────────┘
```

## Running

Make sure you have [poetry](https://python-poetry.org/) and [direnv](https://direnv.net/).

1. Install requirements: `poetry install`
1. Setup Database: `poetry run flask migrate`
1. Run app: `poetry run flask run`
