# Set point release, if not specified
V ?=1.x

define INC_FILES
 README.md \
 SiMoN-Documentation.pdf \
 siciliano.lexc \
 siciliano.twolc \
<<<<<<< HEAD
 GPLv3 \
=======
 GPLv3.txt \
>>>>>>> development
 Makefile \
 hfst_bins.mk
endef

release: docs SiMoN-v$(V).zip

%.zip:
	@zip $@ $(INC_FILES)
