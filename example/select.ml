let movies =
  [ "Star Wars: The Rise of Skywalker"
  ; "Solo: A Star Wars Story"
  ; "Star Wars: The Last Jedi"
  ; "Rogue One: A Star Wars Story"
  ; "Star Wars: The Force Awakens"
  ]

let () =
  let movie =
    Inquire.select "What's your favorite movie?" ~options:movies ~default:2
  in
  Printf.printf "Indeed, %S is a great movie!" movie
