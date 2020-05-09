open Lwt_react

let ( >>= ) = Lwt.( >>= )

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
  let prompt = I.make_prompt message in
  (new read_password prompt ~term)#run >>= fun password ->
  match Zed_string.to_utf8 password with
  | "" ->
    let error_str = I.make_error "You need to enter a password" in
    LTerm.fprintls term error_str >>= fun () ->
    loop message ~term ~impl:(module I)
  | password ->
    Lwt.return password

let prompt ~impl:(module I : Impl.M) message =
  Lazy.force LTerm.stdout >>= fun term -> loop message ~term ~impl:(module I)
