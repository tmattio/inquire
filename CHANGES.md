# 0.3.0 - 2021-05-17

## Added

- Improved `confirm` prompt to handle escape sequences
- Improved `confirm` prompt to display selected answer

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
