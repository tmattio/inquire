open Alcotest
open Inquire

(** Test suite for the Utils module. *)

let test_apply_color c () =
  (check string)
    "same string"
    "\027[31mtest\027[39m"
    (Style.Ascii.apply_color "test" ~color:c)

let test_apply_bold () =
  (check string)
    "same string"
    "\027[1mtest\027[22m"
    (Style.Ascii.apply_bold "test" ~bold:true)

let test_compose () =
  (check string)
    "same string"
    "\027[31m\027[1mtest\027[22m\027[39m"
    (Style.Ascii.apply "test" ~style:(Style.make [ Style.bold; Style.color Red ]))

let () =
  run
    "test-alcotest"
    [ ( "Style"
      , [ test_case "can apply color red" `Quick (test_apply_color Style.Red)
        ; test_case "can apply bold" `Quick test_apply_bold
        ; test_case "can compose" `Quick test_compose
        ] )
    ]
