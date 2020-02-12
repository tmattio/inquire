module M = struct
  let prompt_prefix = ""

  let prompt_style = Style.default

  let error_prefix = ""

  let error_style = Style.default

  let selected_style = Style.default
end

include Factory.Make (M)
