source("datos.R")


# normativa compensación ----

#### (opcion) ####
.compensacion_densidad = 1 # caso merc1, int1
# .compensacion_densidad = 1.42 # caso int2

.compensacion_construccion = 1 # caso evmerc1, int1
# .compensacion_construccion = 1.40 # caso int2
####

# ev-merc ----

## cabida ----

# superficie terreno
# total
.sup_total_terreno 

# neta
superficie_neta = .sup_total_terreno - .faja_up_expropiacion

# norma aplicada
.normativa_densidad = 1500 # hab/ha
normativa_densidad = .normativa_densidad * .compensacion_densidad

.normativa_construccion = 3.2
normativa_construccion = .normativa_construccion * .compensacion_construccion


.unidad_normativa = "hab/ha" # viv/ha

# superficie neta p/desarrollo
superficie_max_util_const = superficie_neta * normativa_construccion

.superficie_area_comun = 0.15 # 15%
area_comun_mt2 = superficie_max_util_const * .superficie_area_comun # mt2

# máximos vendibles
max_unidades_vendibles = (.sup_total_terreno + .faja_exterior_eje_ep)/10000 * ifelse(.unidad_normativa == "hab/ha", (normativa_densidad/4), normativa_densidad)
max_superficie_vendible = superficie_max_util_const * (100-(.superficie_area_comun*100))/100 #mt2


## ingresos ----

### tamaños ----

#### (opcion) ####
tamaños_tipos <- c(38, 45, 52, 55, 62) # m2
####

### tipologías ----

#### (opcion) ####
mercado_o_tramos <- c("Mercado", "Mercado", "Mercado", "Mercado", "Mercado")
mercado_o_tramos <- c("Mercado", "Tramo 3", "Tramo 1", "Tramo 2", "Mercado") # caso int1
####

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

#### (opcion) ####
precios_m2_tipos = c(50, 50, 50, 50, 50)
precios_m2_tipos = c(50, 50, 27, 31, 50) # caso int1
####

# precio de tipos en uf
precios_tipos = tamaños_tipos * precios_m2_tipos

ingreso_deptos = sum(cantidades_tipos * precios_tipos)
# ok en ev-int1

### estacionamientos ----
# dotación
.dotacion_est_viv_menor_50m2 = 0.33 #un/viv
.dotacion_est_viv_sobre_50m2_menor_100m2 = 0.5 #un/viv

.dotacion_est_rebaja = 0 # %

#### (opcion) ####
.dotacion_est_viv_social = 0
.dotacion_est_viv_social = 1 #un/viv # caso int1
####

# total estacionamientos
.estacionamiento_subterraneo = 0.50 # %
.estacionamiento_exterior = 0.50 # %
.estacionamiento_visita = 0.15 # %

# para total_estacionamientos
# (SUMAR.SI(E15:E19;"<50";J15:J19)*E23)
estac_viv_menor_50m2 <- ifelse(tamaños_tipos < 50, cantidades_tipos * .dotacion_est_viv_menor_50m2, 0)
total_estac_viv_menor_50m2 <- sum(estac_viv_menor_50m2) |> round()

# ((SUMAR.SI.CONJUNTO(J15:J19;E15:E19;">=50";E15:E19;"<100") - (BUSCARV("Tramo 1";G15:J19;4)))
estac_viv_sobre_50m2_menor_100m2 <- ifelse(
  mercado_o_tramos != "Tramo 1" &
    tamaños_tipos >= 50 & 
    tamaños_tipos < 100, 
  cantidades_tipos * .dotacion_est_viv_sobre_50m2_menor_100m2, 0)
total_estac_viv_sobre_50m2_menor_100m2 <- sum(estac_viv_sobre_50m2_menor_100m2)
# ok en ev-merc, ok en ev-int1

estac_viv_social <- ifelse(mercado_o_tramos == "Tramo 1", cantidades_tipos * .dotacion_est_viv_social, 0)
total_estac_viv_social <- sum(estac_viv_social)
# ok en ev-merc, ok en ev-int1

total_estacionamientos <- sum(total_estac_viv_menor_50m2,
                              total_estac_viv_sobre_50m2_menor_100m2,
                              total_estac_viv_social) |> 
  round()
# ok en merc, int1

total_estacionamientos_vendibles = sum(total_estac_viv_menor_50m2,
                                       total_estac_viv_sobre_50m2_menor_100m2) |> 
  round()
# ok en merc, int1

### bodega ----
.bodega_dotacion = 1.0 # un/viv

total_bodegas = .bodega_dotacion * total_cantidad_unidades # un
# ok en ev-int1

