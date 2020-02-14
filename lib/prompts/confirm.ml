open Lwt

let rec read_char term =
  let open CamomileLibraryDefault.Camomile in
  LTerm.read_event term >>= function
  | LTerm_event.Key
      { LTerm_key.code = LTerm_key.Char ch; LTerm_key.control = true; _ }
    when UChar.eq ch (UChar.of_char 'c') ->
    (* Exit on Ctrl+C *)
    Lwt.fail (Failure "interrupted")
  | LTerm_event.Key { LTerm_key.code; _ } ->
    Lwt.return code
  | _ ->
    read_char term

let make_choice_str_of_default default =
  match default with
  | Some true ->
    "(Y/n)"
  | Some false ->
    "(y/N)"
  | None ->
    "(y/n)"

let rec loop ~term ~impl:(module I : Impl.M) ?default message =
  let handle_error () =
    let error_str =
      Utils.make_error_str "Please enter 'y' or 'n'." ~impl:(module I)
    in
    LTerm.fprintl term error_str >>= fun () ->
    loop message ~term ~impl:(module I) ?default
  in
  let default_str = make_choice_str_of_default default in
  let prompt_str =
    Utils.make_prompt_str (message ^ " " ^ default_str) ~impl:(module I)
  in
  LTerm.fprint term prompt_str >>= fun () ->
  read_char term >>= fun code ->
  match code, default with
  | LTerm_key.Char code, _ ->
    let ch = Zed_utf8.singleton code in
    LTerm.fprintl term ch >>= fun () ->
    (match ch with
    | "y" | "Y" ->
      return true
    | "n" | "N" ->
      return false
    | _ ->
      handle_error ())
  | LTerm_key.Enter, None ->
    LTerm.fprintl term "" >>= fun () -> handle_error ()
  | LTerm_key.Enter, Some default ->
    LTerm.fprintl term (if default then "y" else "n") >>= fun () ->
    return default
  | _ ->
    handle_error ()

let prompt ~impl:(module I : Impl.M) ?default message =
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enter_raw_mode term >>= fun mode ->
  Lwt.finalize
    (fun () -> loop message ~term ?default ~impl:(module I))
    (fun () -> LTerm.leave_raw_mode term mode)
