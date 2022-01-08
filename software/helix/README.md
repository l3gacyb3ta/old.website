# helix

helix is a simple static site generator built in [crystal](https://crystal-lang.org). It is a fork of my old project [monis](https://github.com/l3gacyb3ta/monis).

Under my benchmarks (rendering this readme a 100 times), a large site can be generated in less then 25ms!

## Build

To build run `make`, then to install `sudo make install`.  
To build the docs, run `make docs`

## File formating
Template:
```
---
title: "Home page"
permalink: "/index"
---
# Welcome to my website
Hello and welcome!
```
The frontmatter contains the permalink and the title, and the page content is after the frontmatter. Anything defined in the fronmatter will be passed into the jinja theme, so you could do something like this:
```
# content/index.md
---
title: "Home page"
permalink: "/index"
favicon: "/static/favicon.png"
---
# Welcome to my website
Hello and welcome!
```
```
# theme/index.html
<html>
    <head>
        <title>{{ title }}</title>
        <link rel="icon" href="{{ favicon }}">
    </head>
    <body>
        {{ content | safe }}
    </body>
</html>
```

## File structure for sites
`/content`: Anything here gets rendered  
`/static`: These files just get copied over to `/out/static`  
`/theme`: Currently only `index.html` gets used in this, but this is the Jinja2 template for the website.  
`/theme/static`: These are static files for a theme  
`/out`: This is the output of the generator once it has been run !!DONT STORE ANYTHING IMPORTANT HERE IT GETS WIPED ON EACH RUN!!  
`/config.yml`: Anything in here gets passed to the config attribute in the jinja template.
