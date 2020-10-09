module CustomInquire = Inquire.Make (struct
  open LTerm_style
  open LTerm_text

  let make_prompt message =
    eval
      [ B_fg green; S "? "; B_fg white; S (Printf.sprintf "%s" message); E_fg ]

  let make_error message =
    eval
      [ B_fg green; S "X "; B_fg white; S (Printf.sprintf "%s" message); E_fg ]

  let make_select ~current options =
    List.mapi options ~f:(fun index option ->
        if current = index then
          [ B_fg green
          ; S "> "
          ; B_fg white
          ; S (Printf.sprintf "%s\n" option)
          ; E_fg
          ]
        else
          [ S "  "; B_fg white; S (Printf.sprintf "%s\n" option); E_fg ])
    |> List.concat
    |> eval
end)

let _ =
  let result = CustomInquire.confirm "Are you sure?" ~default:true in
  Lwt_main.run result
