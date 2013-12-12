all: gh-pages

gh-pages:
	git subtree split --prefix website --branch gh-pages
