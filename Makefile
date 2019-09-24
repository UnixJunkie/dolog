.PHONY: build clean edit install reinstall uninstall test

build:
	dune build @install

clean:
	dune clean

edit:
	emacs src/*.ml &

install: build
	dune install

reinstall: build
	dune uninstall
	dune install

uninstall:
	dune uninstall

# tests / example
test:
	dune build _build/default/src/test.exe
	_build/default/src/test.exe
	dune build _build/default/src/example.exe
	_build/default/src/example.exe
