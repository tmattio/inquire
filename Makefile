
.PHONY: all
all:
	dune build @install
	dune build


.PHONY: dev
dev:
	opam install dune-release merlin ocamlformat utop
	opam install --deps-only --with-test --with-doc -y .

.PHONY: install
install:
	dune install

.PHONY: test
test:
	dune build @test/runtest -f

.PHONY: clean
clean:
	dune clean

.PHONY: doc
doc:
	dune build @doc

.PHONY: doc-path
doc-path:
	@echo "_build/default/_doc/_html/index.html"

.PHONY: format
format:
	dune build @fmt --auto-promote

.PHONY: watch
watch:
	dune build --watch

.PHONY: utop
utop:
	dune utop lib -- -implicit-bindings

.PHONY: release
release:
	./script/release.sh
