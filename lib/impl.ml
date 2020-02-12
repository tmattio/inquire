module type M = sig
  val prompt_prefix : string

  val prompt_style : Style.t

  val error_prefix : string

  val error_style : Style.t

  val selected_style : Style.t
end
