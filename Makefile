all: clean prepare pdf html presentation

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull asciidoctor/docker-asciidoctor

html:
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor -o index.html -r asciidoctor-diagram  -D output -a plantuml-config=resources/plantuml/plantuml.cfg main.adoc

pdf: prepare clean
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf -o documentation.pdf -r asciidoctor-diagram  -D output -a plantuml-config=resources/plantuml/plantuml.cfg main.adoc

presentation:
	docker run --rm -v $(CURDIR):/documents/ asciidoctor/docker-asciidoctor asciidoctor-revealjs -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.8.0 -o presentation.html -r asciidoctor-diagram  -D output -a plantuml-config=resources/plantuml/plantuml.cfg main.adoc