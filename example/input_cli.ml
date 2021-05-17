(* Implementation of the command, we just print the args. *)

let input default message =
  let value = Inquire.input ?default message in
  Printf.printf "You entered %S" value

(* Command line interface *)

open Cmdliner

let default = Arg.(value & opt (some string) None & info [ "default" ])

let message =
  Arg.(required & pos 0 (some string) None & info [] ~docv:"MESSAGE")

let cmd =
  ( Term.(const input $ default $ message)
  , Term.info "input" ~exits:Term.default_exits )

let () = Term.(exit @@ eval cmd)
