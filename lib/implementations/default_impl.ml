module M = struct
  let prompt_prefix = "[?] "

  let prompt_style = Style.make [ Style.bold; Style.color White ]

  let error_prefix = ">> "

  let error_style = Style.make [ Style.bold; Style.color Red ]

  let selected_style = Style.make [ Style.color Blue ]
end

include Factory.Make (M)
