OUTPUTDIR = ./output/

PDFOPTIONS = -r asciidoctor-diagram -a allow-uri-read -a pdf-theme=src/resources/themes/default-theme.yml
HTMLOPTIONS = -r asciidoctor-diagram -a toc=left -a docinfo=shared
REVEALJSOPTIONS = -r asciidoctor-diagram -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.8.0
OUTPUTFILE_HTML = index.html
OUTPUTFILE_PDF = resume-raw.pdf
OUTPUTFILE_PRESENTATION = presentation.html

CONTAINER_NAME = fabioluciano/containers-for-anxious-people
TRAVIS_TAG ?= latest
TAG_NAME = ${TRAVIS_TAG}

all: clean prepare copy_assets build_html build_pdf build_presentation optimize_pdf build_docker_image

clean:
	sudo rm -rf $(OUTPUTDIR)

prepare:
	docker pull asciidoctor/docker-asciidoctor
	mkdir ${OUTPUTDIR}

copy_assets:
	cp -r src/resources/image/ $(OUTPUTDIR)

build_html:
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor \
		-o $(OUTPUTDIR)$(OUTPUTFILE_HTML) $(HTMLOPTIONS) -q src/README.adoc

build_pdf:
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf \
		$(PDFOPTIONS) -o $(OUTPUTDIR)$(OUTPUTFILE_PDF) -q src/README.adoc

build_presentation:
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-revealjs \
		-q -o $(OUTPUTDIR)$(OUTPUTFILE_PRESENTATION) $(REVEALJSOPTIONS) -q src/README.adoc

optimize_pdf:
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dPrinted=false \
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile=$(OUTPUTDIR)resume.pdf $(OUTPUTDIR)resume-raw.pdf

build_docker_image:
	tar -czvf output.tar.gz -C output .
	docker build -t ${CONTAINER_NAME}:$(TAG_NAME) --build-arg DEPLOYMENT=output.tar.gz .
	rm output.tar.gz

push_docker_image:
	echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
	docker push ${CONTAINER_NAME}:$(TAG_NAME)