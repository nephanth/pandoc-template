BUILDDIR=build
FILENAME=report

#change to beamer if needed
TYPE=article

ifeq ($(TYPE), article)
	DEFAULTS_FILE=resources/pandoc/article.yaml
else ifeq ($(TYPE), beamer)
	DEFAULTS_FILE=resources/pandoc/beamer.yaml
else
    $(error wrong TYPE $(TYPE))
endif


all: $(FILENAME).pdf

$(FILENAME).pdf: $(BUILDDIR)/$(FILENAME).pdf
	cp $< $@

$(BUILDDIR)/resources: resources | $(BUILDDIR)
	cd $(BUILDDIR);  ln -s ../resources .


$(BUILDDIR)/%.pdf: $(BUILDDIR)/%.tex | $(BUILDDIR)/resources 
	cd $(BUILDDIR) ; \
	lualatex $(FILENAME) ; \
	biber $(FILENAME) ; \
	lualatex $(FILENAME) ; \
	lualatex $(FILENAME)

$(BUILDDIR)/%.tex: %.md resources | $(BUILDDIR)
	pandoc $< \
	--defaults $(DEFAULTS_FILE) \
	--output=$@


$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm build/*
