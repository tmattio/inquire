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

let rec loop ~term ~impl:(module I : Impl.M) message =
  let prompt =
    Utils.make_prompt_markup message ~impl:(module I) |> LTerm_text.eval
  in
  let rl = new read_line prompt ~term in
  rl#run >>= fun line ->
  match Zed_string.to_utf8 line with
  | "" ->
    let error_str =
      Utils.make_error_str "You need to enter a value" ~impl:(module I)
    in
    LTerm.fprintl term error_str >>= fun () ->
    loop message ~term ~impl:(module I)
  | line ->
    Lwt.return line

let prompt ~impl:(module I : Impl.M) message =
  LTerm_inputrc.load () >>= fun () ->
  Lazy.force LTerm.stdout >>= fun term -> loop message ~term ~impl:(module I)
