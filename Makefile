SRC=src
DIST=dist

default: build

build:
	elm make --yes $(SRC)/App.elm --output $(DIST)/app.js
	cp $(SRC)/index.html $(DIST)/

clean:
	rm -fr dist/*
