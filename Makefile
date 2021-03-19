#
# Copyright (c) 2014 Rick Salevsky <rsalevsky@suse.de>
# Copyright (c) 2014, 2015, 2016 Karl Eichwalder <ke@suse.de>
# Copyright (c) 2015, 2016, 2017, 2018 Stefan Knorr <sknorr@suse.de>
#

DAPS_COMMAND=daps

XSLTPROC_COMMAND = xsltproc \
--stringparam generate.toc "/article toc" \
--stringparam generate.section.toc.level 0 \
--stringparam section.autolabel 1 \
--stringparam section.label.includes.component.label 2 \
--stringparam variablelist.as.blocks 1 \
--stringparam toc.section.depth 2 \
--stringparam toc.max.depth 3 \
--stringparam show.comments 0 \
--stringparam profile.os "$(PROFOS)" \
--xinclude --nonet

mainfile = adoc/MAIN.recipes.adoc
prereqs = DC-recipes ${mainfile} adoc/* 
imagereqs = mkdir -p build/.images/color/ && cp -r adoc/images/* build/.images/color/
daps_xslt_rn_dir = /usr/share/daps/daps-xslt/recipes

text_params =

.PHONY: clean pdf html validate

all: validate html pdf

validate: $(prereqs)
	$(DAPS_COMMAND) -d $< validate

pdf: build/recipebook/Innovate-Everywhere-Recipes.pdf
build/recipebook/Innovate-Everywhere-Recipes.pdf: $(prereqs)
	$(imagereqs)
	$(DAPS_COMMAND) -vv -d $< pdf


# the html build does not currently work as the images are not
# copied correctly
# TODO - fix
html: build/recipebook/single-html/Innovate-Everywhere-Recipes/index.html
build/recipebook/single-html/Innovate-Everywhere-Recipes/index.html: $(prereqs)
	$(imagereqs)
	$(DAPS_COMMAND) -d $< html --single \
	  --param="toc.section.depth=2"

clean:
	rm -rf build/
