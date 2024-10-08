
# ev-merc ----

## cabida ----

# superficie terreno
# total
.sup_total_terreno 

# neta
superficie_neta = .sup_total_terreno - .faja_up_expropiacion

# norma aplicada
.normativa_densidad = 1500 #hab/ha
.normativa_construccion = 3.2

.unidad_normativa = "hab/ha" #"viv/ha"

# superficie neta p/desarrollo
superficie_max_util_const = superficie_neta * .normativa_construccion

.superficie_area_comun = 0.15 #15%
area_comun_mt2 = superficie_max_util_const * .superficie_area_comun #mt2

# máximos vendibles
max_unidades_vendibles = (.sup_total_terreno + .faja_exterior_eje_ep)/10000 * ifelse(.unidad_normativa == "hab/ha", (.normativa_densidad/4), .normativa_densidad)
max_superficie_vendible = superficie_max_util_const * (100-(.superficie_area_comun*100))/100 #mt2


## ingresos ----

### tipologías ----
.tamaño_tipo_1 = 38 #m2
.tamaño_tipo_2 = 45 #m2
.tamaño_tipo_3 = 52 #m2
.tamaño_tipo_4 = 55 #m2
.tamaño_tipo_5 = 62 #m2

tamaños_tipos <- c(.tamaño_tipo_1,
                   .tamaño_tipo_2,
                   .tamaño_tipo_3,
                   .tamaño_tipo_4,
                   .tamaño_tipo_5)


.mercado_tramo_tipo_1 = "Mercado"
.mercado_tramo_tipo_2 = "Mercado"
.mercado_tramo_tipo_3 = "Mercado"
.mercado_tramo_tipo_4 = "Mercado"
.mercado_tramo_tipo_5 = "Mercado"

mercado_o_tramos <- c(.mercado_tramo_tipo_1,
                      .mercado_tramo_tipo_2,
                      .mercado_tramo_tipo_3,
                      .mercado_tramo_tipo_4,
                      .mercado_tramo_tipo_5)


### cantidades ----
# porcentajes
.tipo_1_mercado = 0.15 #%
.tipo_2_mercado = 0.20 #%
.tipo_3_mercado = 0.25 #%
.tipo_4_mercado = 0.15 #%
.tipo_5_mercado = 0.25 #%

# total
sum(.tipo_1_mercado, .tipo_2_mercado, .tipo_3_mercado, .tipo_4_mercado, .tipo_5_mercado) == 100

# cantidades
cantidad_unidades_tipo_1 = max_unidades_vendibles * (.tipo_1_mercado)
cantidad_unidades_tipo_2 = max_unidades_vendibles * (.tipo_2_mercado)
cantidad_unidades_tipo_3 = max_unidades_vendibles * (.tipo_3_mercado)
cantidad_unidades_tipo_4 = max_unidades_vendibles * (.tipo_4_mercado)
cantidad_unidades_tipo_5 = max_unidades_vendibles * (.tipo_5_mercado)

cantidades_tipos <- c(cantidad_unidades_tipo_1,
                      cantidad_unidades_tipo_2,
                      cantidad_unidades_tipo_3,
                      cantidad_unidades_tipo_4,
                      cantidad_unidades_tipo_5)

total_cantidad_unidades = sum(cantidades_tipos)

# superficie por tipo (mt2)
superficie_tipo_1 = cantidad_unidades_tipo_1 * .tamaño_tipo_1
superficie_tipo_2 = cantidad_unidades_tipo_2 * .tamaño_tipo_2
superficie_tipo_3 = cantidad_unidades_tipo_3 * .tamaño_tipo_3
superficie_tipo_4 = cantidad_unidades_tipo_4 * .tamaño_tipo_4
superficie_tipo_5 = cantidad_unidades_tipo_5 * .tamaño_tipo_5

### precio ----
# precio del metro cuadrado por tipo
.precio_m2_tipo_1 = 50 #uf/m2
.precio_m2_tipo_2 = 50 #uf/m2
.precio_m2_tipo_3 = 50 #uf/m2
.precio_m2_tipo_4 = 50 #uf/m2
.precio_m2_tipo_5 = 50 #uf/m2

# precio de tipos en uf
precio_tipo_1 = .tamaño_tipo_1 * .precio_m2_tipo_1
precio_tipo_2 = .tamaño_tipo_2 * .precio_m2_tipo_2
precio_tipo_3 = .tamaño_tipo_3 * .precio_m2_tipo_3
precio_tipo_4 = .tamaño_tipo_4 * .precio_m2_tipo_4
precio_tipo_5 = .tamaño_tipo_5 * .precio_m2_tipo_5

