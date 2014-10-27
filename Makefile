file ?= siciliano
# einfache ersetzung: $(file:%.lexc=%.foo) -> pattern substitution

# use all steps by default and construct word generator
default: build-generator

compile-lexicon-and-rules: siciliano.lexc.hfst siciliano.twolc.hfst

combine-to-analyzer: siciliano.analyzer.hfst

build-generator: siciliano.generator.hfst

# convert XFST files to HFST binary format
%.lexc.hfst: %.lexc
	hfst-lexc $< -o $@
%.twolc.hfst: %.twolc
	hfst-twolc $< -o $@

# combine ruleset and lexicon binaries to analyzer FST
%.analyzer.hfst: %.lexc.hfst %.twolc.hfst
	hfst-compose-intersect $^ -o $@

# invert analyzer for use as generator
%.generator.hfst : %.analyzer.hfst
	hfst-invert $< -o $@

