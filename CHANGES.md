# 0.3.0 - 2021-05-17

## Added

- Improved all prompts prompt to handle escape sequences (e.g. "Ctrl-L" will clear the screen while reading from answer).
- Improved `select` to allow selection using indexes.
- Improved prompts to clear defaults and other tooltip on a valid answer and print the answer after the prompt.

## Changed

- Stripped out `lambda-term` dependency
- Removed `lwt` integration

# 0.2.1 - 2020-10-04

## Changed 

- Vendored lambda-term to fix dependency on Camomile assets

# 0.2.0 - 2020-05-08

## Changed 

- Changed the Make functor to take a module with functions `make_prompt`, `make_error` and `make_select`.
- Changed `raw_list` to `raw_select`.

## Added

- Add `select` prompt.
- Support default values for all prompts.
- Support validate functions for `password` and `input` prompts.

# 0.1.0 - 2020-02-12

## Added

- Add `confirm` prompt.
- Add `input` prompt.
- Add `password` prompt.
- Add `raw_list` prompt.
