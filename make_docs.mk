BIBLIO = doc/bib/references.bib
REFSTYLE = doc/bib/ACL.csl
H_INC = doc/pandoc-h-inc.tex
INKSCAPE_CMD ?= inkscape
INKSC_OPTS ?= -C -d=300
INKSCAPE ?= $(INKSCAPE_CMD) $(INKSC_OPTS)

# little hack to have variable SPACE contain a whitespace
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

# setting flags and extensions for pandoc to use on documentation files
define pandoc_flags
-N \
--toc \
--toc-depth=1 \
--latex-engine=xelatex \
--include-in-header=$(H_INC) \
--bibliography $(BIBLIO) \
--csl=$(REFSTYLE) \
-V documentclass=report \
-V geometry:margin=3.0cm \
-V fontsize=11pt \
-V linkcolor="green"
endef

# disabled flags:
# -V mainfont="Linux Libertine O" \
# --listings \
# -V monofont="Dejavu Sans Mono - Book" \

define pandoc_extensions
 fenced_code_blocks\
 yaml_metadata_block\
 pipe_tables\
 table_captions\
 header_attributes
endef

# disabled extensions:
# mmd_title_block\
#  pandoc_title_block\

# search for .pandoc files
doc_files = $(notdir $(shell find doc -type f -name '*.pandoc' | sort -n))

# search for .svg files
svg_sources = $(basename $(shell find doc/img -type f -iname '*.svg' -printf '%p ') )
# create names of target PNGs
png_exports = $(addsuffix .png, $(svg_sources))

vpath %.pandoc doc/

docs: SiMoN-Documentation.pdf
# SiMoN-Documentation.pdf: graphics

graphics: $(png_exports)

%.pdf: $(doc_files)
	@echo $(doc_files)
	@pandoc $(pandoc_flags) -o $@ -f markdown$(subst $(SPACE),+,$(pandoc_extensions)) $^
	@echo 'Documentation written to' $@

%.png: %.svg
	$(INKSCAPE) -f $< -e $@
