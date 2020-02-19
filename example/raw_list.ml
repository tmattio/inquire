let ( >>= ) = Lwt.( >>= )

let movies =
  [ "Star Wars: The Rise of Skywalker"
  ; "Solo: A Star Wars Story"
  ; "Star Wars: The Last Jedi"
  ; "Rogue One: A Star Wars Story"
  ; "Star Wars: The Force Awakens"
  ]

let () =
  let result =
    Inquire.raw_list "What's your favorite movie?" ~options:movies
    >>= fun movie -> Lwt_io.printlf "Indeed, %S is a great movie!" movie
  in
  Lwt_main.run result
