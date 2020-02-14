# Inquire

[![Actions Status](https://github.com/tmattio/inquire/workflows/CI/badge.svg)](https://github.com/tmattio/inquire/actions)

An OCaml library to create beautiful interactive CLIs.

## Installation

### Using Opam

```bash
opam install inquire
```

### Using Esy

```bash
esy add @opam/inquire
```

## Usage

### Confirm

Prompt the user to answer the given message with "y" or "n".

```ocaml
Inquire.confirm "Are you sure?"
```

### Raw List

Prompt the user to chose a value from the given options.

```ocaml
Inquire.raw_list "What's your favorite movie?" ~options:[ "Choice 1" ; "Choice 2" ]
```

### Password

Prompt the user to enter a password that will be hidden with stars (`*`).

```ocaml
Inquire.password "Enter your password:"
```

### Input

Prompt the user to input a string.

```ocaml
Inquire.input "Enter a value:"
```

### Custom Implementation

Create a custom implementation to style Inquire's prompts.

```ocaml
module CustomInquire = Inquire.Make (struct
  open Inquire

  let prompt_prefix = "❓  "

  let prompt_style = Style.make [ Style.bold; Style.color White ]

  let error_prefix = "❌  "

  let error_style = Style.make [ Style.bold; Style.color Red ]

  let selected_style = Style.make [ Style.bold; Style.color Blue ]
end)

let _ =
  let result = CustomInquire.confirm "Are you sure?" ~default:true in
  Lwt_main.run result
```

## Contributing

### Developing

You need Opam, you can install it by following [Opam's documentation](https://opam.ocaml.org/doc/Install.html).

With Opam installed, you can build the project with:

```bash
make
```

### Running Examples

After building the project, you can run the example binaries with:

```bash
dune exec examples/<example>.exe
```

For instance, to run the `confirm.ml` example, you can type:

```bash
dune exec examples/confirm.exe
```

### Running Tests

You can test compiled executable with:

```bash
make test
```

### Building documentation

Documentation for the libraries in the project can be generated with:

```bash
make doc
open-cli $(make doc-path)
```

This assumes you have a command like [open-cli](https://github.com/sindresorhus/open-cli) installed on your system.

> NOTE: On macOS, you can use the system command `open`, for instance `open $(make doc-path)`

### Create new releases

To create a release and publish it on Opam, you can run the script `scripts/release.sh`. It will create a tag with the version found in `inquire.opam`, and push it on your repository.

From there, the CI/CD will take care of publishing your documentation, create a github release, and open a PR with your version on `opam-repository`.

### Repository Structure

The following snippet describes Inquire's repository structure.

```text
.
├── examples/
|   Source for inquire's examples. This links to the library defined in `lib/`.
│
├── lib/
|   Source for Inquire's library. Contains Inquire's core functionnalities.
│
├── test/
|   Unit tests and integration tests for Inquire.
│
├── dune-project
|   Dune file used to mark the root of the project and define project-wide parameters.
|   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
│
├── LICENSE
│
├── README.md
│
└── inquire.opam
    Opam package definition.
    To know more about creating and publishing opam packages, see https://opam.ocaml.org/doc/Packaging.html.
```
