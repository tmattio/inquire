open Alcotest
open Inquire

let test_apply_color c () =
  let generated = Style.Ascii.apply_color "test" ~color:c in
  check string "same string" "\027[31mtest\027[39m" generated

let test_apply_bold () =
  let generated = Style.Ascii.apply_bold "test" ~bold:true in
  check string "same string" "\027[1mtest\027[22m" generated

let test_compose () =
  let generated =
    Style.Ascii.apply "test" ~style:(Style.make [ Style.bold; Style.color Red ])
  in
  check string "same string" "\027[31m\027[1mtest\027[22m\027[39m" generated

let suite =
  [ "can apply color red", `Quick, test_apply_color Style.Red
  ; "can apply bold", `Quick, test_apply_bold
  ; "can compose", `Quick, test_compose
  ]
