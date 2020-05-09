let ( >>= ) = Lwt.( >>= )

let validate_password v =
  if String.length v >= 6 then
    Ok v
  else
    Error "The password must be 6 characters or more."

let () =
  let result =
    Inquire.password "Enter your password:" ~validate:validate_password
    >>= fun password -> Lwt_io.printlf "Your new password is: %S" password
  in
  Lwt_main.run result
