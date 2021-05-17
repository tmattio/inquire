let read_line_with_default ?default () =
  match read_line (), default with "", Some x -> x | x, _ -> x

let rec prompt_until_valid ?default ?style ~validate message =
  Utils.print_prompt ?default ?style message;
  match validate (read_line_with_default ?default ()) with
  | Ok input ->
    input
  | Error err ->
    Utils.print_err ?style err;
    prompt_until_valid ?default ~validate message

let prompt ?validate ?default ?style message =
  match validate with
  | None ->
    Utils.print_prompt ?default ?style message;
    read_line_with_default ?default ()
  | Some fn ->
    prompt_until_valid ?default ?style ~validate:fn message