ingreso_deptos = sum((cantidad_unidades_tipo_1 * precio_tipo_1),
                     (cantidad_unidades_tipo_2 * precio_tipo_2),
                     (cantidad_unidades_tipo_3 * precio_tipo_3),
                     (cantidad_unidades_tipo_4 * precio_tipo_4),
                     (cantidad_unidades_tipo_5 * precio_tipo_5)) #uf


### dotación estacionamientos ----


# dotación
.dotacion_estacionamiento_viv_menor_50m2 = 0.3 #un/viv
.dotacion_estacionamiento_viv_sobre_50m2_menor_100m2 = 0.5 #un/viv
.dotacion_estacionamiento_viv_social = 0 #un/viv
.dotacion_estacionamiento_rebaja = 0 #%

# total estacionamientos
.estacionamiento_subterraneo = 0.50 #%
.estacionamiento_exterior = 0.50 #%
.estacionamiento_visita = 0.15 #%

# para total_estacionamientos
total_estac_viv_menor_50m2 <- sum(ifelse(tamaños_tipos < 50, cantidades_tipos * dotacion_estacionamiento_viv_menor_50m2, 0))
total_estac_viv_sobre_50m2_menor_100m2 <- sum(ifelse(tamaños_tipos >= 50 & tamaños_tipos < 100, cantidades_tipos * dotacion_estacionamiento_viv_sobre_50m2_menor_100m2, 0))

# ifelse(mercado_o_tramos == "Tramo 1", tamaños_tipos, 0) parece que primero es esto y luego procede
total_estac_viv_social <- sum(ifelse(mercado_o_tramos == "Mercado", cantidades_tipos * .dotacion_estacionamiento_viv_social, 0))

total_estacionamientos <- sum(total_estac_viv_menor_50m2,
                              total_estac_viv_sobre_50m2_menor_100m2,
                              total_estac_viv_social)

total_estacionamientos_vendibles = sum(total_estac_viv_menor_50m2,
                                       total_estac_viv_sobre_50m2_menor_100m2)

# vendib_estacionamientos #un

### bodega ----
.bodega_dotacion = 1.0 #un/viv
# total bodegas
total_bodegas = .bodega_dotacion * total_cantidad_unidades #un

# superficie exterior 
# ((total_estacionamientos * .estacionamiento_visita) + (total_estacionamientos * .estacionamiento_exterior)) * 12.5 #m2

# superficie subterránea 
# ((total_estacionamientos * .estacionamiento_subterraneo) * 12.5) + (total_bodegas * 3) #m2

# precio bodega
.precio_estacionamiento_subterraneo = 250 #uf
.precio_estacionamiento_exterior = 150 #uf
.precio_bodega = 80 #uf

ingreso_bodega_estacionamiento = (.precio_estacionamiento_exterior*vendib*.estacionamiento_exterior) +
  (.precio_estacionamiento_subterraneo*vendib*.estacionamiento_subterraneo) +
  (.precio_bodega*total_bodegas)

total_ingreso = ingreso_deptos + ingreso_bodega_estacionamiento

## costos ----

### costos construccion ----
.costo_construccion_sobre_nt1 = 24 #uf/m2
.costo_construccion_sobre_nt2 = 18 #uf/m2
.costo_construccion_subterraneo = 14 #uf/m2
.costo_construccion_estacionamiento_exterior = 5.0 #uf/m2

# costo urbanizacion
.costo_urbanizacion_areaverde_exterior = 2.0 #uf/m2

### costos proyecto ----
# Arquitectura / Calculo / Otras Especialidades	2,0	%
.costo_proyecto_arquitectura = 2.0 #%
# Permisos / Empalmes / D° municipales 	2,5	%
.costo_proyecto_permisos = 2.5	#%

# gastos administrativos
.costo_proyecto_administrativo_comercialización = 2.5 #%
.costo_proyecto_administrativo_publicidad = 4.0 #%
.costo_proyecto_administrativo_administración = 3.5 #%

### subtotales ----
subtotal_terreno = .valor_suelo_uf * .sup_total_terreno #uf
# subtotal_directo #uf
# subtotal_indirecto #uf

costo_total = subtotal_terreno + subtotal_directo + subtotal_indirecto


## rentabilidad ----

### rentabilidad mercado ----

total_ganancia = total_ingreso - costo_total #uf

rentabilidad = total_ganancia / (costo_total*100)#%
