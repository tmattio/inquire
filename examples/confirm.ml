let ( >>= ) = Lwt.( >>= )

let () =
  let result =
    Inquire.confirm "Are you sure?" ~default:true >>= fun choice ->
    if choice then Lwt_io.printl "Yes!" else Lwt_io.printl "No!"
  in
  Lwt_main.run result
