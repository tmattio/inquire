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

class read_password ~term prompt =
  object (self)
    inherit [Zed_string.t] LTerm_read_line.engine () as super

    inherit [Zed_string.t] LTerm_read_line.term term

    method! stylise last =
      let text, pos = super#stylise last in
      for i = 0 to Array.length text - 1 do
        let _ch, style = text.(i) in
        text.(i) <- Zed_char.unsafe_of_char '*', style
      done;
      text, pos

    method eval = Zed_rope.to_string (Zed_edit.text self#edit)

    method! show_box = false

    method! send_action =
      function
      | Prev_search | Next_search -> () | action -> super#send_action action

    initializer self#set_prompt (S.const prompt)
  end

let rec loop ~term ~impl:(module I : Impl.M) message =
  let prompt = make_prompt message ~impl:(module I) in
  (new read_password prompt ~term)#run >>= fun password ->
  match Zed_string.to_utf8 password with
  | "" ->
    make_error "You need to enter a password" ~term ~impl:(module I)
    >>= fun () -> loop message ~term ~impl:(module I)
  | password ->
    Lwt.return password

let prompt ~impl:(module I : Impl.M) message =
  LTerm_inputrc.load () >>= fun () ->
  Lazy.force LTerm.stdout >>= fun term -> loop message ~term ~impl:(module I)
