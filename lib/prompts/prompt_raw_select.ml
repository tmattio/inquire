let print_options options =
  List.iteri
    (fun i opt -> print_endline (Printf.sprintf "  %i) %s" (i + 1) opt))
    options

let print_prompt ?style ~options message =
  Utils.print_prompt ?style message;
  print_string "\n";
  print_options options;
  print_string "Answer: ";
  flush stdout

let prompt ?default ?style ~options message =
  print_prompt ?style ~options message;
  Ansi.save_cursor ();
  let input =
    match default with
    | Some v when v < List.length options ->
      ref (Some v)
    | _ ->
      ref None
  in
  let print_input () =
    match !input with
    | None ->
      ()
    | Some i ->
      print_int (i + 1);
      flush stdout
  in
  print_input ();
  let reset () =
    Ansi.restore_cursor ();
    Ansi.erase Ansi.Eol
  in
  let select i =
    input := Some i;
    reset ();
    print_input ()
  in
  let rec aux () =
    let ch = Char.code (input_char stdin) in
    match ch, !input with
    | 10, Some input ->
      (* Enter *)
      print_string "\n";
      flush stdout;
      List.nth options input
    | 10, None ->
      (* Enter, no input *)
      aux ()
    | 12, _ ->
      (* Handle ^L *)
      Ansi.erase Ansi.Screen;
      Ansi.set_cursor 1 1;
      print_prompt ?style ~options message;
      Ansi.save_cursor ();
      print_input ();
      aux ()
    | 3, _ | 4, _ ->
      (* Handle ^C and ^D *)
      print_endline "\n\nCancelled by user\n";
      (* Exit with an exception so we can catch it and revert the changes on
         stdin. *)
      raise Exn.Interrupted_by_user
    | 127, _ ->
      (* DEL *)
      aux ()
    | code, _ ->
      (match Char.chr code with
      | '1' when List.length options >= 1 ->
        select 0
      | '2' when List.length options >= 2 ->
        select 1
      | '3' when List.length options >= 3 ->
        select 2
      | '4' when List.length options >= 4 ->
        select 3
      | '5' when List.length options >= 5 ->
        select 4
      | '6' when List.length options >= 6 ->
        select 5
      | '7' when List.length options >= 7 ->
        select 6
      | '8' when List.length options >= 8 ->
        select 7
      | '9' when List.length options >= 9 ->
        select 8
      | _ ->
        ());
      aux ()
  in
  Utils.with_raw Unix.stdin aux
