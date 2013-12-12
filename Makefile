all: gh-pages rd

gh-pages:
	git subtree split --prefix website --branch gh-pages

rd:
	./roxygenate.R
