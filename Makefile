all: rd inst

gh-pages:
	git subtree split --prefix website --branch gh-pages

rd:
	crant -X

inst: inst/NEWS.Rd inst/defaults/config/global.dcf .FORCE
	cd defaults && mkdir -p $$(cat empty_dirs.txt) && for f in full minimal; do tar cf ../inst/defaults/$${f}.tar $$f; done

inst/NEWS.Rd: NEWS.md
	Rscript -e "tools:::news2Rd('$<', '$@')"
	sed -r -i 's/`([^`]+)`/\\code{\1}/g' $@

inst/defaults/config/global.dcf: DESCRIPTION defaults/config/global.dcf
	(echo "version: $$(sed -n '/^Version:/ s/Version: //p' DESCRIPTION)"; cat defaults/config/global.dcf) > inst/defaults/config/global.dcf
	git add $@
	git commit --amend --no-edit
	crant -iC
	crant -X

tag:
	git tag v$$(sed -n -r '/^Version: / {s/.* ([0-9.-]+)$$/\1/;p}' DESCRIPTION)

bump-cran-desc: rd
	crant -u 2 -C

bump-gh-desc: rd
	crant -u 3 -C

bump-desc: rd
	test "$$(git status --porcelain | wc -c)" = "0"
	sed -i -r '/^Version: / s/( [0-9.]+)$$/\1-0.0/' DESCRIPTION
	git add DESCRIPTION
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "Add suffix -0.0 to version"
	crant -u 4 -C

bump-cran: bump-cran-desc inst/defaults/config/global.dcf tag

bump-gh: bump-gh-desc inst/defaults/config/global.dcf tag

bump: bump-desc inst/defaults/config/global.dcf tag

.FORCE:
