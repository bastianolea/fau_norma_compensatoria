
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
tamaños_tipos <- c(38, 45, 52, 55, 62) # m2

mercado_o_tramos <- c("Mercado", "Mercado", "Mercado", "Mercado", "Mercado")

### cantidades ----
# porcentajes
porcentaje_tipos <- c(0.15, 0.20, 0.25, 0.15, 0.25)

# total
sum(porcentaje_tipos) == 1

# cantidades
cantidades_tipos = max_unidades_vendibles * porcentaje_tipos

total_cantidad_unidades = sum(cantidades_tipos)

# superficie por tipo (mt2)
superficies_tipos = cantidades_tipos * tamaños_tipos

### precio ----
# precio del metro cuadrado por tipo
precios_m2_tipos = c(50, 50, 50, 50, 50)

# precio de tipos en uf
precios_tipos = tamaños_tipos * precios_m2_tipos

ingreso_deptos = sum(cantidades_tipos * precios_tipos)

### dotación estacionamientos ----
# dotación
.dotacion_est_viv_menor_50m2 = 0.3 #un/viv
.dotacion_est_viv_sobre_50m2_menor_100m2 = 0.5 #un/viv
.dotacion_est_viv_social = 0 #un/viv
.dotacion_est_rebaja = 0 #%

# total estacionamientos
.estacionamiento_subterraneo = 0.50 #%
.estacionamiento_exterior = 0.50 #%
.estacionamiento_visita = 0.15 #%

# para total_estacionamientos
total_estac_viv_menor_50m2 <- sum(ifelse(tamaños_tipos < 50, cantidades_tipos * .dotacion_est_viv_menor_50m2, 0))
total_estac_viv_sobre_50m2_menor_100m2 <- sum(ifelse(tamaños_tipos >= 50 & tamaños_tipos < 100, cantidades_tipos * .dotacion_est_viv_sobre_50m2_menor_100m2, 0))

# ifelse(mercado_o_tramos == "Tramo 1", tamaños_tipos, 0) parece que primero es esto y luego procede
total_estac_viv_social <- sum(ifelse(mercado_o_tramos == "Mercado", cantidades_tipos * .dotacion_est_viv_social, 0))

total_estacionamientos <- sum(total_estac_viv_menor_50m2,
                              total_estac_viv_sobre_50m2_menor_100m2,
                              total_estac_viv_social)

total_estacionamientos_vendibles = sum(total_estac_viv_menor_50m2,
                                       total_estac_viv_sobre_50m2_menor_100m2)
# (!) sale ligeramente distinto, 130 vs 126, debe ser por redondeos

### bodega ----
.bodega_dotacion = 1.0 # un/viv

total_bodegas = .bodega_dotacion * total_cantidad_unidades # un

superficie_exterior = ((total_estacionamientos * .estacionamiento_visita) + (total_estacionamientos * .estacionamiento_exterior)) * 12.5 # m2
superficie_subterranea = ((total_estacionamientos * .estacionamiento_subterraneo) * 12.5) + (total_bodegas * 3) # m2

# precio bodega
.precio_estacionamiento_subterraneo = 250 # uf
.precio_estacionamiento_exterior = 150 # uf
.precio_bodega = 80 # uf

ingreso_bodega_estacionamiento = 
  (.precio_estacionamiento_exterior * total_estacionamientos_vendibles * .estacionamiento_exterior) +
  (.precio_estacionamiento_subterraneo * total_estacionamientos_vendibles * .estacionamiento_subterraneo) +
  (.precio_bodega * total_bodegas) # uf 

total_ingreso = ingreso_deptos + ingreso_bodega_estacionamiento # uf 


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
.costo_proyecto_arquitectura = 0.020 #%
# Permisos / Empalmes / D° municipales 	2,5	%
.costo_proyecto_permisos = 0.025	#%

# gastos administrativos
.costo_proyecto_administrativo_comercialización = 0.025 #%
.costo_proyecto_administrativo_publicidad = 0.040 #%
.costo_proyecto_administrativo_administración = 0.035 #%

### subtotales ----
subtotal_terreno = .valor_suelo_uf * .sup_total_terreno #uf

suma_mercado <- sum(ifelse(mercado_o_tramos == "Mercado", superficies_tipos, 0))
suma_tramo_1 <- sum(ifelse(mercado_o_tramos == "Tramo 1", superficies_tipos, 0))

subtotal_directo = (.costo_construccion_sobre_nt1 * suma_mercado / ((100 - (.superficie_area_comun*100)) / 100)) +
  (.costo_construccion_sobre_nt2 * suma_tramo_1 / ((100 - (.superficie_area_comun*100)) / 100)) +
  (.costo_construccion_subterraneo * superficie_subterranea) +
  (.costo_construccion_estacionamiento_exterior * superficie_exterior) +
  (.costo_urbanizacion_areaverde_exterior * superficie_neta) # uf

subtotal_indirecto = total_ingreso * sum(.costo_proyecto_administrativo_comercialización,
                    .costo_proyecto_administrativo_publicidad,
                    .costo_proyecto_administrativo_administración) +
  ((.costo_proyecto_arquitectura + .costo_proyecto_permisos) * subtotal_directo) # uf

costo_total = subtotal_terreno + subtotal_directo + subtotal_indirecto


## rentabilidad ----

### rentabilidad mercado ----
total_ganancia = total_ingreso - costo_total #uf

rentabilidad = total_ganancia / (costo_total*100) # %

