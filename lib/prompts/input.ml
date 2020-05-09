open Lwt_react

let ( >>= ) = Lwt.( >>= )

class read_line ~term prompt =
  object (self)
    inherit [Zed_string.t] LTerm_read_line.engine () as super

    inherit [Zed_string.t] LTerm_read_line.term term

    method eval = Zed_rope.to_string (Zed_edit.text self#edit)

    method! show_box = false

    method! send_action =
      function
      | Prev_search | Next_search -> () | action -> super#send_action action

    initializer self#set_prompt (S.const prompt)
  end

let make_prompt ?default ~impl:(module I : Impl.M) message =
  let default_str =
    match default with None -> "" | Some v -> Printf.sprintf "[%s] " v
  in
  let prompt = I.make_prompt message in
  Array.concat [ prompt; LTerm_text.eval [ S default_str ] ]

let rec loop ?default ~term ~impl:(module I : Impl.M) message =
  let prompt = make_prompt message ?default ~impl:(module I) in
  let rl = new read_line prompt ~term in
  rl#run >>= fun line ->
  match Zed_string.to_utf8 line, default with
  | "", Some default ->
    Lwt.return default
  | "", None ->
    let error_str = I.make_error "You need to enter a value" in
    LTerm.fprintls term error_str >>= fun () ->
    loop message ~term ~impl:(module I)
  | line, _ ->
    Lwt.return line

let prompt ?default ~impl:(module I : Impl.M) message =
  Lazy.force LTerm.stdout >>= fun term ->
  loop message ?default ~term ~impl:(module I)
