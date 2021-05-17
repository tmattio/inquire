exception Exit of int

let exit i = raise (Exit i)

let print_prompt ?default ?(style = Style.default) message =
  let () =
    match style.Style.qmark_icon, default with
    | "", Some default ->
      Printf.printf
        "%s [%s] "
        (Ansi.sprintf style.Style.message_format "%s" message)
        (Ansi.sprintf style.Style.default_format "%s" default)
    | qmark, Some default ->
      Printf.printf
        "%s %s [%s] "
        (Ansi.sprintf style.Style.qmark_format "%s" qmark)
        (Ansi.sprintf style.Style.message_format "%s" message)
        (Ansi.sprintf style.Style.default_format "%s" default)
    | "", None ->
      Printf.printf "%s " (Ansi.sprintf style.Style.message_format "%s" message)
    | qmark, None ->
      Printf.printf
        "%s %s "
        (Ansi.sprintf style.Style.qmark_format "%s" qmark)
        (Ansi.sprintf style.Style.message_format "%s" message)
  in
  flush stdout

let print_err ?(style = Style.default) err =
  let () =
    match style.Style.error_icon with
    | "" ->
      prerr_endline (Ansi.sprintf style.Style.error_format "%s" err)
    | _ ->
      prerr_endline
        (Ansi.sprintf
           style.Style.error_format
           "%s %s"
           style.Style.error_icon
           err)
  in
  flush stderr

let with_cbreak ?(when_ = Unix.TCSAFLUSH) fd f =
  if Unix.isatty fd then (
    let term_init = Unix.tcgetattr fd in
    Unix.tcsetattr
      fd
      when_
      { term_init with
        Unix.c_icanon = false
      ; Unix.c_echo = false
      ; Unix.c_vmin = 1
      ; Unix.c_vtime = 0
      };
    try
      let result = f () in
      Unix.tcsetattr fd Unix.TCSADRAIN term_init;
      result
    with
    | Exit i ->
      Unix.tcsetattr fd Unix.TCSADRAIN term_init;
      Stdlib.exit i
    | e ->
      Unix.tcsetattr fd Unix.TCSADRAIN term_init;
      raise e)
  else
    f ()

let with_raw ?(when_ = Unix.TCSAFLUSH) fd f =
  if Unix.isatty fd then (
    let term_init = Unix.tcgetattr fd in
    Unix.tcsetattr
      fd
      when_
      { term_init with
        (* Inspired from Python-3.0/Lib/tty.py: *)
        Unix.c_brkint = false
      ; Unix.c_inpck = false
      ; Unix.c_istrip = false
      ; Unix.c_ixon = false
      ; Unix.c_csize = 8
      ; Unix.c_parenb = false
      ; Unix.c_echo = false
      ; Unix.c_icanon = false
      ; Unix.c_vmin = 1
      ; Unix.c_vtime = 0
      ; Unix.c_isig = false
      };
    try
      let result = f () in
      Unix.tcsetattr fd Unix.TCSADRAIN term_init;
      result
    with
    | Exit i ->
      Unix.tcsetattr fd Unix.TCSADRAIN term_init;
      Stdlib.exit i
    | e ->
      Unix.tcsetattr fd Unix.TCSADRAIN term_init;
      raise e)
  else
    f ()

let erase_n_chars x =
  Ansi.move_cursor (-1 * x) 0;
  let rec aux acc i =
    if i = 0 then
      acc
    else
      aux (acc ^ " ") (i - 1)
  in
  print_string (aux "" x);
  Ansi.move_cursor (-1 * x) 0

let erase_default x = erase_n_chars (2 + String.length x)

let erase_default_opt = function None -> () | Some x -> erase_default x
