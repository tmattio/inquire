let () =
  let choice = Inquire.confirm "Are you sure?" in
  if choice then print_endline "Yes!" else print_endline "No!"
