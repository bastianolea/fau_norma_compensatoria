library(shiny)
library(bslib)
library(htmltools)

source("funciones.R")


lista_tramos <- c("Mercado", "Tramo 3", "Tramo 2", "Tramo 1")

ui <- page_fluid(
  
  tags$style(
    HTML("h4 {margin-top: 28px;}
          h3 {margin-top: 18px;}")
  ),
  
  fluidRow(
    column(4,
           numericInput("sup_total_terreno",
                        label = "sup_total_terreno",
                        value = 7281),
           
           numericInput("faja_up_expropiacion",
                        label = "faja_up_expropiacion",
                        value = 1634),
           
           numericInput("faja_exterior_eje_ep",
                        label = "faja_exterior_eje_ep",
                        value = 565),
           
           numericInput("valor_suelo_uf",
                        label = "valor_suelo_uf",
                        value = 14.5),
           
           # PRECIOS MÁXIMOS INTEGRACIÓN	
           div_panel(
             h3("PRECIOS MÁXIMOS INTEGRACIÓN"),
             numericInput("precio_max_int_t1",
                          label = ".precio_max_int_t1",
                          value = 1400),
             numericInput("precio_max_int_t2",
                          label = ".precio_max_int_t2",
                          value = 1700),
             numericInput("precio_max_int_t3",
                          label = ".precio_max_int_t3",
                          value = 2250)
           ),
           
           
           sliderInput("calidad_ep",
                       "calidad_ep",
                       min = 1, max = 4, value = 3),
           
           # CASTIGO POR INTEGRACIÓN	
           div_panel(
             h3("CASTIGO POR INTEGRACIÓN"),
             numericInput("b_integracion",
                          "b_integracion",
                          0.00891),
             numericInput("b_descuento",
                          "b_descuento",
                          0.02094),
             numericInput("b_espaciopublico_integracion",
                          "b_espaciopublico_integracion",
                          -0.01580),
             numericInput("b_unidades_integracion",
                          "b_unidades_integracion",
                          -0.00005)
           )
           
    ),
    
    
    column(4,
           numericInput("normativa_densidad",
                        label = "normativa_densidad",
                        value = 1500),
           
           numericInput("normativa_construccion",
                        label = "normativa_construccion",
                        value = 3.2),
           
           numericInput("compensacion_densidad",
                        label = "compensacion_densidad",
                        value = 1),
           numericInput("compensacion_construccion",
                        label = "compensacion_construccion",
                        value = 1),
           
           selectInput("unidad_normativa",
                       "unidad_normativa", 
                       choices = c("hab/ha", "viv/ha")),
           
           numericInput("superficie_area_comun",
                        "superficie_area_comun",
                        0.15)
           
    ),
    
    column(4,
           h2("Resultados"),
           
           # norma aplicada
           h4("Norma aplicada"),
           cifra("normativa_densidad:", textOutput("normativa_densidad")),
           
           cifra("normativa_construccion:", textOutput("normativa_construccion")),
           
           ## cabida ----   
           
           h3("Cabida"),
           # neta
           cifra("superficie_neta:", textOutput("superficie_neta")),
           
           cifra("superficie_max_util_const:", textOutput("superficie_max_util_const")),
           cifra("area_comun_mt2:", textOutput("area_comun_mt2")),
           cifra("max_unidades_vendibles:", textOutput("max_unidades_vendibles")),
           cifra("max_superficie_vendible:", textOutput("max_superficie_vendible")),
           
           ## ingresos ----
           h3("Ingresos"),
           
           ### tamaños ----
           div_panel(
             fluidRow(
               column(4,
                      em("Tamaños"),
                      numericInput("tamaño_tipo_s1", label = NULL, value = 38, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s2", label = NULL, value = 45, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s3", label = NULL, value = 52, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s4", label = NULL, value = 55, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s5", label = NULL, value = 62, step = 1, width = "100%")
               ),
               column(4,
                      em("Tramos"),
                      selectInput("tramo_s1", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s2", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s3", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s4", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s5", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%")
               ),
               column(4,
                      em("Porcentaje"),
                      numericInput("porcentaje_s1", label = NULL, value = 0.15, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s2", label = NULL, value = 0.20, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s3", label = NULL, value = 0.25, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s4", label = NULL, value = 0.15, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s5", label = NULL, value = 0.25, min = 0, max = 1, width = "100%")
               )
               
             )
           ),
           
           cifra("cantidades_tipos", textOutput("cantidades_tipos")),
           cifra("total_cantidad_unidades", textOutput("total_cantidad_unidades")),
           cifra("superficies_tipos", textOutput("superficies_tipos")),
    )
  )
)


server <- function(input, output, session) {
  
  ## cabida ----
  # neta
  superficie_neta = reactive(input$sup_total_terreno - input$faja_up_expropiacion)
  
  normativa_densidad = reactive(input$normativa_densidad * input$compensacion_densidad)
  normativa_construccion = reactive(input$normativa_construccion * input$compensacion_construccion)
  
  output$superficie_neta <- renderText(superficie_neta())
  
  # norma aplicada
  output$normativa_densidad <- renderText(normativa_densidad())
  output$normativa_construccion <- renderText(normativa_construccion())
  
  # superficie neta p/desarrollo
  superficie_max_util_const = reactive(superficie_neta() * normativa_construccion())
  output$superficie_max_util_const <- renderText(superficie_max_util_const())
  
  area_comun_mt2 = reactive(superficie_max_util_const() * input$superficie_area_comun)
  output$area_comun_mt2 <- renderText(area_comun_mt2())
  
  # máximos vendibles
  max_unidades_vendibles = reactive(
    (input$sup_total_terreno + input$faja_exterior_eje_ep)/10000 * ifelse(input$unidad_normativa == "hab/ha", 
                                                                          (normativa_densidad()/4), normativa_densidad()))
  output$max_unidades_vendibles <- renderText(max_unidades_vendibles())
  
  max_superficie_vendible = reactive(
    superficie_max_util_const() * (100-(input$superficie_area_comun*100))/100) #mt2
  output$max_superficie_vendible <- renderText(max_superficie_vendible())
  
  
  ## ingresos ----
  
  ### tamaños ----
  tamaños_tipos <- reactive(
    c(input$tamaño_tipo_s1,
      input$tamaño_tipo_s2,
      input$tamaño_tipo_s3,
      input$tamaño_tipo_s4,
      input$tamaño_tipo_s5)
  )
  
  ### tipologías ----
  mercado_o_tramos <- reactive(
    c(input$tramo_s1,
      input$tramo_s2,
      input$tramo_s3,
      input$tramo_s4,
      input$tramo_s5)
  )
  
  ### cantidades ----
  porcentaje_tipos <- reactive(
    c(input$porcentaje_s1,
      input$porcentaje_s2,
      input$porcentaje_s3,
      input$porcentaje_s4,
      input$porcentaje_s5)
  )
  
  cantidades_tipos = reactive(max_unidades_vendibles() * porcentaje_tipos())
  output$cantidades_tipos <- renderText(cantidades_tipos())
  total_cantidad_unidades = reactive(sum(cantidades_tipos()))
  output$total_cantidad_unidades <- renderText(total_cantidad_unidades())
  
  # superficie por tipo (mt2)
  superficies_tipos = reactive(cantidades_tipos() * tamaños_tipos())
  output$superficies_tipos <- renderText(superficies_tipos())
}

shinyApp(ui, server)