(lang dune 2.0)

(name inquire)

(version 0.1.0)

(source
 (github tmattio/inquire))

(documentation "https://tmattio.github.io/inquire")

(license MIT)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

(package
 (name inquire)
 (synopsis "An OCaml library to create beautiful interactive CLIs")
 (description "An OCaml library to create beautiful interactive CLIs")
 (depends
  (ocaml
   (>= 4.08.0))
  (dune
   (>= 2.0))
  lwt
  ; Vendored zed
  base-bytes
  uucd
  uutf
  uuseg
  react
  ; Vendored lambda-term
  lwt_log
  react
  lwt_react
  (mew_vi
   (and
    (>= 0.5.0)
    (< 0.6.0)))
  uucp
  uunf))
