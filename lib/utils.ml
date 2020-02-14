let make_prompt_markup ~impl:(module I : Impl.M) message =
  let prompt_str = message ^ " " in
  let prompt_prefix =
    Style.Text_markup.apply I.prompt_prefix ~style:I.prompt_prefix_style
  in
  let prompt = Style.Text_markup.apply prompt_str ~style:I.prompt_style in
  List.concat [ prompt_prefix; prompt ]

let make_error_markup ~impl:(module I : Impl.M) message =
  let error_prefix =
    Style.Text_markup.apply I.error_prefix ~style:I.error_prefix_style
  in
  let error = Style.Text_markup.apply message ~style:I.error_style in
  List.concat [ error_prefix; error ]

let make_prompt_str ~impl:(module I : Impl.M) message =
  let prompt_str = message ^ " " in
  let prompt_prefix =
    Style.Ascii.apply I.prompt_prefix ~style:I.prompt_prefix_style
  in
  let prompt = Style.Ascii.apply prompt_str ~style:I.prompt_style in
  prompt_prefix ^ prompt

let make_error_str ~impl:(module I : Impl.M) message =
  let error_prefix =
    Style.Ascii.apply I.error_prefix ~style:I.error_prefix_style
  in
  let error = Style.Ascii.apply message ~style:I.error_style in
  error_prefix ^ error
