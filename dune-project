(lang dune 2.7)

(name inquire)

(documentation "https://tmattio.github.io/inquire/")

(source
 (github tmattio/inquire))

(license MIT)

(cram enable)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

(package
 (name inquire)
 (synopsis "Create beautiful interactive command line interface in OCaml")
 (description
  "\240\159\142\168 Create beautiful interactive command line interface in OCaml.")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  (odoc :with-doc)))
