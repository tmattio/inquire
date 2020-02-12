(lang dune 1.11)
(name inquire)
(version 0.1.0)
(source (github tmattio/inquire))
(license MIT)
(authors "Thibaut Mattio")
(maintainers "Thibaut Mattio")

(using fmt 1.2)
(generate_opam_files true)

(package
 (name inquire)
 (synopsis "An OCaml library to create beautiful interactive CLIs")
 (depends
  dune
  alcotest
  base
  lwt
  lambda-term))
