# Inquire

[![Actions Status](https://github.com/tmattio/inquire/workflows/CI/badge.svg)](https://github.com/tmattio/inquire/actions)

🎨 Create beautiful interactive command line interface in OCaml

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
Inquire.raw_select "What's your favorite movie?" ~options:[ "Choice 1" ; "Choice 2" ]
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

## Limitations

Inquire is dead simple. The prompt implementations are ~100 line of code each and manage the terminal control flow themselves. 
This simplicity comes at a price though:

- No support for UTF8. This would in principle be relatively easy to implement with a buffer that accumulates the input bytes until it matches an UTF8 value, up to a certain number of bytes. A PR for this would be more than welcome.

## Contributing

Take a look at our [Contributing Guide](CONTRIBUTING.md).
