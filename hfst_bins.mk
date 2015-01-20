# compiles SiMoN & AnIta in the whole
complete: it-scn.generator.hfst

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
