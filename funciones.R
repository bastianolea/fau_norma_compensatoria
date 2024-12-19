

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
  scales::comma(x, suffix = " m²", big.mark = ".", decimal.mark = ",")
}

porcentaje <- function(x, decimales = 0.01) {
  scales::percent(x, decimales)
}


explicacion <- function(texto, ...) {
  
  div(style = css(font_size = "80%", font_style = "italic", ...),
      p(texto)
  )
}

lista_tipos <- function(vector) {
  
  div(style = css(margin_top = "4px"),
      map(1:5, ~{
        cantidad <- vector[.x] |> mt2()
        
        div(style = css(font_size = "75%", margin_bottom = "0px"),
            p(paste0("Tipo ", .x, ":"), cantidad)
        )
      })
  )
}



calculo_mt2_tipo <- function(session = NULL, input = NULL, tipo = 1) {
  
  if (input[[paste0("tramo_s", tipo)]] != "Mercado") {
    # tipo = 1
    tramo_n <- case_match(input[[paste0("tramo_s", tipo)]],
                          "Tramo 3" ~ 3, 
                          "Tramo 2" ~ 2, 
                          "Tramo 1" ~ 1)
    
    tamaño_tipo <- input[[paste0("tamaño_tipo_s", tipo)]]
    precio_tramo <- input[[paste0("precio_max_int_t", tramo_n)]]
    
    precio_tramo_m2 <- precio_tramo/tamaño_tipo
    
    updateAutonumericInput(session,
                           paste0("precios_m2_tipos_s", tipo),
                           value = round(precio_tramo_m2, 0)
    )
  } 
}