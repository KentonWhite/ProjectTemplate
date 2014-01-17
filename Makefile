all: gh-pages rd

gh-pages:
	git subtree split --prefix website --branch gh-pages
	git push --force origin gh-pages:gh-pages
	git branch -D gh-pages

rd:
	./roxygenate.R
