module type M = sig
  val prompt_prefix : string

  val prompt_prefix_style : Style.t

  val prompt_style : Style.t

  val error_prefix : string

  val error_prefix_style : Style.t

  val error_style : Style.t

  val selected_prefix : string

  val selected_prefix_style : Style.t

  val selected_style : Style.t
end
