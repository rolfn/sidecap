
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

$(MAIN).pdf : $(MAIN).dtx
	$(LATEX) $<
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(LATEX) $<
	$(LATEX) $<
        
$(MAIN).sty : $(MAIN).dtx
	tex $*.ins   
	
demo : scraggeddemo.pdf

scraggeddemo.pdf : scraggeddemo.tex $(MAIN).sty

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc *.lof 

veryclean : clean
	$(RM) $(MAIN).pdf $(MAIN).cls $(ARCHNAME)

arch : 
	zip $(MAIN).zip Makefile $(MAIN).dtx $(MAIN).ins

dist : $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)
	