superficie_exterior = ((total_estacionamientos * .estacionamiento_visita) + (total_estacionamientos * .estacionamiento_exterior)) * 12.5 # m2
superficie_subterranea = ((total_estacionamientos * .estacionamiento_subterraneo) * 12.5) + (total_bodegas * 3) # m2
# ok en ev-int1

# precio bodega
.precio_estacionamiento_subterraneo = 250 # uf
.precio_estacionamiento_exterior = 150 # uf
.precio_bodega = 80 # uf

ingreso_bodega_estacionamiento = 
  (.precio_estacionamiento_exterior * total_estacionamientos_vendibles * .estacionamiento_exterior) +
  (.precio_estacionamiento_subterraneo * total_estacionamientos_vendibles * .estacionamiento_subterraneo) +
  (.precio_bodega * total_bodegas) # uf 
# ok en ev-int1

total_ingreso = ingreso_deptos + ingreso_bodega_estacionamiento # uf 
# ok en ev-int1


## costos ----

### costos construccion ----
.costo_construccion_sobre_nt1 = 24 # uf/m2
.costo_construccion_sobre_nt2 = 18 # uf/m2
.costo_construccion_subterraneo = 14 # uf/m2
.costo_construccion_estacionamiento_exterior = 5.0 # uf/m2

# costo urbanizacion
.costo_urbanizacion_areaverde_exterior = 2.0 # uf/m2

### costos proyecto ----
.costo_proyecto_arquitectura = 0.020 # %
.costo_proyecto_permisos = 0.025	# %

# gastos administrativos
.costo_proyecto_administrativo_comercialización = 0.025 # %
.costo_proyecto_administrativo_publicidad = 0.040 # %
.costo_proyecto_administrativo_administración = 0.035 # %

### subtotales ----
subtotal_terreno = .valor_suelo_uf * .sup_total_terreno # uf
# ok en ev-int1

suma_superficies_totales = sum(superficies_tipos)
suma_superficies_mercado <- sum(ifelse(mercado_o_tramos %in% c("Mercado", "Tramo 3"), superficies_tipos, 0))
suma_superficies_tramo_2 <- sum(ifelse(mercado_o_tramos %in% c("Tramo 1", "Tramo 2"), superficies_tipos, 0))

total_costo_construccion_sobre_nt1 = (.costo_construccion_sobre_nt1 *  suma_superficies_mercado / (1 -.superficie_area_comun))
total_costo_construccion_sobre_nt2 = (.costo_construccion_sobre_nt2 *  suma_superficies_tramo_2 / (1 -.superficie_area_comun))

total_costo_construccion_subterraneo = (.costo_construccion_subterraneo * superficie_subterranea)
total_costo_construccion_estacionamiento_exterior = (.costo_construccion_estacionamiento_exterior * superficie_exterior)
total_costo_urbanizacion_areaverde_exterior = (.costo_urbanizacion_areaverde_exterior * superficie_neta) 

# costo directo
subtotal_directo = sum(total_costo_construccion_sobre_nt1,
                       total_costo_construccion_sobre_nt2,
                       total_costo_construccion_subterraneo,
                       total_costo_construccion_estacionamiento_exterior,
                       total_costo_urbanizacion_areaverde_exterior)
# ok en merc1, parecido en int1

# costo indirecto  
costo_proyecto = (.costo_proyecto_arquitectura + .costo_proyecto_permisos) * subtotal_directo
gastos_administrativos = total_ingreso * sum(.costo_proyecto_administrativo_comercialización, .costo_proyecto_administrativo_publicidad, .costo_proyecto_administrativo_administración)
subtotal_indirecto = costo_proyecto + gastos_administrativos # uf


# costo total
costo_total = sum(subtotal_terreno, # ok int1
                  subtotal_directo, # ok en int1
                  subtotal_indirecto # mayor en int1
                  ) # uf


## rentabilidad ----
total_ingreso
costo_total # mayor en int1

### rentabilidad mercado ----
total_ganancia = total_ingreso - costo_total # uf

rentabilidad = total_ganancia / costo_total # %

# resultados
{
  message("ingreso deptos: ", scales::comma(ingreso_deptos)) # ok merc, int1
  message("ingreso bodega y est: ", scales::comma(ingreso_bodega_estacionamiento)) # ok int1
  message("total ingresos: ", scales::comma(total_ingreso)) # ok merc, int1
  message("total ganancia: ", scales::comma(total_ganancia)) # ok merc, menor en int1
  message("total costos: ", scales::comma(costo_total)) # ok merc
  
  message("rentabilidad: ", scales::percent(rentabilidad, 0.01)) # ok merc
}
