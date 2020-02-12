module Make (M : Impl.M) = struct
  let confirm ?default message =
    Confirm.prompt message ?default ~impl:(module M)

  let raw_list ?default ~options message =
    Raw_list.prompt message ?default ~options ~impl:(module M)

  let password message = Password.prompt message ~impl:(module M)

  let input message = Input.prompt message ~impl:(module M)
end
