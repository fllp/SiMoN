SiMoN - sicilian morphology for the AnIta morphological parser
==============================================================

SiMoN is a semi-standalone morphological parser for the Sicilian language. It's purpose is to act as an extension to AnIta Italian morphological parser and provide Sicilian morphological paradigms for processing in parallel to Italian
The underlying technology are finite state transducers, namely the implementation of the *Helsinki Finite State Transducer*(HFST) project.
The notation format used is the XFST syntax.

Features
-------------

Currently supported is the morphology of regular verbal conjugation with a lexicon of roughly 60 regular verbs plus an automatically extracted list of ~300 verbs from wikipedia (unchecked).

License
-------------

to be determined

Documentation
-------------

The documentation for SiMoN can be found either in *doc/* or as PDF (for release versions)

Changelog/Roadmap
-------------

**Released** versions are bold,
*planned* features italic.

SiMoN 1.1

*add frequent irregular verbs*
*include custom morpho-phonetic rules for Sicilian*

SiMoN 1.0

Initial puplic release
including regular verbal morphology
+ auxiliary verbs *fari*, *siri/essiri*, *aviri*
