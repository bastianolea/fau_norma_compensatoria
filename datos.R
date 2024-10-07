# pestaña datos ----

# SUP. TOTAL TERRENO
.sup_total_terreno = 7281	#m2

# Faja U.P. (expropiación)		
.faja_up_expropiacion = 1634	#m2
# Faja exterior a eje EP		
.faja_exterior_eje_ep = 565	#m2


# VALOR DE SUELO REF.		
.valor_suelo_uf = 14.5	#UF/m2



# PRECIOS MÁXIMOS INTEGRACIÓN			
# Tramo 1	
.precio_max_int_t1 = 1400	#UF
# Tramo 2	
.precio_max_int_t2 = 1700	#UF
# Tramo 3	
.precio_max_int_t3 = 2250	#UF

# CASTIGO POR INTEGRACIÓN	
# b_integracion		0,00891 #betas
.b_integracion = 0.00891
# b_descuento		0,02094
.b_descuento = 0.02094
# b_espaciopublico_integracion		-0,01580
.b_espaciopublico_integracion = -0.01580
# b_unidades_integracion		-0,00005
.b_unidades_integracion = -0.00005

# Calidad EP		
.calidad_ep = 3



# pestaña ev-merc ----

## cabida ----
dens = 1500 #hab/ha
const = 3.2

## superficie neta p/desarrollo ----
area_comun = 15 # 15%

## ingresos ----

### tipologías ----
tipo_1 = 38 #m2
tipo_2 = 45 #m2
tipo_3 = 52 #m2
tipo_4 = 55 #m2
tipo_5 = 62 #m2


### cantidades ----
tipo_1_mercado = 15 #%
tipo_2_mercado = 20 #%
tipo_3_mercado = 25 #%
tipo_4_mercado = 15 #%
tipo_5_mercado = 25 #%
# total

### precio ----
precio_tipo_1 = 50 #uf/m2
precio_tipo_2 = 50 #uf/m2
precio_tipo_3 = 50 #uf/m2
precio_tipo_4 = 50 #uf/m2
precio_tipo_5 = 50 #uf/m2

### estacionamientos ----

# dotación
dotacion_estacionamiento_viv_menor_50m2 = 0.3 #un/viv
dotacion_estacionamiento_viv_sobre_50m2_menor_100m2 = 0.5 #un/viv
dotacion_estacionamiento_viv_social = 0 #un/viv
dotacion_estacionamiento_rebaja = 0 #%

# total
estacionamiento_subterraneo = 50 #%
estacionamiento_exterior = 50 #%
estacionamiento_visita = 15 #%

# bodega
bodega_dotacion = 1.0 #un/viv

# precios
precio_estacionamiento_subterraneo = 250 #uf
precio_estacionamiento_exterior = 150 #uf
precio_bodega = 80 #uf

## costos ----

### costos construccion ----
costo_construccion_sobre_nt1 = 24 #uf/m2
costo_construccion_sobre_nt2 = 18 #uf/m2
costo_construccion_subterraneo = 14 #uf/m2
costo_construccion_estacionamiento_exterior = 5.0 #uf/m2

# costo urbanizacion
costo_urbanizacion_areaverde_exterior = 2.0 #uf/m2

### costos proyecto ----
# Arquitectura / Calculo / Otras Especialidades	2,0	%
costo_proyecto_arquitectura = 2.0 #%
# Permisos / Empalmes / D° municipales 	2,5	%
costo_proyecto_permisos = 2.5	#%

# gastos administrativos
costo_proyecto_administrativo_comercialización = 2.5 #%
costo_proyecto_administrativo_publicidad = 4.0 #%
costo_proyecto_administrativo_administración = 3.5 #%


