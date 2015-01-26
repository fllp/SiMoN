# compiles SiMoN & AnIta in the whole
bundle: it-scn.analyzer.hfst

check: hfst-lexc hfst-twolc hfst-invert hfst-compose-intersect hfst-union

hfst-%:
	@echo Checking for hfst-$*... $$(\
	    command -v hfst-$* >/dev/null && echo YES || { echo FAIL: hfst-$* not found: Please install! && exit 1;}\
	)

# convert XFST files to HFST binary format
%.lexc.hfst: %.lexc
	@echo -e '\n== Step 1: compile lexicon ==\n $^ to binary'
	hfst-lexc $< -o $@
	@echo -e ''

%.twolc.hfst: %.twolc
	@echo -e '== Step 2: compile rules ==\n $^ to binary'
	hfst-twolc $< -o $@
	@echo -e ''

# combine ruleset and lexicon binaries to generator FST
%.generator.hfst: %.lexc.hfst %.twolc.hfst
	@echo '== Step 3: combine lexicon & rules =='
	hfst-compose-intersect -v $^ -o $@
	@echo -e ''

# invert analyzer for use as analyzer
%.analyzer.hfst : %.generator.hfst
	@echo '== Step 4: get analyzer =='
	hfst-invert -v $< -o $@
	@echo -e ''

it-scn.generator.hfst: siciliano.generator.hfst italiano.generator.hfst
	hfst-union -v $^ -o $@
