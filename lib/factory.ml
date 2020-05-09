module Make (M : Impl.M) = struct
  let confirm ?default message =
    Confirm.prompt message ?default ~impl:(module M)

  let password message = Password.prompt message ~impl:(module M)

  let input ?default message = Input.prompt message ?default ~impl:(module M)

  let raw_select ?default ~options message =
    Raw_select.prompt message ?default ~options ~impl:(module M)

  let select ?default ~options message =
    Select.prompt message ?default ~options ~impl:(module M)
end
