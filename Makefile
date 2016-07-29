all: rd

git:
	test "$$(git status --porcelain | wc -c)" = "0"

master: git
	test $$(git rev-parse --abbrev-ref HEAD) = "master"

gh-pages:
	git subtree split --prefix website --branch gh-pages

rd: git
	Rscript -e "library(methods); devtools::document()"
	git add man/ NAMESPACE
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "document"

inst/defaults/full/config/global.dcf: git DESCRIPTION
	( echo -n "version: "; sed -n -r '/^Version: / {s/.* ([0-9.-]+)$$/\1/;p}' $(word 2,$^); tail -n +2 $@ ) > $@.tmp
	mv $@.tmp $@
	git add $@
	git commit --amend --no-edit
	crant -iC
	crant -XS
	git add man
	git commit --amend --no-edit

tag:
	(echo Release v$$(sed -n -r '/^Version: / {s/.* ([0-9.-]+)$$/\1/;p}' DESCRIPTION); echo; sed -n '/^===/,/^===/{:a;N;/\n===/!ba;p;q}' NEWS.md | head -n -3 | tail -n +3) | git tag -a -F /dev/stdin v$$(sed -n -r '/^Version: / {s/.* ([0-9.-]+)$$/\1/;p}' DESCRIPTION)

bump-cran-desc: master rd
	crant -u 2 -C

bump-gh-desc: master rd
	sed -i -r '/^Version: / s/( [0-9.]+)$$/\1-0/' DESCRIPTION
	git add DESCRIPTION
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "add suffix -0 to version"
	crant -u 3 -C

bump-desc: master rd
	sed -i -r '/^Version: / s/( [0-9.]+)$$/\1-0.0/' DESCRIPTION
	git add DESCRIPTION
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "add suffix -0.0 to version"
	crant -u 4 -C

bump-cran: bump-cran-desc inst/defaults/full/config/global.dcf inst/NEWS.Rd tag

bump-gh: bump-gh-desc inst/defaults/full/config/global.dcf inst/NEWS.Rd tag

bump: bump-desc inst/defaults/full/config/global.dcf inst/NEWS.Rd tag

bootstrap_snap:
	curl -L https://raw.githubusercontent.com/krlmlr/r-snap-texlive/master/install.sh | sh
	curl -L https://raw.githubusercontent.com/krlmlr/r-snap/master/install.sh | sh

test:
	Rscript -e "update.packages(repos = 'http://cran.rstudio.com')"
	Rscript -e "options(repos = 'http://cran.rstudio.com'); devtools::install_deps(dependencies = TRUE)"
	Rscript -e "devtools::check(document = FALSE, check_dir = '.', cleanup = FALSE)"
	! egrep -A 5 "ERROR|WARNING|NOTE" ../*.Rcheck/00check.log
