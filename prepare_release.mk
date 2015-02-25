# Set point release, if not specified
V ?=1.x

define INC_FILES
 README.md \
 SiMoN-Documentation.pdf \
 siciliano.lexc \
 siciliano.twolc \
 GPLv3 \
 Makefile \
 hfst_bins.mk
endef

release: docs
	@echo "zip SiMoN-v$(V).zip$(INC_FILES)"
