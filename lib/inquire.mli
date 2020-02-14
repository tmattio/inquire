(** Inquire is a high-level library to create interactive command line
    interfaces. *)

module Style = Style
(** Modude to create styled string in the terminal. *)

module Make = Factory.Make
(** Create a new implementation of Inquire to customize the prompts. *)

module Minimal = Minimal_impl
(** Minimal implementation of Inquire with no color and no prompt prefixes. *)

module Default = Default_impl
(** Default implementation of Inquire with hopefully nice colors and prefixes. *)

val confirm : ?default:bool -> String.t -> bool Lwt.t
(** Prompt the user to answer the given message with "y" or "n".

    {4 Examples}

    {[
      let result =
        Inquire.confirm "Are you sure?" ~default:true >>= fun choice ->
        if choice then Lwt_io.printl "Yes!" else Lwt_io.printl "No!"
      in
      Lwt_main.run result
    ]} *)

val raw_list
  :  ?default:bool
  -> options:string list
  -> String.t
  -> String.t Lwt.t
(** Prompt the user to chose a value from the given options.

    The options will be listed with an index prefixed and the users will have to
    enter the index of their choice.

    {4 Examples}

    {[
      let movies =
        [ "Star Wars: The Rise of Skywalker"
        ; "Solo: A Star Wars Story"
        ; "Star Wars: The Last Jedi"
        ; "Rogue One: A Star Wars Story"
        ; "Star Wars: The Force Awakens"
        ]
      in
      let result =
        Inquire.raw_list "What's your favorite movie?" ~options:movies
        >>= fun movie -> Lwt_io.printlf "Indeed, %S is a great movie!" movie
      in
      Lwt_main.run result
    ]} *)

val password : String.t -> String.t Lwt.t
(** Prompt the user to enter a password that will be hidden with stars ('*').

    The password can take any value, except the empty string.

    {4 Examples}

    {[
      let result =
        Inquire.password "Enter your password:" >>= fun password ->
        Lwt_io.printlf "Your new password is: %S" password
      in
      Lwt_main.run result
    ]} *)

val input : String.t -> String.t Lwt.t
(** Prompt the user to input a string.

    The string can take any value, except the empty string.

    {4 Examples}

    {[
      let result =
        Inquire.input "Enter a value:" >>= fun value ->
        Lwt_io.printlf "You entered: %S" value
      in
      Lwt_main.run result
    ]} *)
