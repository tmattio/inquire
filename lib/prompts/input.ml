open Lwt_react

let ( >>= ) = Lwt.( >>= )

let make_prompt ~impl:(module I : Impl.M) message =
  let prompt_str = I.prompt_prefix ^ message ^ " " in
  let styled_str = Style.Text_markup.apply prompt_str ~style:I.prompt_style in
  LTerm_text.eval styled_str

let make_error ~term ~impl:(module I : Impl.M) message =
  let prompt_str = I.error_prefix ^ message in
  let styled_str = Style.Ascii.apply prompt_str ~style:I.error_style in
  LTerm.fprintl term styled_str

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
  let prompt = make_prompt message ~impl:(module I) in
  let rl = new read_line prompt ~term in
  rl#run >>= fun line ->
  match Zed_string.to_utf8 line with
  | "" ->
    make_error "You need to enter a value" ~term ~impl:(module I) >>= fun () ->
    loop message ~term ~impl:(module I)
  | line ->
    Lwt.return line

let prompt ~impl:(module I : Impl.M) message =
  LTerm_inputrc.load () >>= fun () ->
  Lazy.force LTerm.stdout >>= fun term -> loop message ~term ~impl:(module I)
