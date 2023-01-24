
.SUFFIXES : .tex .dtx .dvi .ps .pdf .sty .cls

MAIN = sidecap
DIST_DIR = $(MAIN)
DIST_FILES = README.md $(MAIN).ins $(MAIN).dtx $(MAIN).pdf sc-test?.tex \
	scraggeddemo.tex
VERSION = $(shell awk '/ProvidesPackage/{print $$2}' $(MAIN).dtx)#             
ARCHNAME = $(MAIN)-$(VERSION).zip

ifneq ($(findstring pdf,$(MAKECMDGOALS)),)
  LATEX = pdflatex
else
  LATEX = latex 
endif

all : $(MAIN).pdf demo

pdf : $(MAIN).pdf 

%.ps : %.dvi
	dvips -Pwww $< -o $@
	
%.dvi %.pdf %.glo %.idx: %.tex
	$(LATEX) $<
	
%.dvi %.pdf %.glo %.idx: %.dtx
	$(LATEX) $<
	
%.gls : %.glo
	makeindex -s gglo.ist -t $(basename $@).glg -o $@ $<	
	
%.ind : %.idx
	makeindex -s gind.ist -t $(basename $@).ilg -o $@ $<	
	
$(MAIN).dvi $(MAIN).pdf : $(MAIN).dtx $(MAIN).gls $(MAIN).ind
	$(LATEX) $<
        
$(MAIN).sty : $(MAIN).dtx
	tex $*.ins   
	
demo : scraggeddemo.pdf

scraggeddemo.pdf : scraggeddemo.tex $(MAIN).sty
        		
arch : 
	zip $(MAIN).zip Makefile $(MAIN).dtx $(MAIN).ins

dist : $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)
	
