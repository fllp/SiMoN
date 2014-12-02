target ?= siciliano
keep-intermediates ?= no

# setting flags and extensions for pandoc to use on documentation files
define pandoc_flags =
    -N
    --listings
    -V fontsize=12pt
    -V mainfont="Linux Libertine O"
    -V monofont="Dejavu Sans Mono - Book"
    -V geometry:margin=2.5cm
    -V documentclass=report
endef

define pandoc_extensions =
    +fenced_code_blocks
    +pandoc_title_block
    +pipe_tables
    +table_captions
    +header_attributes
    +yaml_metadata_block
endef

# doc_files = home.pdoc intro.pdoc compile-use.pdoc lexicon-doc.pdoc roadmap.pdoc

doc_files = $(notdir $(shell find doc -type f -name '*.pandoc' | sort -n));

# auto-detect AnIta files when in any subdir
# ANITA = $(shell find . -type f -name 'italiano.*' -printf "%P\n" -quit | sed -e "s/\w\+\.\w\+\$//g")
VPATH = ./AnIta-v1.2core:./v1.2core:./*:$(ANITA)

# empties .SECONDARY if set to yes via command line,
# thus rendering intermediates 'important' to keep
ifeq ($(keep-intermediates),yes)
  .SECONDARY:
endif

# use all steps by default and construct morpholocical generator
default: $(target).generator.hfst

# remove HFST binaries and documentation file
.PHONY : clean it-scn.analyzer.hfst %.generator.hfst
clean: $(shell find . -iname '*.hfst') $(shell find . -iname '*.lexc.hfst')
	@rm -f $^ SiMoN-Documentation.pdf

# compiles SiMoN & AnIta in the whole
complete: it-scn.generator.hfst

# convert XFST files to HFST binary format
%.lexc.hfst: %.lexc
	@echo -e '== Step 1: compile lexicon ==\n $^ to binary'
	hfst-lexc $< -o $@
	@echo -e ''

%.twolc.hfst: %.twolc
	@echo -e '== Step 2: compile rules ==\n $^ to binary'
	hfst-twolc $< -o $@
	@echo -e ''

# combine ruleset and lexicon binaries to analyzer FST
%.analyzer.hfst: %.lexc.hfst %.twolc.hfst
	@echo '== Step 3: combine lexicon & rules =='
	hfst-compose-intersect -v $^ -o $@
	@echo -e ''

# invert analyzer for use as generator
%.generator.hfst : %.analyzer.hfst
	@echo '== Step 4: get generator =='
	hfst-invert -v $< -o $@
	@echo -e ''

it-scn.analyzer.hfst: siciliano.analyzer.hfst italiano.analyzer.hfst
	hfst-union -v $^ -o $@

vpath %.pandoc doc/
docs: SiMoN-Documentation.pdf

%.pdf: $(doc_files)
	@pandoc $(pandoc_flags) -o $@ -f markdown$(pandoc_extensions) $^
	@echo 'Documentation written to' $@
