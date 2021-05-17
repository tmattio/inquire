let validate_password v =
  if String.length v >= 6 then
    Ok v
  else
    Error "The password must be 6 characters or more."

let () =
  let password =
    Inquire.password "Enter your password:" ~validate:validate_password
  in
  Printf.printf "Your new password is: %S" password
