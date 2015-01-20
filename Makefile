target ?= siciliano
keep-intermediates ?= no

.PHONY : clean complete

# auto-detect AnIta files when in any subdir
# ANITA = $(shell find . -type f -name 'italiano.*' -printf "%P\n" -quit | sed -e "s/\w\+\.\w\+\$//g")
VPATH = ./AnIta-v1.2core:./v1.2core:./*:$(ANITA)

# empties .SECONDARY if set to yes via command line,
# thus rendering intermediates 'important' to keep
ifeq ($(keep-intermediates),yes)
  .SECONDARY:
endif

default: check SiMoN

# construct morpholocical analyzer/generator pair
SiMoN: $(target).generator.hfst

# remove HFST binaries and documentation file
clean: $(shell find . -iname '*.hfst') $(shell find . -iname '*.lexc.hfst')
	@rm -f $^

include *.mk
