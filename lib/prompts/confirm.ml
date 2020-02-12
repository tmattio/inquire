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

let build_prompt_str ~impl:(module I : Impl.M) ?default message =
  let default_str =
    match default with
    | Some true ->
      "(Y/n)"
    | Some false ->
      "(y/N)"
    | None ->
      "(y/n)"
  in
  let prompt_str = I.prompt_prefix ^ message ^ " " ^ default_str ^ " " in
  Style.Ascii.apply prompt_str ~style:I.prompt_style

let build_error_str ~impl:(module I : Impl.M) =
  let prompt_str = I.error_prefix ^ "Please enter 'y' or 'n'." in
  Style.Ascii.apply prompt_str ~style:I.error_style

let rec read_yes_no ~term ~impl:(module I : Impl.M) ?default message =
  let handle_error () =
    let error_str = build_error_str ~impl:(module I) in
    LTerm.fprintl term error_str >>= fun () ->
    read_yes_no message ~term ~impl:(module I) ?default
  in
  let prompt_str = build_prompt_str message ?default ~impl:(module I) in
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
    (fun () -> read_yes_no message ~term ?default ~impl:(module I))
    (fun () -> LTerm.leave_raw_mode term mode)
