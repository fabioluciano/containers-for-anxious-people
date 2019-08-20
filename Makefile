all: clean prepare pdf html presentation

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull asciidoctor/docker-asciidoctor