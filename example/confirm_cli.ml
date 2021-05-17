(* Implementation of the command, we just print the args. *)

let confirm default auto_enter message =
  let choice = Inquire.confirm ?default ?auto_enter message in
  if choice then print_endline "Yes!" else print_endline "No!"

(* Command line interface *)

open Cmdliner

let default = Arg.(value & opt (some bool) None & info [ "default" ])

let auto_enter = Arg.(value & opt (some bool) None & info [ "auto-enter" ])

let message =
  Arg.(required & pos 0 (some string) None & info [] ~docv:"MESSAGE")

let cmd =
  ( Term.(const confirm $ default $ auto_enter $ message)
  , Term.info "confirm" ~exits:Term.default_exits )

let () = Term.(exit @@ eval cmd)
