
.SUFFIXES : .tex .dtx .dvi .ps .pdf .sty .cls

MAIN = sidecap

ifneq ($(findstring pdf,$(MAKECMDGOALS)),)
  LATEX = pdflatex
else
  LATEX = latex 
endif

all : $(MAIN).dvi $(MAIN).ps demo

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
	
demo : scraggeddemo.ps

scraggeddemo.ps : scraggeddemo.dvi 

scraggeddemo.dvi : scraggeddemo.tex $(MAIN).sty
        		
arch : 
	zip $(MAIN).zip Makefile $(MAIN).dtx $(MAIN).ins
