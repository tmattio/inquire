let ( >>= ) = Lwt.( >>= )

let () =
  let result =
    Inquire.input "Enter a value:" ~default:"default" >>= fun value ->
    Lwt_io.printlf "You entered: %S" value
  in
  Lwt_main.run result
