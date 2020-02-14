.PHONY: all test clean doc doc-path format watch utop release

all:
	dune build

test:
	dune runtest -f

clean:
	dune clean

doc:
	dune build @doc

doc-path:
	@echo "_build/default/_doc/_html/index.html"

format:
	dune build @fmt --auto-promote

watch:
	dune build -p #{self.name} --watch

utop:
	dune utop lib -- -implicit-bindings

release:
	./script/release.sh
