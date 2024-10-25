

div_panel <- function(...) {
  div(style = css(padding = "12px",
                border = "1px solid",
                margin = "4px",
                border_radius = "6px"),
      ...
  )
}


cifra <- function(titulo, output) {
  div(style = css(margin = "4px"),
    div(style = css(display = "inline-block",
                    font_weight = "bold"),
        titulo),
    div(style = css(display = "inline-block"),
        output)
  )
}