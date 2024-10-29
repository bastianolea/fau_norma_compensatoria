library(shiny)
library(bslib)
library(htmltools)
library(shinyWidgets)
library(glue)
library(thematic)

library(reactlog)
reactlog::reactlog_enable()


thematic_shiny(font = "auto")

lista_tramos <- c("Mercado", "Tramo 3", "Tramo 2", "Tramo 1")

color <- list("fondo" = "#F3F4F8",
              "texto" = "#404040",
              "detalle" = "#C9C9C9",
              "primario" = "#0779CD")

source("funciones.R", local = TRUE)


ui <- page_fluid(
  theme = bs_theme(
    bg = color$fondo, fg = color$texto, primary = color$primario,
    # bslib also makes it easy to import CSS fonts
    base_font = bslib::font_google("Roboto Condensed")
  ),
  
  tags$style(
    HTML("h4 {margin-top: 6px;}
          h3 {margin-top: 6px;}")
  ),
  
  fluidRow(
    column(12,
           h1("Título")
    ),
    
    column(12,
           div(style = css(max_width = "500px"),
               radioGroupButtons(
                 inputId = "escenario",
                 individual = T,
                 label = "Escenarios de evaluación", 
                 choices = c("EV-MERC", "EV-INT1", "EV-INT2"), 
                 width = "100%"
               )
           ) |> tooltip("Cambiar escenario para establecer inputs predefinidos")
    ),
    column(12,
           checkboxInput(
             inputId = "castigo",
             label = "Aplicar castigo", 
             value = FALSE
           ),
           cifra("p_integracion:", textOutput("p_integracion")),
           cifra("p_castigo:", textOutput("p_castigo"))
    )
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
                        value = 14.5)
    ),
    
    column(4,
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
                       min = 1, max = 4, value = 3,
                       width = "100%")
    ),
    column(4,
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
           
    )
  ),
  
  hr(),
  
  fluidRow(
    
    column(6,
           h3("Cabida"),
           fluidRow(
             column(6,
                    numericInput("normativa_densidad",
                                 label = "normativa_densidad",
                                 value = 1500),
                    
                    numericInput("normativa_construccion",
                                 label = "normativa_construccion",
                                 value = 3.2)
             ),
             column(6,
                    numericInput("compensacion_densidad",
                                 label = "compensacion_densidad (%)",
                                 value = 1),
                    numericInput("compensacion_construccion",
                                 label = "compensacion_construccion (%)",
                                 value = 1)
             )
           ),
           
           selectInput("unidad_normativa",
                       "unidad_normativa", 
                       choices = c("hab/ha", "viv/ha")),
           
           numericInput("superficie_area_comun",
                        "superficie_area_comun",
                        0.15)
           
    ),
    column(6,
           
           ## cabida ----   
           h3("Cabida"),
           
           cifra("sup_total_terreno:", textOutput("sup_total_terreno")),
           # neta
           cifra("superficie_neta:", textOutput("superficie_neta")),
           
           cifra("superficie_max_util_const:", textOutput("superficie_max_util_const")),
           cifra("area_comun_mt2:", textOutput("area_comun_mt2")),
           cifra("max_unidades_vendibles:", textOutput("max_unidades_vendibles")),
           cifra("max_superficie_vendible:", textOutput("max_superficie_vendible")),
           
           hr(),
           # norma aplicada
           h3("Norma aplicada"),
           cifra("normativa_densidad:", textOutput("normativa_densidad")),
           
           cifra("normativa_construccion:", textOutput("normativa_construccion")),
           
    )
  ),
  
  hr(),
  
  ## ingresos ----
  fluidRow(
    column(6,
           h3("Ingresos"),
           
           ### tamaños ----
           div_panel(
             fluidRow(
               column(3,
                      em("Tamaños"),
                      numericInput("tamaño_tipo_s1", label = NULL, value = 38, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s2", label = NULL, value = 45, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s3", label = NULL, value = 52, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s4", label = NULL, value = 55, step = 1, width = "100%"),
                      numericInput("tamaño_tipo_s5", label = NULL, value = 62, step = 1, width = "100%")
               ),
               column(3,
                      em("Tramos"),
                      selectInput("tramo_s1", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s2", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s3", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s4", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                      selectInput("tramo_s5", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%")
               ),
               column(3,
                      em("Porcentaje"),
                      numericInput("porcentaje_s1", label = NULL, value = 0.15, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s2", label = NULL, value = 0.20, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s3", label = NULL, value = 0.25, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s4", label = NULL, value = 0.15, min = 0, max = 1, width = "100%"),
                      numericInput("porcentaje_s5", label = NULL, value = 0.25, min = 0, max = 1, width = "100%")
               ),
               column(3,
                      em("Precio"),
                      numericInput("precios_m2_tipos_s1", label = NULL, value = 50, min = 0, width = "100%"),
                      numericInput("precios_m2_tipos_s2", label = NULL, value = 50, min = 0, width = "100%"),
                      numericInput("precios_m2_tipos_s3", label = NULL, value = 50, min = 0, width = "100%"),
                      numericInput("precios_m2_tipos_s4", label = NULL, value = 50, min = 0, width = "100%"),
                      numericInput("precios_m2_tipos_s5", label = NULL, value = 50, min = 0, width = "100%"),
               )
             )
           )
    ),
    column(6,
           
           cifra("cantidades_tipos", textOutput("cantidades_tipos")),
           cifra("total_cantidad_unidades", textOutput("total_cantidad_unidades")),
           cifra("superficies_tipos", textOutput("superficies_tipos")),
           cifra("precios_tipos", textOutput("precios_tipos")),
           cifra("ingreso_deptos", textOutput("ingreso_deptos"))
    )
  ),
  
  hr(),
  
  ### estacionamientos ----
  fluidRow(
    column(12,
           h3("Estacionamientos")
    ),
    column(6, 
           numericInput("dotacion_est_viv_menor_50m2",
                        "dotacion_est_viv_menor_50m2",
                        0.33),
           numericInput("dotacion_est_viv_sobre_50m2_menor_100m2",
                        "dotacion_est_viv_sobre_50m2_menor_100m2",
                        0.5),
           numericInput("dotacion_est_rebaja",
                        "dotacion_est_rebaja",
                        0),
           numericInput("dotacion_est_viv_social",
                        "dotacion_est_viv_social",
                        0),
           
           # total estacionamientos
           numericInput("estacionamiento_subterraneo",
                        "estacionamiento_subterraneo",
                        0.50),
           numericInput("estacionamiento_exterior",
                        "estacionamiento_exterior",
                        0.50),
           numericInput("estacionamiento_visita",
                        "estacionamiento_visita",
                        0.15)
    ),
    column(6,
           cifra("total_estac_viv_menor_50m2", textOutput("total_estac_viv_menor_50m2")),
           cifra("total_estac_viv_sobre_50m2_menor_100m2", textOutput("total_estac_viv_sobre_50m2_menor_100m2")),
           cifra("total_estac_viv_social", textOutput("total_estac_viv_social")),
           cifra("total_estacionamientos", textOutput("total_estacionamientos")),
           cifra("total_estacionamientos_vendibles", textOutput("total_estacionamientos_vendibles")),
    )
  ),
  
  hr(),
  
  ### bodegas ----
  fluidRow(
    column(12,
           h3("Bodegas")
    ),
    column(6,
           numericInput("bodega_dotacion", 
                        "bodega_dotacion", 
                        1),
           numericInput("precio_estacionamiento_subterraneo", 
                        "precio_estacionamiento_subterraneo", 
                        250),
           numericInput("precio_estacionamiento_exterior", 
                        "precio_estacionamiento_exterior", 
                        150),
           numericInput("precio_bodega", 
                        "precio_bodega", 
                        80)
    ),
    column(6,
           cifra("total_bodegas", textOutput("total_bodegas")),
           cifra("superficie_exterior", textOutput("superficie_exterior")),
           cifra("superficie_subterranea", textOutput("superficie_subterranea")),
           cifra("ingreso_bodega_estacionamiento", textOutput("ingreso_bodega_estacionamiento")),
    )
  ),
  
  hr(),
  
  # total ingresos
  fluidRow(
    column(12,
           cifra("total_ingreso", textOutput("total_ingreso"))
    )
  ),
  
  hr(),
  
  ## costos ----
  fluidRow(
    column(6, 
           
           h3("Costos"),
           
           numericInput("costo_construccion_sobre_nt1",
                        "costo_construccion_sobre_nt1",
                        24),
           numericInput("costo_construccion_sobre_nt2",
                        "costo_construccion_sobre_nt2",
                        18),
           numericInput("costo_construccion_subterraneo",
                        "costo_construccion_subterraneo",
                        14),
           numericInput("costo_construccion_estacionamiento_exterior",
                        "costo_construccion_estacionamiento_exterior",
                        5.0),
           
           # costo urbanizacion
           numericInput("costo_urbanizacion_areaverde_exterior",
                        "costo_urbanizacion_areaverde_exterior",
                        2.0),
           
           ### costos proyecto
           numericInput("costo_proyecto_arquitectura",
                        "costo_proyecto_arquitectura",
                        0.020),
           numericInput("costo_proyecto_permisos",
                        "costo_proyecto_permisos",
                        0.025),
           
           # gastos administrativos
           numericInput("costo_proyecto_administrativo_comercialización",
                        "costo_proyecto_administrativo_comercialización",
                        0.025),
           numericInput("costo_proyecto_administrativo_publicidad",
                        "costo_proyecto_administrativo_publicidad",
                        0.040),
           numericInput("costo_proyecto_administrativo_administración",
                        "costo_proyecto_administrativo_administración",
                        0.035)
           
    ),
    column(6,
           cifra("subtotal_terreno:", textOutput("subtotal_terreno")),
           
           br(),
           cifra("suma_superficies_totales:", textOutput("suma_superficies_totales")),
           cifra("suma_superficies_mercado:", textOutput("suma_superficies_mercado")),
           cifra("suma_superficies_tramo_1y2:", textOutput("suma_superficies_tramo_1y2")),
           
           br(),
           cifra("total_costo_construccion_sobre_nt1:", textOutput("total_costo_construccion_sobre_nt1")),
           cifra("total_costo_construccion_sobre_nt2:", textOutput("total_costo_construccion_sobre_nt2")),
           cifra("total_costo_construccion_subterraneo:", textOutput("total_costo_construccion_subterraneo")),
           cifra("total_costo_construccion_estacionamiento_exterior:", textOutput("total_costo_construccion_estacionamiento_exterior")),
           cifra("total_costo_urbanizacion_areaverde_exterior:", textOutput("total_costo_urbanizacion_areaverde_exterior")),
           
           br(),
           cifra("costo_proyecto:", textOutput("costo_proyecto")),
           cifra("gastos_administrativos:", textOutput("gastos_administrativos")),
           br(),
           cifra("subtotal_directo:", textOutput("subtotal_directo")),
           cifra("subtotal_indirecto:", textOutput("subtotal_indirecto")),
           br(),
           cifra("costo_total:", textOutput("costo_total")),      
    )
  ),
  
  hr(),
  
  ## rentabilidad ----
  fluidRow(
    column(12,
           
           
           div(style = css(position = "fixed",
                           bottom = "12px", right = "12px"),
               div(style = css(padding = "18px",
                               background_color = color$detalle,
                               border = paste("3px solid", color$fondo),
                               border_radius = "10px"),
                   h3("Resultados", style = css(margin = 0)),
                   cifra("resultado_ingreso_deptos:", textOutput("resultado_ingreso_deptos")),
                   cifra("resultado_ingreso_bodega_estacionamiento:", textOutput("resultado_ingreso_bodega_estacionamiento")),
                   cifra("resultado_total_ingreso:", textOutput("resultado_total_ingreso")),
                   cifra("resultado_total_ganancia:", textOutput("resultado_total_ganancia")),
                   cifra("resultado_costo_total:", textOutput("resultado_costo_total")),
                   cifra("resultado_rentabilidad:", textOutput("resultado_rentabilidad"))
               )
           )
    )
  )
)


server <- function(input, output, session) {
  
  ## escenarios ----
  
  # cambiar escenarios
  observeEvent(input$escenario, {
    if (input$escenario == "EV-MERC") {
      updateSelectInput(session, "tramo_s1", selected = "Mercado") 
      updateSelectInput(session, "tramo_s2", selected = "Mercado") 
      updateSelectInput(session, "tramo_s3", selected = "Mercado") 
      updateSelectInput(session, "tramo_s4", selected = "Mercado") 
      updateSelectInput(session, "tramo_s5", selected = "Mercado")
      
      updateNumericInput(session, "precios_m2_tipos_s1", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s2", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s3", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s4", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s5", value = 50)
      
      updateNumericInput(session, "dotacion_est_viv_social", value = 0)
      
    } else if (input$escenario == "EV-INT1") {
      updateSelectInput(session, "tramo_s1", selected = "Mercado") 
      updateSelectInput(session, "tramo_s2", selected = "Tramo 3") 
      updateSelectInput(session, "tramo_s3", selected = "Tramo 1") 
      updateSelectInput(session, "tramo_s4", selected = "Tramo 2") 
      updateSelectInput(session, "tramo_s5", selected = "Mercado")
      
      updateNumericInput(session, "precios_m2_tipos_s1", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s2", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s3", value = 27)
      updateNumericInput(session, "precios_m2_tipos_s4", value = 31)
      updateNumericInput(session, "precios_m2_tipos_s5", value = 50)
      
      updateNumericInput(session, "dotacion_est_viv_social", value = 1)
      
    } else if (input$escenario == "EV-INT2") {
      updateSelectInput(session, "tramo_s1", selected = "Mercado") 
      updateSelectInput(session, "tramo_s2", selected = "Tramo 3") 
      updateSelectInput(session, "tramo_s3", selected = "Tramo 1") 
      updateSelectInput(session, "tramo_s4", selected = "Tramo 2") 
      updateSelectInput(session, "tramo_s5", selected = "Mercado")
      
      updateNumericInput(session, "precios_m2_tipos_s1", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s2", value = 50)
      updateNumericInput(session, "precios_m2_tipos_s3", value = 27)
      updateNumericInput(session, "precios_m2_tipos_s4", value = 31)
      updateNumericInput(session, "precios_m2_tipos_s5", value = 50)
      
      updateNumericInput(session, "dotacion_est_viv_social", value = 1)
      
      updateNumericInput(session, "compensacion_densidad", value = 1.42)
      updateNumericInput(session, "compensacion_construccion", value = 1.40)
    }
  })
  
  
  ## castigo ----
  
  
  p_integracion = reactive(
    ifelse(mercado_o_tramos() != "Mercado", porcentaje_tipos(), 0) |> sum()
  )
  
  # =+(input$b_integracion*p_integracion()+input$b_espaciopublico_integracion*p_integracion()/input$calidad_ep+input$b_unidades_integracion*p_integracion()*total_cantidad_unidades())/input$b_descuento*-1
  p_castigo = reactive({
    # browser()
    
    # ('DATOS (CASO-1)'!I6 * R15 + 'DATOS (CASO-1)'!I8 * R15 /'DATOS (CASO-1)'!I11 + 'DATOS (CASO-1)'!I9 * R15 * J20) / 'DATOS (CASO-1)'!I7*-1
    (input$b_integracion * p_integracion() + input$b_espaciopublico_integracion * 
       p_integracion() / input$calidad_ep + input$b_unidades_integracion * 
       p_integracion() * 
       total_cantidad_unidades()) / 
      input$b_descuento * -1
    # esto no da 44 jamás
  })
  
  output$p_integracion <- renderText(p_integracion() |> porcentaje())
  output$p_castigo <- renderText(p_castigo() |> porcentaje())
  
  
  ## cabida ----
  output$sup_total_terreno <- renderText(input$sup_total_terreno |> mt2())
  # neta
  superficie_neta = reactive(input$sup_total_terreno - input$faja_up_expropiacion)
  
  normativa_densidad = reactive(input$normativa_densidad * input$compensacion_densidad)
  normativa_construccion = reactive(input$normativa_construccion * input$compensacion_construccion)
  
  output$superficie_neta <- renderText(superficie_neta() |> mt2())
  
  # norma aplicada
  output$normativa_densidad <- renderText(normativa_densidad())
  output$normativa_construccion <- renderText(normativa_construccion())
  
  
  # superficie neta p/desarrollo
  superficie_max_util_const = reactive(superficie_neta() * normativa_construccion())
  output$superficie_max_util_const <- renderText(superficie_max_util_const() |> mt2())
  
  area_comun_mt2 = reactive(superficie_max_util_const() * input$superficie_area_comun)
  output$area_comun_mt2 <- renderText(area_comun_mt2() |> mt2())
  
  # máximos vendibles
  max_unidades_vendibles = reactive(
    (input$sup_total_terreno + input$faja_exterior_eje_ep)/10000 * ifelse(input$unidad_normativa == "hab/ha", 
                                                                          (normativa_densidad()/4), normativa_densidad()))
  output$max_unidades_vendibles <- renderText(max_unidades_vendibles() |> round())
  
  max_superficie_vendible = reactive(superficie_max_util_const() * (100-(input$superficie_area_comun*100))/100) #mt2
  output$max_superficie_vendible <- renderText(max_superficie_vendible() |> mt2())
  
  
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
  output$cantidades_tipos <- renderText(cantidades_tipos() |> round())
  
  total_cantidad_unidades = reactive(sum(cantidades_tipos()) |> round())
  output$total_cantidad_unidades <- renderText(total_cantidad_unidades())
  
  # superficie por tipo (mt2)
  superficies_tipos = reactive(cantidades_tipos() * tamaños_tipos())
  output$superficies_tipos <- renderText(superficies_tipos() |> mt2())
  
  
  ### precio ----
  precios_m2_tipos <- reactive(
    c(input$precios_m2_tipos_s1,
      input$precios_m2_tipos_s2,
      input$precios_m2_tipos_s3,
      input$precios_m2_tipos_s4,
      input$precios_m2_tipos_s5)
  )
  
  
  # precio de las unidades (precio por m2 multiplicado por superficie)
  precios_tipos = reactive({
    
    precios <- tamaños_tipos() * precios_m2_tipos()
    
    # si se activa el castigo, si un depto es tipo mercado, se multiplica el precio de la unidad por el % de castigo
    if (input$castigo) {
      precios <- ifelse(mercado_o_tramos() == "Mercado", precios * (1-p_castigo()), precios)
      # precios <- ifelse(mercado_o_tramos() == "Mercado", precios * (1-.44), precios)
    }
    return(precios)
  })
  
  output$precios_tipos <- renderText(precios_tipos() |> uf())
  
  ingreso_deptos = reactive({
    # if (input$castigo == FALSE) {
    sum(cantidades_tipos() * precios_tipos()) 
  })
  output$ingreso_deptos <- renderText(ingreso_deptos() |> precio())
  
  
  ### estacionamientos ----
  
  # estacionamientos 50 mt2
  estac_viv_menor_50m2 <- reactive({
    ifelse(tamaños_tipos() < 50, cantidades_tipos() * input$dotacion_est_viv_menor_50m2, 0)
  })
  total_estac_viv_menor_50m2 <- reactive(sum(estac_viv_menor_50m2()) |> round())
  output$total_estac_viv_menor_50m2 <- renderText(total_estac_viv_menor_50m2())
  
  # entre 50 y 100
  estac_viv_sobre_50m2_menor_100m2 <- reactive({
    ifelse(
      mercado_o_tramos() != "Tramo 1" &
        tamaños_tipos() >= 50 & 
        tamaños_tipos() < 100, 
      cantidades_tipos() * input$dotacion_est_viv_sobre_50m2_menor_100m2, 0)
  })
  total_estac_viv_sobre_50m2_menor_100m2 <- reactive(sum(estac_viv_sobre_50m2_menor_100m2()))
  output$total_estac_viv_sobre_50m2_menor_100m2 <- renderText(total_estac_viv_sobre_50m2_menor_100m2())
  
  # vivienda social
  estac_viv_social <- reactive({
    ifelse(mercado_o_tramos() == "Tramo 1", cantidades_tipos() * input$dotacion_est_viv_social, 0)
  })
  total_estac_viv_social <- reactive(sum(estac_viv_social()))
  output$total_estac_viv_social <- renderText(total_estac_viv_social())
  
  total_estacionamientos <- reactive({
    sum(total_estac_viv_menor_50m2(),
        total_estac_viv_sobre_50m2_menor_100m2(),
        total_estac_viv_social()) |> 
      round()
  })
  output$total_estacionamientos <- renderText(total_estacionamientos())
  
  # vendibles
  total_estacionamientos_vendibles = reactive(
    sum(total_estac_viv_menor_50m2(),
        total_estac_viv_sobre_50m2_menor_100m2()) |> 
      round()
  )
  output$total_estacionamientos_vendibles <- renderText(total_estacionamientos_vendibles())
  
  
  ### bodega ----
  
  total_bodegas = reactive(input$bodega_dotacion * total_cantidad_unidades())
  output$total_bodegas <- renderText(total_bodegas())
  
  superficie_exterior = reactive(
    ((total_estacionamientos() * input$estacionamiento_visita) + (total_estacionamientos() * input$estacionamiento_exterior)) * 12.5
  )
  output$superficie_exterior <- renderText(superficie_exterior() |> mt2())
  
  superficie_subterranea = reactive(
    ((total_estacionamientos() * input$estacionamiento_subterraneo) * 12.5) + (total_bodegas() * 3)
  )
  output$superficie_subterranea <- renderText(superficie_subterranea() |> mt2())
  
  ingreso_bodega_estacionamiento = reactive(
    (input$precio_estacionamiento_exterior * total_estacionamientos_vendibles() * input$estacionamiento_exterior) +
      (input$precio_estacionamiento_subterraneo * total_estacionamientos_vendibles() * input$estacionamiento_subterraneo) +
      (input$precio_bodega * total_bodegas()) # uf 
  )
  output$ingreso_bodega_estacionamiento <- renderText(ingreso_bodega_estacionamiento() |> uf())
  
  
  # total ingresos
  total_ingreso = reactive(ingreso_deptos() + ingreso_bodega_estacionamiento())
  output$total_ingreso <- renderText(total_ingreso() |> uf())
  
  
  ## costos ----
  
  
  ### subtotales
  subtotal_terreno = reactive(input$valor_suelo_uf * input$sup_total_terreno)
  output$subtotal_terreno <- renderText(subtotal_terreno() |> uf())
  
  suma_superficies_totales = reactive(sum(superficies_tipos()))
  suma_superficies_mercado = reactive(sum(ifelse(mercado_o_tramos() %in% c("Mercado", "Tramo 3"), superficies_tipos(), 0)))
  suma_superficies_tramo_1 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 1"), superficies_tipos(), 0)))
  suma_superficies_tramo_2 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 2"), superficies_tipos(), 0)))
  suma_superficies_tramo_1y2 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 1", "Tramo 2"), superficies_tipos(), 0)))
  output$suma_superficies_totales <- renderText(suma_superficies_totales() |> mt2())
  output$suma_superficies_mercado <- renderText(suma_superficies_mercado() |> mt2())
  output$suma_superficies_tramo_1y2 <- renderText(suma_superficies_tramo_1y2() |> mt2())
  
  total_costo_construccion_sobre_nt1 = reactive((input$costo_construccion_sobre_nt1 *  suma_superficies_mercado() / (1 -input$superficie_area_comun)))
  total_costo_construccion_sobre_nt2 = reactive((input$costo_construccion_sobre_nt2 *  suma_superficies_tramo_1y2() / (1 -input$superficie_area_comun)))
  output$total_costo_construccion_sobre_nt1 <- renderText(total_costo_construccion_sobre_nt1() |> uf())
  output$total_costo_construccion_sobre_nt2 <- renderText(total_costo_construccion_sobre_nt2() |> uf())
  
  total_costo_construccion_subterraneo = reactive((input$costo_construccion_subterraneo * superficie_subterranea()))
  total_costo_construccion_estacionamiento_exterior = reactive((input$costo_construccion_estacionamiento_exterior * superficie_exterior()))
  total_costo_urbanizacion_areaverde_exterior = reactive((input$costo_urbanizacion_areaverde_exterior * superficie_neta()) )
  output$total_costo_construccion_subterraneo <- renderText(total_costo_construccion_subterraneo() |> uf())
  output$total_costo_construccion_estacionamiento_exterior <- renderText(total_costo_construccion_estacionamiento_exterior() |> uf())
  output$total_costo_urbanizacion_areaverde_exterior <- renderText(total_costo_urbanizacion_areaverde_exterior() |> uf())
  
  # costo directo
  subtotal_directo = reactive(
    sum(total_costo_construccion_sobre_nt1(),
        total_costo_construccion_sobre_nt2(),
        total_costo_construccion_subterraneo(),
        total_costo_construccion_estacionamiento_exterior(),
        total_costo_urbanizacion_areaverde_exterior())
  )
  output$subtotal_directo <- renderText(subtotal_directo() |> uf())
  # # formula subtotal directo
  # (E33 *
  #     (L20/ 
  #        ((100-L9)/100)-
  #        (SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 2")+
  #           (SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 1"))
  #        )
  #     ) +
  #     (E34*SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 2")) +
  #     (E34*SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 1") + (E35*L29) + (E36*L28) + (E39*E9)
  #     )
  #   )
  # 
  # (total_costo_construccion_sobre_nt1() *
  #     (L20/ 
  #        ((100-L9)/100)-
  #        (SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 2")+
  #           (SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 1"))
  #        )
  #     ) +
  #     (E34*SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 2")) +
  #     (E34*SUMAR.SI.CONJUNTO(L15:L19;G15:G19;"Tramo 1") + (E35*L29) + (E36*L28) + (E39*E9)
  #     )
  # )
  
  # costo indirecto  
  costo_proyecto = reactive((input$costo_proyecto_arquitectura + input$costo_proyecto_permisos) * subtotal_directo())
  gastos_administrativos = reactive(total_ingreso() * sum(input$costo_proyecto_administrativo_comercialización, input$costo_proyecto_administrativo_publicidad, input$costo_proyecto_administrativo_administración))
  # uno de estos dos está incorrecto
  
  # incorrecto:
  subtotal_indirecto = reactive(costo_proyecto() + gastos_administrativos()) # mayor en int1
  
  # formula subtotal indirecto
  # subtotal_indirecto = reactive({
  #   ((
  #   (
  #     (input$costo_proyecto_arquitectura + input$costo_proyecto_permisos) *
  #       ((total_costo_construccion_sobre_nt1() *
  #           (suma_superficies_totales()/(100-input$superficie_area_comun)) - (suma_superficies_tramo_2() + (suma_superficies_tramo_1()))) +
  #           total_costo_construccion_subterraneo() + total_costo_construccion_estacionamiento_exterior() + total_costo_urbanizacion_areaverde_exterior()
  #         )
  #        )
  #     )
  #    / 100) +
  # ((total_ingreso() - ingreso_deptos()) * (
  # sum(input$costo_proyecto_administrativo_comercialización, input$costo_proyecto_administrativo_publicidad, input$costo_proyecto_administrativo_administración) # (H37+H38+H39)
  # /100))
  # })

    # todo esto es ingreso_deptos() 
# cantidades_tramo1 = reactive(ifelse(mercado_o_tramos() == "Tramo 1", cantidades_tipos(), 0))
# cantidades_tramo2 = reactive(ifelse(mercado_o_tramos() == "Tramo 2", cantidades_tipos(), 0))
# cantidades_tramo3 = reactive(ifelse(mercado_o_tramos() == "Tramo 3", cantidades_tipos(), 0))
# 
# precios_tramo1 = reactive(ifelse(mercado_o_tramos() == "Tramo 1", precios_tipos(), 0))
# precios_tramo2 = reactive(ifelse(mercado_o_tramos() == "Tramo 2", precios_tipos(), 0))
# precios_tramo3 = reactive(ifelse(mercado_o_tramos() == "Tramo 3", precios_tipos(), 0))
# 
# (cantidades_tramo1() * precios_tramo1()) +
# (cantidades_tramo2() * precios_tramo2()) +
# (cantidades_tramo3() * precios_tramo3())

  output$costo_proyecto <- renderText(costo_proyecto() |> uf())
  output$gastos_administrativos <- renderText(gastos_administrativos() |> uf())
  output$subtotal_indirecto <- renderText(subtotal_indirecto() |> uf())
  
  # costo total
  costo_total = reactive(
    sum(subtotal_terreno(), # ok int1
        subtotal_directo(), # ok en int1
        subtotal_indirecto() # mayor en int1
    )
  )
  output$costo_total <- renderText(costo_total() |> uf())
  
  
  
  
  ## rentabilidad ----
  
  ### rentabilidad mercado ----
  total_ganancia = reactive(total_ingreso() - costo_total()) # uf
  
  rentabilidad = reactive(total_ganancia() / costo_total()) # %
  
  
  
  # resultados
  output$resultado_ingreso_deptos <- renderText(ingreso_deptos() |> uf())
  output$resultado_ingreso_bodega_estacionamiento <- renderText(ingreso_bodega_estacionamiento() |> uf())
  output$resultado_total_ingreso <- renderText(total_ingreso() |> uf())
  output$resultado_total_ganancia <- renderText(total_ganancia() |> uf())
  output$resultado_costo_total <- renderText(costo_total() |> uf())
  output$resultado_rentabilidad <- renderText(rentabilidad() |> porcentaje())
  
  
  # notificaciones ----
  rentabilidad_d <- rentabilidad |> debounce(200)
  
  observeEvent(rentabilidad_d(), {
    
    showNotification(glue("La rentabilidad ha camibiado a {rentabilidad() |> porcentaje()}"), 
                     duration = 1, type = "message")
  }, ignoreInit = TRUE)
  
  
  observeEvent(porcentaje_tipos(), {
    if (sum(porcentaje_tipos()) > 1) {
      showNotification(glue("Los porcentajes no pueden sumar más de 100%"), type = "error")
    }
  })
  
}

shinyApp(ui, server)