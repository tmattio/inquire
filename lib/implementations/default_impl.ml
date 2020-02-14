module M = struct
  let prompt_prefix = "? "

  let prompt_prefix_style = Style.make [ Style.color Green ]

  let prompt_style = Style.make [ Style.bold; Style.color White ]

  let error_prefix = ">> "

  let error_prefix_style = Style.make [ Style.bold; Style.color Red ]

  let error_style = Style.make [ Style.bold; Style.color Red ]

  let selected_prefix = "> "

  let selected_prefix_style = Style.make [ Style.bold; Style.color Blue ]

  let selected_style = Style.make [ Style.bold; Style.color Blue ]
end

include Factory.Make (M)
