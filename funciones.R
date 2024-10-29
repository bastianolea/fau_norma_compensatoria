

div_panel <- function(...) {
  div(style = css(padding = "12px",
                border = paste("2px solid", color$detalle),
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

precio <- function(x) {
  scales::comma(x, prefix = "$", big.mark = ".", decimal.mark = ",")
}

uf <- function(x) {
  scales::comma(x, suffix = " UF", big.mark = ".", decimal.mark = ",")
}

mt2 <- function(x) {
  scales::comma(x, suffix = " mt²", big.mark = ".", decimal.mark = ",")
}

porcentaje <- function(x, decimales = 0.01) {
  scales::percent(x, decimales)
}