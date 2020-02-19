.PHONY: all test clean doc doc-path format watch utop release

all:
	dune build @install
	dune build

install:
	dune install

test:
	dune build @test/runtest -f

clean:
	dune clean

doc:
	dune build @doc

doc-path:
	@echo "_build/default/_doc/_html/index.html"

format:
	dune build @fmt --auto-promote

watch:
	dune build --watch

utop:
	dune utop lib -- -implicit-bindings

release:
	./script/release.sh
