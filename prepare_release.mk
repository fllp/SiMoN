# Set point release, if not specified
V ?=1.x

define INC_FILES
 README.md \
 SiMoN-Documentation.pdf \
 siciliano.lexc \
 siciliano.twolc \
 GPLv3.txt \
 Makefile \
 hfst_bins.mk
endef

release: docs SiMoN-v$(V).zip

%.zip:
	@zip $@ $(INC_FILES)
