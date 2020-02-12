(** Module to style a string in the terminal.

    Ultimately, this could use Pastel
    (https://github.com/facebookexperimental/reason-native/blob/master/src/pastel/)
    but unfortunately reason-native packages are not released on Opam yet. *)

type color =
  | Default
  | Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White
  | BrightBlack
  | BrightRed
  | BrightGreen
  | BrightYellow
  | BrightBlue
  | BrightMagenta
  | BrightCyan
  | BrightWhite

type t =
  { bold : bool
  ; dim : bool
  ; italic : bool
  ; underline : bool
  ; inverse : bool
  ; hidden : bool
  ; strikethrough : bool
  ; color : color
  ; background : color
  }

let default =
  { bold = false
  ; dim = false
  ; italic = false
  ; underline = false
  ; inverse = false
  ; hidden = false
  ; strikethrough = false
  ; color = Default
  ; background = Default
  }

module Ascii = struct
  let apply_code ~start ~stop s =
    "\027[" ^ Int.to_string start ^ "m" ^ s ^ "\027[" ^ Int.to_string stop ^ "m"

  let apply_color ~color s =
    match color with
    | Default ->
      s
    | Black ->
      apply_code s ~start:30 ~stop:39
    | Red ->
      apply_code s ~start:31 ~stop:39
    | Green ->
      apply_code s ~start:32 ~stop:39
    | Yellow ->
      apply_code s ~start:33 ~stop:39
    | Blue ->
      apply_code s ~start:34 ~stop:39
    | Magenta ->
      apply_code s ~start:35 ~stop:39
    | Cyan ->
      apply_code s ~start:36 ~stop:39
    | White ->
      apply_code s ~start:37 ~stop:39
    | BrightBlack ->
      apply_code s ~start:90 ~stop:39
    | BrightRed ->
      apply_code s ~start:91 ~stop:39
    | BrightGreen ->
      apply_code s ~start:92 ~stop:39
    | BrightYellow ->
      apply_code s ~start:93 ~stop:39
    | BrightBlue ->
      apply_code s ~start:94 ~stop:39
    | BrightMagenta ->
      apply_code s ~start:95 ~stop:39
    | BrightCyan ->
      apply_code s ~start:96 ~stop:39
    | BrightWhite ->
      apply_code s ~start:97 ~stop:39

  let apply_background ~background s =
    match background with
    | Default ->
      s
    | Black ->
      apply_code s ~start:40 ~stop:49
    | Red ->
      apply_code s ~start:41 ~stop:49
    | Green ->
      apply_code s ~start:42 ~stop:49
    | Yellow ->
      apply_code s ~start:43 ~stop:49
    | Blue ->
      apply_code s ~start:44 ~stop:49
    | Magenta ->
      apply_code s ~start:45 ~stop:49
    | Cyan ->
      apply_code s ~start:46 ~stop:49
    | White ->
      apply_code s ~start:47 ~stop:49
    | BrightBlack ->
      apply_code s ~start:100 ~stop:49
    | BrightRed ->
      apply_code s ~start:101 ~stop:49
    | BrightGreen ->
      apply_code s ~start:102 ~stop:49
    | BrightYellow ->
      apply_code s ~start:103 ~stop:49
    | BrightBlue ->
      apply_code s ~start:104 ~stop:49
    | BrightMagenta ->
      apply_code s ~start:105 ~stop:49
    | BrightCyan ->
      apply_code s ~start:106 ~stop:49
    | BrightWhite ->
      apply_code s ~start:107 ~stop:49

  let apply_bold ~bold s =
    if bold then
      apply_code s ~start:1 ~stop:22
    else
      s

  let apply_dim ~dim s =
    if dim then
      apply_code s ~start:2 ~stop:22
    else
      s

  let apply_italic ~italic s =
    if italic then
      apply_code s ~start:3 ~stop:23
    else
      s

  let apply_underline ~underline s =
    if underline then
      apply_code s ~start:4 ~stop:24
    else
      s

  let apply_inverse ~inverse s =
    if inverse then
      apply_code s ~start:7 ~stop:27
    else
      s

  let apply_hidden ~hidden s =
    if hidden then
      apply_code s ~start:8 ~stop:28
    else
      s

  let apply_strikethrough ~strikethrough s =
    if strikethrough then
      apply_code s ~start:9 ~stop:29
    else
      s

  let apply ~style s =
    let s = apply_bold s ~bold:style.bold in
    let s = apply_dim s ~dim:style.dim in
    let s = apply_italic s ~italic:style.italic in
    let s = apply_underline s ~underline:style.underline in
    let s = apply_inverse s ~inverse:style.inverse in
    let s = apply_hidden s ~hidden:style.hidden in
    let s = apply_strikethrough s ~strikethrough:style.strikethrough in
    let s = apply_color s ~color:style.color in
    let s = apply_background s ~background:style.background in
    s
end

module Text_markup = struct
  open LTerm_text

  let apply_code ~b ~e m = List.concat [ [ b ]; m; [ e ] ]

  let apply_color ~color m =
    match color with
    | Default ->
      m
    | Black ->
      apply_code m ~b:(B_fg LTerm_style.black) ~e:E_fg
    | Red ->
      apply_code m ~b:(B_fg LTerm_style.red) ~e:E_fg
    | Green ->
      apply_code m ~b:(B_fg LTerm_style.green) ~e:E_fg
    | Yellow ->
      apply_code m ~b:(B_fg LTerm_style.yellow) ~e:E_fg
    | Blue ->
      apply_code m ~b:(B_fg LTerm_style.blue) ~e:E_fg
    | Magenta ->
      apply_code m ~b:(B_fg LTerm_style.magenta) ~e:E_fg
    | Cyan ->
      apply_code m ~b:(B_fg LTerm_style.cyan) ~e:E_fg
    | White ->
      apply_code m ~b:(B_fg LTerm_style.white) ~e:E_fg
    | BrightBlack ->
      apply_code m ~b:(B_fg LTerm_style.lblack) ~e:E_fg
    | BrightRed ->
      apply_code m ~b:(B_fg LTerm_style.lred) ~e:E_fg
    | BrightGreen ->
      apply_code m ~b:(B_fg LTerm_style.lgreen) ~e:E_fg
    | BrightYellow ->
      apply_code m ~b:(B_fg LTerm_style.lyellow) ~e:E_fg
    | BrightBlue ->
      apply_code m ~b:(B_fg LTerm_style.lblue) ~e:E_fg
    | BrightMagenta ->
      apply_code m ~b:(B_fg LTerm_style.lmagenta) ~e:E_fg
    | BrightCyan ->
      apply_code m ~b:(B_fg LTerm_style.lcyan) ~e:E_fg
    | BrightWhite ->
      apply_code m ~b:(B_fg LTerm_style.lwhite) ~e:E_fg

  let apply_background ~background m =
    match background with
    | Default ->
      m
    | Black ->
      apply_code m ~b:(B_bg LTerm_style.black) ~e:E_bg
    | Red ->
      apply_code m ~b:(B_bg LTerm_style.red) ~e:E_bg
    | Green ->
      apply_code m ~b:(B_bg LTerm_style.green) ~e:E_bg
    | Yellow ->
      apply_code m ~b:(B_bg LTerm_style.yellow) ~e:E_bg
    | Blue ->
      apply_code m ~b:(B_bg LTerm_style.blue) ~e:E_bg
    | Magenta ->
      apply_code m ~b:(B_bg LTerm_style.magenta) ~e:E_bg
    | Cyan ->
      apply_code m ~b:(B_bg LTerm_style.cyan) ~e:E_bg
    | White ->
      apply_code m ~b:(B_bg LTerm_style.white) ~e:E_bg
    | BrightBlack ->
      apply_code m ~b:(B_bg LTerm_style.lblack) ~e:E_bg
    | BrightRed ->
      apply_code m ~b:(B_bg LTerm_style.lred) ~e:E_bg
    | BrightGreen ->
      apply_code m ~b:(B_bg LTerm_style.lgreen) ~e:E_bg
    | BrightYellow ->
      apply_code m ~b:(B_bg LTerm_style.lyellow) ~e:E_bg
    | BrightBlue ->
      apply_code m ~b:(B_bg LTerm_style.lblue) ~e:E_bg
    | BrightMagenta ->
      apply_code m ~b:(B_bg LTerm_style.lmagenta) ~e:E_bg
    | BrightCyan ->
      apply_code m ~b:(B_bg LTerm_style.lcyan) ~e:E_bg
    | BrightWhite ->
      apply_code m ~b:(B_bg LTerm_style.lwhite) ~e:E_bg

  let apply_bold ~bold m =
    if bold then
      apply_code m ~b:(B_bold true) ~e:E_bold
    else
      m

  let apply_dim ~dim m = m

  let apply_italic ~italic m = m

  let apply_underline ~underline m =
    if underline then
      apply_code m ~b:(B_underline true) ~e:E_underline
    else
      m

  let apply_inverse ~inverse m = m

  let apply_hidden ~hidden m = m

  let apply_strikethrough ~strikethrough m = m

  let apply ~style s =
    let m = [ S s ] in
    let m = apply_bold m ~bold:style.bold in
    let m = apply_dim m ~dim:style.dim in
    let m = apply_italic m ~italic:style.italic in
    let m = apply_underline m ~underline:style.underline in
    let m = apply_inverse m ~inverse:style.inverse in
    let m = apply_hidden m ~hidden:style.hidden in
    let m = apply_strikethrough m ~strikethrough:style.strikethrough in
    let m = apply_color m ~color:style.color in
    let m = apply_background m ~background:style.background in
    m
end

let bold ~style = { style with bold = true }

let dim ~style = { style with dim = true }

let italic ~style = { style with italic = true }

let underline ~style = { style with underline = true }

let inverse ~style = { style with inverse = true }

let hidden ~style = { style with hidden = true }

let strikethrough ~style = { style with strikethrough = true }

let color color ~style = { style with color }

let background color ~style = { style with background = color }

let make l = Base.List.fold l ~init:default ~f:(fun acc el -> el ~style:acc)
