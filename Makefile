target ?= siciliano
keep-intermediates ?= no

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

include Make_Docs.mk

# compiles SiMoN & AnIta in the whole
complete: it-scn.generator.hfst

check: check-dep_hfst-lexc check-dep_hfst-twolc check-dep_hfst-invert check-dep_hfst-compose-intersect check-dep_hfst-union

check-dep_%:
	@echo 'Checking dependency: $(*) \n' $$(\
	    which $* &>/dev/null && echo 'Found in: '|| \
	    echo FAIL: '$(*) not found!\nPlease install HFST (https://kitwiki.csc.fi/twiki/bin/view/KitWiki/HfstDownloads).' \
	    )

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
