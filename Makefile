OUTPUTDIR = ./output/

OUTPUTSTRING = -D $(OUTPUTDIR) -a outdir=$(OUTPUTDIR)
PLATUMLSTRING = -a plantuml-config=resources/plantuml/plantuml.cfg
ROUGESTRING = -a rouge-style=pastie
REQUIRESTRING = -r asciidoctor-diagram 
PDFOPTIONS = -a allow-uri-read
REVEALJSSTRING = -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.8.0

all: clean prepare pdf html presentation

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	#docker pull asciidoctor/docker-asciidoctor
	mkdir -p $(OUTPUTDIR) 

copy_images:
	cp -r resources/image/ $(OUTPUTDIR)

html: clean prepare copy_images
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor -o index.html $(REQUIRESTRING) $(OUTPUTSTRING) $(PLATUMLSTRING) $(ROUGESTRING) README.adoc

pdf: clean prepare copy_images
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf -o documentation.pdf $(REQUIRESTRING) $(OUTPUTSTRING) $(PLATUMLSTRING) $(ROUGESTRING) $(PDFOPTIONS) README.adoc

presentation: clean prepare copy_images
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-revealjs -o presentation.html $(REQUIRESTRING) $(OUTPUTSTRING) $(PLATUMLSTRING) $(REVEALJSSTRING) README.adoc
