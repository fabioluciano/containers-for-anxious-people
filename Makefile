OUTPUTDIR = ./output/

OUTPUTSTRING = -D $(OUTPUTDIR) -a outdir=$(OUTPUTDIR)
PLATUMLSTRING = -a plantuml-config=resources/plantuml/plantuml.cfg
ROUGESTRING = -a rouge-style=pastie
REQUIRESTRING = -r asciidoctor-diagram 
REVEALJSSTRING = -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.8.0

all: clean prepare pdf html presentation

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull asciidoctor/docker-asciidoctor
	mkdir -p $(OUTPUTDIR) 

copy_images:
	cp -r resources/image/ $(OUTPUTDIR)

html: clean prepare copy_images
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor -o index.html $(REQUIRESTRING) $(OUTPUTSTRING) $(PLATUMLSTRING) $(ROUGESTRING) main.adoc

pdf: clean prepare copy_images
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf -o documentation.pdf $(REQUIRESTRING) $(OUTPUTSTRING) $(PLATUMLSTRING) $(ROUGESTRING) main.adoc

presentation: clean prepare copy_images
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-revealjs -o presentation.html $(REQUIRESTRING) $(OUTPUTSTRING) $(PLATUMLSTRING) $(REVEALJSSTRING) main.adoc
