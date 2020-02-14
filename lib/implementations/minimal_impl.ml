module M = struct
  let prompt_prefix = ""

  let prompt_prefix_style = Style.default

  let prompt_style = Style.default

  let error_prefix = ""

  let error_prefix_style = Style.default

  let error_style = Style.default

  let selected_prefix = "> "

  let selected_prefix_style = Style.default

  let selected_style = Style.default
end

include Factory.Make (M)
