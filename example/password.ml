let ( >>= ) = Lwt.( >>= )

let () =
  let result =
    Inquire.password "Enter your password:" >>= fun password ->
    Lwt_io.printlf "Your new password is: %S" password
  in
  Lwt_main.run result
