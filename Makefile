all: gh-pages rd

gh-pages:
	git subtree split --prefix website --branch gh-pages

rd:
	./roxygenate.R

inst/NEWS.Rd: NEWS.md
	Rscript -e "tools:::news2Rd('$<', '$@')"
	sed -r -i 's/`([^`]+)`/\\code{\1}/g' $@
