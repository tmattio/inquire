open React
open Lwt
open LTerm_text

module Interpreter = struct
  let eval ~impl:(module I : Impl.M) ~options s =
    let index_opt =
      Caml.int_of_string_opt s
      |> Option.bind ~f:(fun c ->
             if c > 0 && c <= List.length options then Some (c + 1) else None)
    in
    Result.of_option
      index_opt
      ("Enter a number between 1 and " ^ Int.to_string (List.length options))
end

let make_prompt ~impl:(module I : Impl.M) ~options message =
  let prompt = Utils.make_prompt_markup message ~impl:(module I) in
  let options_string =
    List.mapi options ~f:(fun i opt ->
        "  " ^ Int.to_string (i + 1) ^ ") " ^ opt ^ "\n")
    |> String.concat
  in
  List.concat [ prompt; [ S "\n"; S options_string; S "  Answer: " ] ]

class read_line ~term prompt =
  object (self)
    inherit LTerm_read_line.read_line ()

    inherit [Zed_string.t] LTerm_read_line.term term

    method! show_box = false

    initializer self#set_prompt (S.const prompt)
  end

let rec loop ~term ~impl:(module I : Impl.M) ~options message =
  let prompt =
    make_prompt message ~options ~impl:(module I) |> LTerm_text.eval
  in
  let rl = new read_line prompt ~term in
  rl#run >>= fun command ->
  let command_utf8 = Zed_string.to_utf8 command in
  match Interpreter.eval command_utf8 ~options ~impl:(module I) with
  | Error e ->
    let error_str = Utils.make_error_str e ~impl:(module I) in
    LTerm.fprintl term error_str >>= fun () ->
    loop message ~options ~term ~impl:(module I)
  | Ok v ->
    Lwt.return (List.nth_exn options v)

let prompt ~impl:(module I : Impl.M) ?default ~options message =
  LTerm_inputrc.load () >>= fun () ->
  Lazy.force LTerm.stdout >>= fun term ->
  loop message ~options ~term ~impl:(module I)
