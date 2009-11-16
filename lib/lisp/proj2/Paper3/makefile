Src=multipipes
Out=~/multipipes.pdf
all: dvi pdf finished

dvi:
	latex $(Src).tex
	bibtex $(Src)
	latex $(Src).tex
	latex $(Src).tex

pdf:
	dvipdf $(Src).dvi $(out)
	cp $(Src).pdf ~/

finished:
	@printf "\n\n-.,_,.-=^=-.,_,.-=^=-.,_,.-=^=-.,_,.-=^=-.,_,.-=^=\n"
	@printf "Output pdf at: $(Out)\n\n"

clean:
	rm -f *.dvi *.log *.aux *.pdf

update:
	svn update
	latex $(Src).tex
	bibtex $(Src)
	latex $(Src).tex
	latex $(Src).tex
	dvipdf $(Src).dvi $(out)
	mv multipipes.pdf ~/public_html/multipipes.pdf
	
