DISTS=$(CURDIR)/dists
TMPDIR=$(CURDIR)/tmp
LATEXDIR=$(CURDIR)/template
SOURCEDIR=$(CURDIR)/src
SCRIPTSDIR=$(CURDIR)/scripts

FILENAME=Template
PDF=${DISTS}/${FILENAME}.pdf

PANDOC_CROSSREF=--filter pandoc-crossref -M "crossrefYaml=cross-ref.config.yml"
PANDOC_OPTIONS=-f markdown -r markdown-auto_identifiers -t latex ${PANDOC_CROSSREF}
PANDOC_PARAMS=${PANDOC_OPTIONS} -o ${LATEXDIR}/${FILENAME}.tex ${SOURCEDIR}/${FILENAME}.md

all: pdf

pdf: tmp
	platex -output-directory=${TMPDIR} ${TMPDIR}/template
	cd ${TMPDIR};	pbibtex template
	platex -output-directory=${TMPDIR} ${TMPDIR}/template
	platex -output-directory=${TMPDIR} ${TMPDIR}/template
	dvipdfmx ${TMPDIR}/template -o ${PDF}

tmp: latex src
	cp -r ${LATEXDIR}/* ${TMPDIR}/
	cp ${SOURCEDIR}/metadata.tex ${TMPDIR}
	cp ${SOURCEDIR}/mybibtex.bib ${TMPDIR}
	cp -r ${SOURCEDIR}/img ${TMPDIR}
	python ${SCRIPTSDIR}/replaceImageImport.py ${TMPDIR}/main.tex
latex: src
	pandoc ${PANDOC_OPTIONS} -o ${TMPDIR}/main.tex ${SOURCEDIR}/main.md
	pandoc ${PANDOC_OPTIONS} -o ${TMPDIR}/abstract.tex ${SOURCEDIR}/abstract.md

clean: 
	rm -r ${TMPDIR}/*