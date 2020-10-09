let _ =
  let result = Inquire.Minimal.confirm "Are you sure?" in
  Lwt_main.run result
