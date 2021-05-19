let () =
  let validate = function
    | "test" ->
      Error "Not \"test\", enter something else."
    | x ->
      Ok x
  in
  let value =
    Inquire.input "Enter a value, not test:" ~validate ~default:"default"
  in
  Printf.printf "You entered: %S\n" value
