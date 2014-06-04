all: rd inst

gh-pages:
	git subtree split --prefix website --branch gh-pages

rd:
	./roxygenate.R

inst: inst/NEWS.Rd inst/defaults/config/global.dcf .FORCE
	cd defaults && mkdir -p $$(cat empty_dirs.txt) && for f in full minimal; do tar cf ../inst/defaults/$${f}.tar $$f; done

inst/defaults/config/global.dcf: DESCRIPTION defaults/config/global.dcf
	(echo "version: $$(sed -n '/^Version:/ s/Version: //p' DESCRIPTION)"; cat defaults/config/global.dcf) > inst/defaults/config/global.dcf

inst/NEWS.Rd: NEWS.md
	Rscript -e "tools:::news2Rd('$<', '$@')"
	sed -r -i 's/`([^`]+)`/\\code{\1}/g' $@

.FORCE:
