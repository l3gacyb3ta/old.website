# nebula - A digital garden for the ages

This is a from-scratch rewrite of my site currently at [raleighwi.se](https://raleighwi.se), tough that domain will be gone as soon as it expires.

## File layout

- `./site/` : The site's source (not code, just content)
	- `content/` : The content of the site
		- `*.md` : The posts and pages in the blog/site/garden
		- `static/` : Where non-theme static things go (images, files, etc.)
	- `theme/` : The theme and itss associated files
		- `index.html.j2` : The Jinja2 template used for all pages
		- `static/` : The theme-specific static content (js, css, etc.)
			- `stylesheet.css` : The theme for the entire site
			- `default.min.css` : The theme for highlight.js
			- `highlight.min.js` : A small custom highlight.js package for highlighting
	- `out/` : When running `helix`, output is put here
- `./software/` : All of the software used in nebula
	- `carina/` : Tools for content creation
		- `carina` : A script to automate creation of files and publishing
	- `helix/` : The static site that is in the center of this whole endeavour
		- `src/` : Source code for helix
		- `lib/` : The code for the dependencies of helix
	- `starport/` : The build workflow for nebula
		- `vangaurd/` : An automatic builder, sort of like a Makefile, but different
			- `src/` : Vangaurd's source code
		- `git/` : The git tools used to smooth out production
			- `hooks/` : Git hooks used on the server and on my laptops for CI/CD
- `./design/` : The design documents for this project
	- `art/` : A place for art specifically
	- `*.md` : The various deign docs used in the creation of nebula
- `./bin/` : A place to put up to date binaries of software
- `./www/` : What gets servered

### Files in root
- `Makefile` : run make to build all components from source
- `Caddyfile` : Caddy configuration, to be moved to starship
- `todo.md` : An Up-To-Date-ish todo list.

Keep in mind, 95% of these locations have a README, so READTHEM.

## Design
The philosphy and insipiration are in [`design/ideas`](core.md) and there are some krita scribbles in the `design` folder as well. [`design/technical`](design/technical) follows the technical side of the project, with the software (I will be writing my own static site generator!) and webdev stuff going there, and [`design/art`](design/art) will follow the artistic side of site design. If I ever get this running on hardware I own I'll make a page for that aswell.

## Licensing
The raw code for this site sits under an Unlicense, and the content (anything other than raw source code, so art, text, music, etc.) is under a CC BY-SA 4.0 license.
