library(dplyr)
library(purrr)
library(shiny)
library(bslib)
library(htmltools)
library(shinyWidgets)
library(glue)
library(thematic)
library(shinyjs)

# library(reactlog)
# reactlog::reactlog_enable()

thematic_shiny(font = "auto")

lista_tramos <- c("Mercado", "Tramo 3", "Tramo 2", "Tramo 1")

color <- list("fondo" = "#F3F4F8",
              "texto" = "#404040",
              "detalle" = "#C9C9C9",
              "primario" = "#0779CD")

source("funciones.R", local = TRUE)


# ui <- page_fluid(
ui <- page_fluid(
  theme = bs_theme(
    bg = color$fondo, fg = color$texto, primary = color$primario,
    # bslib also makes it easy to import CSS fonts
    base_font = bslib::font_google("Roboto Condensed")
  ),
  
  useShinyjs(),
  
  tags$style(
    HTML("h4 {margin-top: 6px;}
          h3 {margin-top: 6px;}")
  ),
  
  tags$style(
    HTML("h5 {margin-bottom: -20px;}")
  ),
  
  tags$style(
    HTML(".alerta {background-color: #F3CECE !important;}")
  ),
  
  div(style = css(height = "12px")),
  
  navset_card_tab(
    # pestaña 1 ----
    nav_panel("Datos del terreno",
              
              h1("Datos del terreno"),
              
              layout_columns(
                col_widths = c(6, 6),
                
                ## datos terreno ----
                card(
                  card_header(
                    h3("Superficies")),
                  card_body(
                    
                    autonumericInput("sup_total_terreno",
                                     label = "Superficie total del terreno",
                                     align = "left", currencySymbol = " m²", currencySymbolPlacement = "s",
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 7281, step = 1),
                    
                    autonumericInput("faja_up_expropiacion",
                                     label = "Faja U.P. (expropiación)",
                                     align = "left", currencySymbol = " m²", currencySymbolPlacement = "s",
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 1634, step = 1),
                    
                    autonumericInput("faja_exterior_eje_ep",
                                     label = "Faja exterior a eje EP",
                                     align = "left", currencySymbol = " m²", currencySymbolPlacement = "s",
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 565, step = 1),
                    
                    autonumericInput("valor_suelo_uf",
                                     label = "Valor de suelo de referencia",
                                     currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", 
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 14.5, step = 0.5)
                  )
                ),
                
                card(
                  card_header(
                    h3("Precios integración")),
                  
                  card_body(
                    
                    em("Precio Venta Deptos Integración: Se consideran valores según llamado especial 2024 (Res. Exenta 385)"),
                    
                    
                    autonumericInput("precio_max_int_t1",
                                     label = "Tramo 1",
                                     currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", 
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 1400, step = 100),
                    autonumericInput("precio_max_int_t2",
                                     label = "Tramo 2",
                                     currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", 
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 1700, step = 100),
                    autonumericInput("precio_max_int_t3",
                                     label = "Tramo 3",
                                     currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", 
                                     decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0,
                                     value = 2250, step = 100),
                    
                    # sliderInput("calidad_ep",
                    #             "calidad_ep",
                    #             min = 1, max = 4, value = 3,
                    #             width = "100%")
                    
                  )
                )
              ),
              
              card(
                card_header(
                  h4("Espacio público")),
                sliderTextInput(
                  inputId = "calidad_ep",
                  label = "Calidad del Espacio Público en el entorno del Proyecto", 
                  grid = TRUE,
                  force_edges = TRUE,
                  choices = c("Deficiente",
                              "Regular",
                              "Bueno",
                              "Muy bueno")
                ),
                
                explicacion("La Calidad del Espacio Público se refiere al nivel de arborización, iluminación, veredas, paraderos y acceso a estaciones de metro, entre otros.")
              ),
              
              
              card(
                card_header(h3("Normativa Aplicable (actual) y Espacios Comunes")),
                
                card_body(
                  
                  div("Densidad permitida (actual)",
                      class = "control-label",
                      style = css(margin_bottom = "-14px")),
                  
                  
                  layout_columns(
                    col_widths = c(6, 6),
                    
                    div(
                      numericInput("normativa_densidad",
                                   NULL,
                                   value = 1500, step = 100) |> 
                        tooltip("Incremento en Densidad: Indicar si corresponde incremento según art. 6.1.8 de OGUC (C. Vivienda Económica)"),
                      
                      numericInput("normativa_construccion",
                                   label = "Coeficiente de Constructibilidad permitido (actual)",
                                   value = 3.2, step = 0.1) |> 
                        tooltip("Incremento en constructibilidad: Indicar si corrende incremento según art. 63 de LGUC (fusión predial) y art. 2.6.5, 2.6.6 y 2.6.7 de OGUC (C. Armónico)")
                    ),
                    
                    div(
                      selectInput("unidad_normativa",
                                  NULL, 
                                  choices = c("hab/ha", "viv/ha")),
                      
                      div(style = css(margin_bottom = "12px"),
                          explicacion("Unidad de medida para Densidad (hab/há o viv/há)")
                      ),
                      
                      autonumericInput("superficie_area_comun",
                                       currencySymbol = "%", currencySymbolPlacement = "s",
                                       "Superficie de Área Común Proyectada",
                                       decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = ".",
                                       value = 0.15*100, min = 0*100, max = 1*100, step = 0.01*100
                      ) |> 
                        tooltip("Area Común: Se considera un superficie en torno al 15% de la superficie máxima construible"),
                      
                      explicacion("Porcentaje del área construida que se destina a espacios no vendibles, como pasillos, corredores, etc.")
                      
                    )
                  ),
                  
                  
                  div(
                    hr(),
                    h3("Superficies y Unidades Resultantes"),
                    
                    # br(),
                    h4("Superficie terreno"),
                    cifra("Superficie Total de Terreno:", textOutput("sup_total_terreno")),
                    # neta
                    cifra("Superficie Neta:", textOutput("superficie_neta")),
                    
                    hr(),
                    h3("Superficies y Unidades Máximas según Cabida"),
                    
                    h4("Superficie neta p/desarrollo"),
                    cifra("Superficie máxima útil construible:", textOutput("superficie_max_util_const")),
                    cifra("Área común:", textOutput("area_comun_mt2")),
                    
                    br(),
                    h4("Máximos vendibles"),
                    cifra("Máximo de unidades vendibles:", textOutput("max_unidades_vendibles")),
                    cifra("Sup. Máxima Vendible:", textOutput("max_superficie_vendible")),
                    explicacion("Valor resultante de la resta entre la sup. máxima construible y el área común", margin_top = "-4px", margin_left = "3px"),
                    
                    # hr(),
                    # # norma aplicada
                    # h4("Norma aplicada"),
                    # cifra("Densidad:", textOutput("normativa_densidad")),
                    # 
                    # cifra("Construcción:", textOutput("normativa_construccion")),
                  )
                )
              ), 
              
              
              
              ## cabida ---- 
              # card(  
              #   card_header(
              #     h3("Cabida")
              #   ),
              #   
              #   card_body(
              #     
              #     
              #   )
              # ),
              
              
              ## castigo ----
              card( 
                card_header(
                  h3("Aplicación de Minusvalía en Precio de Unidades de Mercado")
                ),
                
                p("Aplicar variación en valor de departamentos de mercado por percepción de integración"),
                checkboxInput(
                  inputId = "castigo",
                  label = "Aplicar castigo", 
                  value = FALSE
                ),
                div(style = css(font_size = "80%"),
                    p("Esta variación (que normalmente es una minusvalía) se refiere a un potencial castigo en el valor que podrían tener los departamentos de mercado por estar en un proyecto de integración. Esta variación se calcula de acuerdo a modelo matemático calibrado con encuesta de percepción de proyectos de integración, y es variable según características del proyecto.")
                ),
                
                # actionButton("castigo_opciones", "Mostrar betas castigo"),
                # 
                # div(id = "opciones_castigo",
                #     
                #     numericInput("b_integracion",
                #                  "b_integracion",
                #                  0.00891, step = 0.0001),
                #     numericInput("b_descuento",
                #                  "b_descuento",
                #                  0.02094, step = 0.0001),
                #     numericInput("b_espaciopublico_integracion",
                #                  "b_espaciopublico_integracion",
                #                  -0.01580, step = 0.0001),
                #     numericInput("b_unidades_integracion",
                #                  "b_unidades_integracion",
                #                  -0.00005, step = 0.00001)
                # )
              )
              
              
    ),
    
    
    # pestaña 2 ----
    nav_panel("Evaluación",
              
              card(
                card_header(h1("Evaluación")),
            card_body(
              div(
                  radioGroupButtons(
                    inputId = "escenario",
                    individual = T,
                    label = "Escenarios de evaluación", 
                    # choices = c("EV-MERC", "EV-INT1", "EV-INT2"), 
                    choices = c("EV1: Mercado" = "EV-MERC", 
                                "EV2: Con Integración" = "EV-INT1", 
                                "EV2: Con Integración y Compensación" = "EV-INT2"), 
                    selected = "EV-INT1",
                    width = "100%"
                  )
              ) |> tooltip("Cambiar escenario para establecer inputs predefinidos"),
              
              div(style = css(width = "100%"),
                  div(style = css(float = "right",
                                  scale = 0.8,
                                  opacity = 0.8),
              actionButton("flotante", label = "Mostrar resultados flotantes", width = "240px")
              )
              )
            )
    ),
              
              # hr(),
              
              div(
                
                
                
                ## ingresos ----
                div(
                  
                  # layout_columns(
                  #   col_widths = c(8, 4),
                    
                    div(
                      
                      card(
                        card_header(
                          h3("Mix de Departamentos en Proyecto")
                        ),
                        
                        card_body(id = "panel_ingresos",
                                  em("Cada fila de inputs corresponde a un tipo de vivienda"),
                                  layout_columns(
                                    col_widths = c(3, 3, 2, 2, 2),
                                    
                                    
                                    # div(em("Tipos"),
                                    #     em("Tipo 1"),
                                    #     em("Tipo 2"),
                                    #     em("Tipo 3"),
                                    #     em("Tipo 4"),
                                    #     em("Tipo 5"),
                                    # ),
                                    
                                    div(
                                      em("Tamaños"),
                                      autonumericInput("tamaño_tipo_s1", label = NULL, value = 38, step = 1, width = "100%", align = "left", currencySymbol = " m²", currencySymbolPlacement = "s", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("tamaño_tipo_s2", label = NULL, value = 45, step = 1, width = "100%", align = "left", currencySymbol = " m²", currencySymbolPlacement = "s", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("tamaño_tipo_s3", label = NULL, value = 52, step = 1, width = "100%", align = "left", currencySymbol = " m²", currencySymbolPlacement = "s", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("tamaño_tipo_s4", label = NULL, value = 55, step = 1, width = "100%", align = "left", currencySymbol = " m²", currencySymbolPlacement = "s", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("tamaño_tipo_s5", label = NULL, value = 62, step = 1, width = "100%", align = "left", currencySymbol = " m²", currencySymbolPlacement = "s", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      
                                    ),
                                    div(
                                      em("Tramos"),
                                      selectInput("tramo_s1", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                                      selectInput("tramo_s2", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                                      selectInput("tramo_s3", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                                      selectInput("tramo_s4", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%"),
                                      selectInput("tramo_s5", label = NULL, selected = "Mercado", choices = lista_tramos, width = "100%")
                                    ),
                                    div(
                                      em("%"),
                                      autonumericInput("porcentaje_s1", label = NULL, value = 0.15*100, step = 0.05*100, min = 0, max = 1*100, width = "100%", currencySymbol = "%", currencySymbolPlacement = "s", decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = "."),
                                      autonumericInput("porcentaje_s2", label = NULL, value = 0.20*100, step = 0.05*100, min = 0, max = 1*100, width = "100%", currencySymbol = "%", currencySymbolPlacement = "s", decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = "."),
                                      autonumericInput("porcentaje_s3", label = NULL, value = 0.25*100, step = 0.05*100, min = 0, max = 1*100, width = "100%", currencySymbol = "%", currencySymbolPlacement = "s", decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = "."),
                                      autonumericInput("porcentaje_s4", label = NULL, value = 0.15*100, step = 0.05*100, min = 0, max = 1*100, width = "100%", currencySymbol = "%", currencySymbolPlacement = "s", decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = "."),
                                      autonumericInput("porcentaje_s5", label = NULL, value = 0.25*100, step = 0.05*100, min = 0, max = 1*100, width = "100%", currencySymbol = "%", currencySymbolPlacement = "s", decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = "."),
                                      
                                    ),
                                    div(
                                      em("UF/m²"),
                                      autonumericInput("precios_m2_tipos_s1", label = NULL, value = 50, step = 5, min = 0, width = "100%", currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("precios_m2_tipos_s2", label = NULL, value = 50, step = 5, min = 0, width = "100%", currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("precios_m2_tipos_s3", label = NULL, value = 50, step = 5, min = 0, width = "100%", currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("precios_m2_tipos_s4", label = NULL, value = 50, step = 5, min = 0, width = "100%", currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      autonumericInput("precios_m2_tipos_s5", label = NULL, value = 50, step = 5, min = 0, width = "100%", currencySymbol = " UF", currencySymbolPlacement = "s", align = "left", decimalCharacter = ",", digitGroupSeparator = ".", decimalPlaces = 0),
                                      
                                    ),
                                    
                                    div(
                                      
                                      em("cantidades"),
                                            div(style = css(margin_top = "-20px"),
                                                uiOutput("cantidades_tipos")
                                            ),
                                      div(style = css(font_size = "90%"),
                                        p("Total:", textOutput("total_cantidad_unidades", inline = TRUE), "unid.")
                                      )
                                  )
                        ),
                        # hr(),
                        div(
                          div(style = css(float = "right"),
                              p("Ingreso total de unidades", textOutput("ingreso_deptos", inline = T))
                        )
                        )
                      ),
                      
                    ),
                    
                    # div(
                    #   card(
                    #     card_body(
                    #       h5("Unidades"),
                    #       p("Cantidad total de unidades:", textOutput("total_cantidad_unidades", inline = TRUE)),
                    #       div(style = css(margin_top = "-20px"),
                    #           uiOutput("cantidades_tipos")
                    #       ),
                    #       
                    #       h5("Superficie"),
                    #       p("Superficie total de unidades", textOutput("total_superficie_unidades", inline = T)),
                    #       # div(style = css(margin_top = "-20px"),
                    #       #     uiOutput("superficies_tipos")
                    #       # ),
                    # 
                    #       h5("Ingresos"),
                    #       p("Ingreso total de unidades", textOutput("ingreso_deptos", inline = T)),
                    #       # div(style = css(margin_top = "-20px"),
                    #       #     uiOutput("precios_tipos")
                    #       # ),
                    #       
                    #       
                    #       
                    #       
                    #       
                    #       
                    #     )
                    #   )
                    # )
                  )
                ),
                
                
                
                ### estacionamientos ----
                card(
                  card_header(  
                    h3("Estacionamientos")),
                  card_body(
                    layout_columns(
                      col_widths = c(7, 5),
                      div(
                        autonumericInput("dotacion_est_viv_menor_50m2",
                                         "dotacion_est_viv_menor_50m2",
                                         currencySymbol = " un/viv", currencySymbolPlacement = "s",
                                         0.33, step = 0.1),
                        numericInput("dotacion_est_viv_sobre_50m2_menor_100m2",
                                     "dotacion_est_viv_sobre_50m2_menor_100m2",
                                     0.5, step = 0.1),
                        numericInput("dotacion_est_rebaja",
                                     "dotacion_est_rebaja",
                                     0, step = 0.5),
                        numericInput("dotacion_est_viv_social",
                                     "dotacion_est_viv_social",
                                     0, step = 0.5),
                        
                        # total estacionamientos
                        numericInput("estacionamiento_subterraneo",
                                     "estacionamiento_subterraneo",
                                     0.50, step = 0.05),
                        numericInput("estacionamiento_exterior",
                                     "estacionamiento_exterior",
                                     0.50, step = 0.05),
                        numericInput("estacionamiento_visita",
                                     "estacionamiento_visita",
                                     0.15, step = 0.05)
                      ),
                      
                      div(
                        numericInput("precio_estacionamiento_subterraneo", 
                                     "precio_estacionamiento_subterraneo", 
                                     250, step = 5),
                        numericInput("precio_estacionamiento_exterior", 
                                     "precio_estacionamiento_exterior", 
                                     150, step = 5)
                      ),
                      
                      div(style = css(padding_top = "16px"),
                          
                          em("Dotación Estacionam.: Considera dotación para viviendas menores a 100m2 según PRMS y para viviendas de familias vulnerables según Ley de Copropiedad y Ley de Integración Social."),
                          br(),
                          cifra("total_estac_viv_menor_50m2", textOutput("total_estac_viv_menor_50m2")),
                          cifra("total_estac_viv_sobre_50m2_menor_100m2", textOutput("total_estac_viv_sobre_50m2_menor_100m2")),
                          cifra("total_estac_viv_social", textOutput("total_estac_viv_social")),
                          cifra("total_estacionamientos", textOutput("total_estacionamientos")),
                          cifra("total_estacionamientos_vendibles", textOutput("total_estacionamientos_vendibles")),
                      )
                    )
                  )
                ),
                
                
                ### bodegas ----
                card(
                  card_header(h3("Bodegas")),
                  card_body(
                    layout_columns(
                      col_widths = c(7, 5),
                      div(
                        numericInput("bodega_dotacion", 
                                     "bodega_dotacion", 
                                     1, step = 0.5),
                        numericInput("precio_bodega", 
                                     "precio_bodega", 
                                     80, step = 5)
                      ),
                      div(
                        style = css(padding_top = "16px"),
                        cifra("total_bodegas", textOutput("total_bodegas")),
                        cifra("superficie_exterior", textOutput("superficie_exterior")),
                        cifra("superficie_subterranea", textOutput("superficie_subterranea"))
                      )
                    )
                  )
                ),
                
                card(
                  cifra("Ingresos bodegas y estacionamientos:", textOutput("ingreso_bodega_estacionamiento"))
                ),
                
                # total ingresos
                card(
                  cifra("Ingresos totales:", textOutput("total_ingreso"))
                ),
                
                
                
                ## costos ----
                
                card(
                  card_header(
                    h3("Costos")
                  ),
                  card_body(
                    layout_columns(
                      col_widths = c(6, 6),
                      
                      div(
                        numericInput("costo_construccion_sobre_nt1",
                                     "costo_construccion_sobre_nt1",
                                     24, step = 1),
                        numericInput("costo_construccion_sobre_nt2",
                                     "costo_construccion_sobre_nt2",
                                     18, step = 1),
                        numericInput("costo_construccion_subterraneo",
                                     "costo_construccion_subterraneo",
                                     14, step = 1),
                        numericInput("costo_construccion_estacionamiento_exterior",
                                     "costo_construccion_estacionamiento_exterior",
                                     5.0, step = 1),
                        
                        # costo urbanizacion
                        numericInput("costo_urbanizacion_areaverde_exterior",
                                     "costo_urbanizacion_areaverde_exterior",
                                     2.0, step = 1),
                        
                        ### costos proyecto
                        numericInput("costo_proyecto_arquitectura",
                                     "costo_proyecto_arquitectura",
                                     0.020, step = 0.01),
                        numericInput("costo_proyecto_permisos",
                                     "costo_proyecto_permisos",
                                     0.025, step = 0.01),
                        
                        # gastos administrativos
                        numericInput("costo_proyecto_administrativo_comercialización",
                                     "costo_proyecto_administrativo_comercialización",
                                     0.025, step = 0.01),
                        numericInput("costo_proyecto_administrativo_publicidad",
                                     "costo_proyecto_administrativo_publicidad",
                                     0.040, step = 0.01),
                        numericInput("costo_proyecto_administrativo_administración",
                                     "costo_proyecto_administrativo_administración",
                                     0.035, step = 0.01)
                        
                      ),
                      
                      div(style = css(padding_top = "16px"),
                          
                          h4("Costos de construcción"),
                          br(),
                          cifra("suma_superficies_totales:", textOutput("suma_superficies_totales")),
                          cifra("suma_superficies_mercado:", textOutput("suma_superficies_mercado")),
                          # cifra("suma_superficies_tramo_1y2:", textOutput("suma_superficies_tramo_1y2")),
                          
                          br(),
                          cifra("total_costo_construccion_sobre_nt1:", textOutput("total_costo_construccion_sobre_nt1")),
                          cifra("total_costo_construccion_sobre_nt2:", textOutput("total_costo_construccion_sobre_nt2")),
                          br(),
                          cifra("total_costo_construccion_subterraneo:", textOutput("total_costo_construccion_subterraneo")),
                          cifra("total_costo_construccion_estacionamiento_exterior:", textOutput("total_costo_construccion_estacionamiento_exterior")),
                          cifra("total_costo_urbanizacion_areaverde_exterior:", textOutput("total_costo_urbanizacion_areaverde_exterior")),
                          
                          br(),
                          cifra("costo_proyecto:", textOutput("costo_proyecto")),
                          cifra("gastos_administrativos:", textOutput("gastos_administrativos")),
                          
                          hr(),
                          
                          h4("Subtotales"),
                          cifra("Subtotal terreno:", textOutput("subtotal_terreno")),
                          
                          cifra("Costo directo:", textOutput("costo_directo")),
                          explicacion("Considera suma de costo de construcción y costo de urbanización", margin_top = "-4px", margin_left = "4px"),
                          cifra("Costo indirecto:", textOutput("costo_indirecto")),
                          explicacion("Considera suma de costo proyecto y gastos administrativos (inmobiliarios)", margin_top = "-4px", margin_left = "4px"),
                          br(),
                          cifra("Costo total:", textOutput("costo_total")),      
                      )
                    )
                  )
                ),
                
                ## compensación ----
                div(id = "panel_compensacion",
                    card(
                      card_header(
                        h4("Compensación")
                      ),
                      autonumericInput("compensacion_densidad",
                                       label = "compensacion_densidad (%)",
                                       currencySymbol = "%", currencySymbolPlacement = "s",
                                       decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = ".",
                                       value = 0, min = 0),
                      
                      autonumericInput("compensacion_construccion",
                                       label = "compensacion_construccion (%)",
                                       currencySymbol = "%", currencySymbolPlacement = "s",
                                       decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = ".",
                                       value = 0, min = 0)
                    )
                    # autonumericInput("superficie_area_comun",
                    #                  currencySymbol = "%", currencySymbolPlacement = "s",
                    #                  "superficie_area_comun",
                    #                  decimalPlaces = 0, decimalCharacter = ",", digitGroupSeparator = ".",
                    #                  value = 0.15*100, min = 0*100, max = 1*100, step = 0.01*100
                    # ),
                ) |> hidden(),
                
                ## castigo ----
                div(id = "panel_castigo",
                    card(
                      card_header(
                        h3("Castigo")
                      ),
                      card_body(
                        layout_columns(
                          col_widths = c(6, 6),
                          
                          div(
                            cifra("p_integracion:", textOutput("p_integracion")),
                            cifra("p_castigo:", textOutput("p_castigo"))
                          )
                        )
                      )
                    )
                ),
                
                ## rentabilidad ----
                # flotante
                # fluidRow(
                # column(12,
                div(id = "panel_flotante",
                    style = css(position = "fixed",
                                bottom = "12px", right = "12px"),
                    div(style = css(padding = "18px",
                                    background_color = color$detalle,
                                    border = paste("3px solid", color$fondo),
                                    border_radius = "10px"),
                        uiOutput("resultados_rentabilidad"),
                    )
                ) |> hidden(),
                # )
                # ) |> hidden(),
                
                # estática
                card(
                  card_header(h3("Rentabilidad")),
                  card_body(
                    
                    uiOutput("resultados_rentabilidad_2"),
                    br()
                  )
                  
                )
              )
    )
  )
)




server <- function(input, output, session) {
  
  # observadores ----
  
  # la cantidad todal de unidades no puede superar el maximo vencible de unidades vendibles
  # total_cantidad_unidades
  # max_unidades_vendibles
  observe({
    req(input$total_cantidad_unidades)
    req(input$max_unidades_vendibles)
    
    if (input$total_cantidad_unidades > input$max_unidades_vendibles) {
      showNotification(session = session,
                       "La cantidad total de unidades no puede superar el máximo de unidades vendibles",
                       type = "error")
    }
  })
  
  # 
  # # lo mismo con la superficie total y le maximo de superficie vencible
  observe({
    req(input$sup_total_terreno)
    req(input$max_superficie_vendible)
    
    if (input$sup_total_terreno > input$max_superficie_vendible) {
      showNotification("La cantidad total de unidades no puede superar el máximo de unidades vendibles",
                       type = "error")
    }
  })
  
  
  # mostrar/ocultar panel flotante de resultados
  observeEvent(input$flotante, {
    toggle("panel_flotante")
  })
  
  # el castigo solo se debiera mostrar en escenarios 2 y 3
  observeEvent(input$escenario, {
    
    if (input$escenario == "EV-MERC") {
      hide("panel_castigo")
    } else {
      show("panel_castigo")
    }
  }
  )
  
  # compensación en escenarios 2 y 3
  observeEvent(input$escenario, {
    
    if (input$escenario == "EV-MERC") {
      hide("panel_compensacion")
    } else {
      show("panel_compensacion")
    }
  }
  )
  
  
  
  
  ## escenarios ----
  
  # cambiar escenarios
  observeEvent(input$escenario, {
    if (input$escenario == "EV-MERC") {
      updateSelectInput(session, "tramo_s1", selected = "Mercado") 
      updateSelectInput(session, "tramo_s2", selected = "Mercado") 
      updateSelectInput(session, "tramo_s3", selected = "Mercado") 
      updateSelectInput(session, "tramo_s4", selected = "Mercado") 
      updateSelectInput(session, "tramo_s5", selected = "Mercado")
      
      disable("tramo_s1")
      disable("tramo_s2")
      disable("tramo_s3")
      disable("tramo_s4")
      disable("tramo_s5")
      
      # updateNumericInput(session, "precios_m2_tipos_s1", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s2", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s3", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s4", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s5", value = 50)
      # 
      # updateNumericInput(session, "dotacion_est_viv_social", value = 0)
      
      # updateNumericInput(session, "compensacion_densidad", value = 0)
      # updateNumericInput(session, "compensacion_construccion", value = 0)
      
    } else if (input$escenario == "EV-INT1") {
      enable("tramo_s1")
      enable("tramo_s2")
      enable("tramo_s3")
      enable("tramo_s4")
      enable("tramo_s5")
      
      # updateSelectInput(session, "tramo_s1", selected = "Mercado") 
      # updateSelectInput(session, "tramo_s2", selected = "Tramo 3") 
      # updateSelectInput(session, "tramo_s3", selected = "Tramo 1") 
      # updateSelectInput(session, "tramo_s4", selected = "Tramo 2") 
      # updateSelectInput(session, "tramo_s5", selected = "Mercado")
      # 
      # updateNumericInput(session, "precios_m2_tipos_s1", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s2", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s3", value = 27)
      # updateNumericInput(session, "precios_m2_tipos_s4", value = 31)
      # updateNumericInput(session, "precios_m2_tipos_s5", value = 50)
      # 
      # updateNumericInput(session, "dotacion_est_viv_social", value = 1)
      # 
      # updateNumericInput(session, "compensacion_densidad", value = 1)
      # updateNumericInput(session, "compensacion_construccion", value = 1)
      
    } else if (input$escenario == "EV-INT2") {
      enable("tramo_s1")
      enable("tramo_s2")
      enable("tramo_s3")
      enable("tramo_s4")
      enable("tramo_s5")
      # updateSelectInput(session, "tramo_s1", selected = "Mercado") 
      # updateSelectInput(session, "tramo_s2", selected = "Tramo 3") 
      # updateSelectInput(session, "tramo_s3", selected = "Tramo 1") 
      # updateSelectInput(session, "tramo_s4", selected = "Tramo 2") 
      # updateSelectInput(session, "tramo_s5", selected = "Mercado")
      # 
      # updateNumericInput(session, "precios_m2_tipos_s1", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s2", value = 50)
      # updateNumericInput(session, "precios_m2_tipos_s3", value = 27)
      # updateNumericInput(session, "precios_m2_tipos_s4", value = 31)
      # updateNumericInput(session, "precios_m2_tipos_s5", value = 50)
      # 
      # updateNumericInput(session, "dotacion_est_viv_social", value = 1)
      # 
      # updateNumericInput(session, "compensacion_densidad", value = 1.42)
      # updateNumericInput(session, "compensacion_construccion", value = 1.40)
    }
  })
  
  
  
  ## castigo ----
  
  observeEvent(input$castigo_opciones, {
    toggle("opciones_castigo")
  })
  
  
  calidad_ep <- reactive({
    
    case_match(input$calidad_ep,
               "Deficiente" ~ 1,
               "Regular" ~ 2,
               "Bueno" ~ 3,
               "Muy bueno" ~ 4)
  })
  
  p_integracion = reactive(
    ifelse(mercado_o_tramos() != "Mercado", porcentaje_tipos(), 0) |> sum()
  )
  
  # =+(input$b_integracion*p_integracion()+input$b_espaciopublico_integracion*p_integracion()/calidad_ep()+input$b_unidades_integracion*p_integracion()*total_cantidad_unidades())/input$b_descuento*-1
  p_castigo = reactive({
    # browser()
    
    # ('DATOS (CASO-1)'!I6 * R15 + 'DATOS (CASO-1)'!I8 * R15 /'DATOS (CASO-1)'!I11 + 'DATOS (CASO-1)'!I9 * R15 * J20) / 'DATOS (CASO-1)'!I7*-1
    
    (input$b_integracion * p_integracion() + input$b_espaciopublico_integracion * 
       p_integracion() / calidad_ep() + input$b_unidades_integracion * 
       p_integracion() * # acá está malo
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
  
  normativa_densidad = reactive(input$normativa_densidad * (1+(input$compensacion_densidad/100)))
  normativa_construccion = reactive(input$normativa_construccion * (1+(input$compensacion_construccion/100)))
  
  output$superficie_neta <- renderText(superficie_neta() |> mt2())
  
  # norma aplicada
  output$normativa_densidad <- renderText(normativa_densidad())
  output$normativa_construccion <- renderText(normativa_construccion())
  
  
  # superficie neta p/desarrollo
  superficie_max_util_const = reactive(superficie_neta() * normativa_construccion())
  output$superficie_max_util_const <- renderText(superficie_max_util_const() |> mt2())
  
  # area_comun_mt2 = reactive(superficie_max_util_const() * (input$superficie_area_comun)/100)
  
  
  # area común teórica
  area_comun_mt2 = reactive(
    total_superficie_unidades() * (input$superficie_area_comun/100))
  
  superficie_total_proyecto = reactive(total_superficie_unidades()/0.85)
  
  area_comun_proyecto = reactive(superficie_total_proyecto()-  total_superficie_unidades())
  
  
  output$area_comun_mt2 <- renderText(area_comun_mt2() |> mt2())
  output$area_comun_proyecto <- renderText(area_comun_proyecto() |> mt2())
  
  # máximos vendibles
  max_unidades_vendibles = reactive(
    (input$sup_total_terreno + input$faja_exterior_eje_ep)/10000 * ifelse(input$unidad_normativa == "hab/ha", 
                                                                          (normativa_densidad()/4), normativa_densidad()))
  output$max_unidades_vendibles <- renderText(max_unidades_vendibles() |> round())
  
  max_superficie_vendible = reactive(superficie_max_util_const() * (1-(input$superficie_area_comun)/100)) #mt2
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
    c(
      (input$porcentaje_s1/100),
      (input$porcentaje_s2/100),
      (input$porcentaje_s3/100),
      (input$porcentaje_s4/100),
      (input$porcentaje_s5/100)
    )
  )
  
  cantidades_tipos = reactive(max_unidades_vendibles() * porcentaje_tipos())
  output$cantidades_tipos <- renderUI({
    #  |> lista_tipos()
    
    div(style = css(margin_top = "28px"),
        map(1:5, ~{
          cantidad <- cantidades_tipos()[.x]
          
          div(style = css(font_size = "90%", 
                          margin_top = "30px",
                          margin_bottom = "30px"),
              # p(paste0("Tipo ", .x, ":"), cantidad)
              p(paste(round(cantidad, 0), "unid."))
          )
        })
    )
        
  })
  
  cantidades_tipos_mercado = reactive(ifelse(mercado_o_tramos() == "Mercado", cantidades_tipos(), 0)) # se usa para gastos administrativos
  
  total_cantidad_unidades = reactive(sum(cantidades_tipos()) |> round())
  output$total_cantidad_unidades <- renderText(total_cantidad_unidades())
  
  # superficie por tipo (mt2)
  superficies_tipos = reactive(cantidades_tipos() * tamaños_tipos())
  output$superficies_tipos <- renderUI({
    superficies_tipos() |> lista_tipos()
  })
  
  
  total_superficie_unidades = reactive(sum(superficies_tipos()))
  output$total_superficie_unidades <- renderText(total_superficie_unidades() |> mt2())
  
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
  
  output$precios_tipos <- renderUI({
    precios_tipos() |> lista_tipos()
  })
  
  ingreso_deptos = reactive({
    # browser()
    # if (input$castigo == FALSE) {
    sum(cantidades_tipos() * precios_tipos()) 
  })
  
  
  # para gastos administrativos
  ingreso_deptos_mercado = reactive({
    # browser()
    sum(cantidades_tipos_mercado() * precios_tipos()) 
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
  suma_superficies_mercado = reactive(sum(ifelse(mercado_o_tramos() %in% c("Mercado"), superficies_tipos(), 0)))
  suma_superficies_tramo_1 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 1"), superficies_tipos(), 0)))
  suma_superficies_tramo_2 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 2"), superficies_tipos(), 0)))
  suma_superficies_tramo_3 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 3"), superficies_tipos(), 0)))
  
  # suma_superficies_tramo_1y2 = reactive(sum(ifelse(mercado_o_tramos() %in% c("Tramo 1", "Tramo 2"), superficies_tipos(), 0)))
  output$suma_superficies_totales <- renderText(suma_superficies_totales() |> mt2())
  output$suma_superficies_mercado <- renderText(suma_superficies_mercado() |> mt2())
  # output$suma_superficies_tramo_1y2 <- renderText(suma_superficies_tramo_1y2() |> mt2())
  
  ### costos construcción ----
  # para tramo 1 y tramo 2, hay precios de venta distintos. la enterga de esos tramos es opbra gruesa habitable, por lo uqe el costo de cponstrucción es menor
  # nt1 es terminación estándar, nt2 es obra gruesa
  # costos terminación estándar
  total_costo_construccion_sobre_nt1 = reactive({
    # browser()
    # 1677 + 2648 + 4560 
    superficies = suma_superficies_mercado() + suma_superficies_tramo_3()
    
    superficies_totales = superficies + area_comun_proyecto() # areas comunes del edificio
    
    superficies_totales * input$costo_construccion_sobre_nt1
    
  })
  
  # costos obra gruesa
  total_costo_construccion_sobre_nt2 = reactive({ 
    # browser()
    input$costo_construccion_sobre_nt2 *  
      (sum(suma_superficies_tramo_1(),
           suma_superficies_tramo_2())) 
  })
  
  output$total_costo_construccion_sobre_nt1 <- renderText(total_costo_construccion_sobre_nt1() |> uf())
  output$total_costo_construccion_sobre_nt2 <- renderText(total_costo_construccion_sobre_nt2() |> uf())
  
  total_costo_construccion_subterraneo = reactive((input$costo_construccion_subterraneo * superficie_subterranea()))
  total_costo_construccion_estacionamiento_exterior = reactive((input$costo_construccion_estacionamiento_exterior * superficie_exterior()))
  total_costo_urbanizacion_areaverde_exterior = reactive((input$costo_urbanizacion_areaverde_exterior * superficie_neta()) )
  output$total_costo_construccion_subterraneo <- renderText(total_costo_construccion_subterraneo() |> uf())
  output$total_costo_construccion_estacionamiento_exterior <- renderText(total_costo_construccion_estacionamiento_exterior() |> uf())
  output$total_costo_urbanizacion_areaverde_exterior <- renderText(total_costo_urbanizacion_areaverde_exterior() |> uf())
  
  ### costo directo ----
  
  # cantidad de unidades por 
  # observe({
  #   browser()
  #   total_superficie_unidades() * area_comun_mt2()
  #   
  #   tramo 1 y tamo 2 * total_costo_construccion_sobre_nt1()
  #   tramo 3 y vendible  total_costo_construccion_sobre_nt2
  # })
  
  
  
  costo_directo = reactive({
    # browser()
    sum(total_costo_construccion_sobre_nt1(),
        total_costo_construccion_sobre_nt2()) +
      sum(
        total_costo_construccion_subterraneo(),
        total_costo_construccion_estacionamiento_exterior(),
        total_costo_urbanizacion_areaverde_exterior() #urbanizacion
      )
  })
  
  # costo_directo_
  output$costo_directo <- renderText(costo_directo() |> uf())
  
  
  ### costo indirecto  ----
  costo_proyecto = reactive({
    # browser()
    
    # costo_directo()
    (costo_directo() - total_costo_construccion_sobre_nt2()) * # descontarles tramo 1 y 2
      (input$costo_proyecto_arquitectura + input$costo_proyecto_permisos)
  })
  # tramos 1 y 2 deberían ir con asistencia técnica del minvu, 
  # por lo que se deberían descontar esas superficies de departamentos como costo de proyecto (especulación)
  
  gastos_administrativos = reactive({
    # total_ingreso() * #dejar solo el ingreso de mercado (restar tramo 1, 2 y 3)
    # browser()
    gastos_administrativos <- sum(input$costo_proyecto_administrativo_comercialización, 
                                  input$costo_proyecto_administrativo_publicidad, 
                                  input$costo_proyecto_administrativo_administración)
    
    (ingreso_deptos_mercado() + ingreso_bodega_estacionamiento()) * gastos_administrativos
  })
  # uno de estos dos está incorrecto
  
  # incorrecto en ev 1 y 2, correcto degún ev merc y ev proy
  costo_indirecto = reactive(costo_proyecto() + gastos_administrativos()) # mayor en int1
  
  # formula subtotal indirecto
  # costo_indirecto = reactive({
  #   ((
  #     (
  #       (input$costo_proyecto_arquitectura + input$costo_proyecto_permisos) *
  #         ((total_costo_construccion_sobre_nt1() *
  #             (suma_superficies_totales()/(100-(input$superficie_area_comun)/100)) - (suma_superficies_tramo_2() + (suma_superficies_tramo_1()))) +
  #            total_costo_construccion_subterraneo() + total_costo_construccion_estacionamiento_exterior() + total_costo_urbanizacion_areaverde_exterior()
  #         )
  #     )
  #   )
  #   / 100) +
  #     ((total_ingreso() - ingreso_deptos()) * (
  #       sum(input$costo_proyecto_administrativo_comercialización, input$costo_proyecto_administrativo_publicidad, input$costo_proyecto_administrativo_administración) # (H37+H38+H39)
  #       /100))
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
  output$costo_indirecto <- renderText(costo_indirecto() |> uf())
  
  # costo total
  costo_total = reactive(
    sum(subtotal_terreno(), # ok int1
        costo_directo(), # ok en int1
        costo_indirecto() # mayor en int1
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
  
  
  # output
  output$resultados_rentabilidad_2 <- output$resultados_rentabilidad <- renderUI({
    req(ingreso_deptos(),
        ingreso_bodega_estacionamiento(),
        total_ingreso(),
        total_ganancia(),
        costo_total(),
        rentabilidad())
    # browser()
    div(
      h3("Resultados", style = css(margin = 0)),
      # cifra("resultado_ingreso_deptos:", textOutput("resultado_ingreso_deptos")),
      # cifra("resultado_ingreso_bodega_estacionamiento:", textOutput("resultado_ingreso_bodega_estacionamiento")),
      # cifra("resultado_total_ingreso:", textOutput("resultado_total_ingreso")),
      # cifra("resultado_total_ganancia:", textOutput("resultado_total_ganancia")),
      # cifra("resultado_costo_total:", textOutput("resultado_costo_total")),
      # cifra("resultado_rentabilidad:", textOutput("resultado_rentabilidad"))
      
      cifra("Ingresos deptos:", ingreso_deptos() |> uf()),
      cifra("Ingresos bodega y estacionamiento:", ingreso_bodega_estacionamiento() |> uf()),
      cifra("Ingresos totales:", total_ingreso() |> uf()),
      cifra("Ganancias totales:", total_ganancia() |> uf()),
      cifra("Costos totales:", costo_total() |> uf()),
      cifra("Rentabilidad:", rentabilidad() |> porcentaje())
    )
  })
  
  # —----
  # notificaciones ----
  rentabilidad_d <- rentabilidad |> debounce(300)
  
  observeEvent(rentabilidad_d(), {
    
    showNotification(glue("La rentabilidad ha camibiado a {rentabilidad() |> porcentaje()}"), 
                     duration = 1, type = "message")
  }, ignoreInit = TRUE)
  
  
  porcentaje_tipos_d <- porcentaje_tipos |> debounce(millis = 500)
  
  observeEvent(porcentaje_tipos_d(), {
    if (sum(porcentaje_tipos()) > 1) {
      porcentaje <- scales::percent(sum(porcentaje_tipos()), accuracy = 1)
      showNotification(glue("Los porcentajes no pueden sumar más de 100% (suman {porcentaje})"), type = "error")
      
      addClass(id = "panel_ingresos",
               class = "alerta")
      # updateAutonumericInput(session = session, options = 
    } else {
      removeClass(id = "panel_ingresos",
                  class = "alerta")
    }
  })
  
  observeEvent(porcentaje_tipos_d(), {
    if (sum(porcentaje_tipos()) < 1) {
      porcentaje <- scales::percent(sum(porcentaje_tipos()), accuracy = 1)
      
      showNotification(glue("Los porcentajes no pueden sumar menos de 100% (suman {porcentaje})"), type = "error")
      
      addClass(id = "panel_ingresos",
               class = "alerta")
      # updateAutonumericInput(session = session, options = 
    } else {
      removeClass(id = "panel_ingresos",
                  class = "alerta")
    }
  })
  
}

shinyApp(ui, server)