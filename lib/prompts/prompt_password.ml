let read_password_unix () =
  let term_init = Unix.tcgetattr Unix.stdin in
  let term_no_echo = { term_init with Unix.c_echo = false } in
  Unix.tcsetattr Unix.stdin Unix.TCSANOW term_no_echo;
  try
    let password = read_line () in
    print_newline ();
    Unix.tcsetattr Unix.stdin Unix.TCSAFLUSH term_init;
    password
  with
  | e ->
    Unix.tcsetattr Unix.stdin Unix.TCSAFLUSH term_init;
    raise e

let read_password_windows () =
  print_string "\x1b[8m";
  let password = read_line () in
  print_string "\x1b[0m";
  print_newline ();
  password

let read_password () =
  match Sys.win32 with
  | true ->
    read_password_windows ()
  | false ->
    read_password_unix ()

let rec prompt_until_valid ~validate ~print_prompt ?style message =
  print_prompt ();
  let password = read_password () in
  match validate password with
  | Ok password ->
    password
  | Error err ->
    Utils.print_err ?style err;
    prompt_until_valid ~validate ~print_prompt ?style message

let prompt ?validate ?default ?style message =
  let default_str =
    match default with Some _ -> Some "*****" | None -> None
  in
  let print_prompt () =
    Utils.print_prompt ?default:default_str ?style message
  in
  match validate with
  | None ->
    print_prompt ();
    read_password ()
  | Some fn ->
    prompt_until_valid ~validate:fn ~print_prompt ?style message
