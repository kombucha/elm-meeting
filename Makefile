SRC=src
DIST=dist

default: build

build: build-app build-styles build-resources

build-app:
	elm make --yes $(SRC)/App.elm --output $(DIST)/app.js

build-styles:
	cp $(SRC)/styles.css $(DIST)/

build-resources:
	cp $(SRC)/index.html $(DIST)/
	mkdir -p $(DIST)/resources/
	cp -a $(SRC)/resources/. $(DIST)/resources/

clean:
	rm -fr dist/*
