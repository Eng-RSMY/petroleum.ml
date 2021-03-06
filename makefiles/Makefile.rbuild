# prepare the package for release
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)


all: check

# called by check
build-cran:
	cd ..;\
	R CMD build $(PKGSRC)

# called by install
build:
	cd ..;\
	R --no-site-file --no-environ --no-save --no-restore --quiet  \
	CMD build --no-manual $(PKGSRC) --no-resave-data --no-manual


install: build
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz


check: build-cran
	cd ..;\
	R --no-site-file --no-environ --no-save --no-restore --quiet  \
	CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran --timings --no-manual


clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/


README.md : README.Rmd
	R --slave -e 'rmarkdown::render("$<")'

