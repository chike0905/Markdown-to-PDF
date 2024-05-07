DISTS=$(CURDIR)/dists
TMPDIR=$(CURDIR)/tmp
LATEXDIR=$(CURDIR)/template
SOURCEDIR=$(CURDIR)/src
SCRIPTSDIR=$(CURDIR)/scripts
SUBMISSIONDIR=$(CURDIR)/submission

FILENAME=Template
PDF=${DISTS}/${FILENAME}.pdf

PANDOC_CROSSREF=--filter pandoc-crossref -M "crossrefYaml=cross-ref.config.yml"
PANDOC_OPTIONS=-f markdown -r markdown-auto_identifiers -t latex ${PANDOC_CROSSREF}
PANDOC_PARAMS=${PANDOC_OPTIONS} -o ${LATEXDIR}/${FILENAME}.tex ${SOURCEDIR}/${FILENAME}.md

all: pdf

pdf: tmp
	cd ${TMPDIR}; platex -output-directory=${TMPDIR} template
	cd ${TMPDIR};	pbibtex template
	cd ${TMPDIR}; platex -output-directory=${TMPDIR} template
	cd ${TMPDIR}; platex -output-directory=${TMPDIR} template
	cd ${TMPDIR}; dvipdfmx template -o ${PDF}

tmp: latex src
	cp -r ${LATEXDIR}/* ${TMPDIR}/
	cp ${SOURCEDIR}/metadata.tex ${TMPDIR}
	cp ${SOURCEDIR}/mybibtex.bib ${TMPDIR}
	cp -r ${SOURCEDIR}/img ${TMPDIR}
	python ${SCRIPTSDIR}/replaceImageImport.py ${TMPDIR}/main.tex
latex: src
	pandoc ${PANDOC_OPTIONS} -o ${TMPDIR}/main.tex ${SOURCEDIR}/main.md
	pandoc ${PANDOC_OPTIONS} -o ${TMPDIR}/abstract.tex ${SOURCEDIR}/abstract.md

submission: tmp ${SUBMISSIONDIR}
	cd ${TMPDIR}; latexpand -o ${SUBMISSIONDIR}/main.tex template.tex
	cp -r ${LATEXDIR}/* ${SUBMISSIONDIR}/
	rm ${SUBMISSIONDIR}/template.tex
	cp ${SOURCEDIR}/mybibtex.bib ${SUBMISSIONDIR}
	cp -r ${SOURCEDIR}/img ${SUBMISSIONDIR}
	
submission-pdf: submission
	cd ${SUBMISSIONDIR}; platex -output-directory=${SUBMISSIONDIR} main
	cd ${SUBMISSIONDIR}; pbibtex main
	cd ${SUBMISSIONDIR}; platex -output-directory=${SUBMISSIONDIR} main
	cd ${SUBMISSIONDIR}; platex -output-directory=${SUBMISSIONDIR} main
	cd ${SUBMISSIONDIR}; dvipdfmx ${SUBMISSIONDIR}/main

submission-clean: 
	rm -r submission/*

clean: 
	rm -r ${TMPDIR}/*