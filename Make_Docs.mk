BIBLIO = doc/bib/references.bib
REFSTYLE = doc/bib/ACL.csl

# setting flags and extensions for pandoc to use on documentation files
define pandoc_flags
-N \
--toc \
--toc-depth=1 \
--latex-engine=xelatex \
--bibliography $(BIBLIO) \
--csl=$(REFSTYLE) \
-V documentclass=report \
-V geometry:margin=3.0cm \
-V fontsize=11pt \
-V linkcolor="black"
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

# doc_files = home.pdoc intro.pdoc compile-use.pdoc lexicon-doc.pdoc roadmap.pdoc

doc_files = $(notdir $(shell find doc -type f -name '*.pandoc' | sort -n));

vpath %.pandoc doc/
docs: SiMoN-Documentation.pdf

# little hack to have variable SPACE contain a whitespace
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

%.pdf: $(doc_files)
	@pandoc $(pandoc_flags) -o $@ -f markdown$(subst $(SPACE),+,$(pandoc_extensions)) $^
	@echo 'Documentation written to' $@
