
forvalues i = 2005/2015 {  
 import excel C:\Users\rodrigo\Desktop\MSA_M`i'.xls, sheet("Hoja2") firstrow

 set more off

gen missing=0
replace missing=1 if TOT_EMP=="**"

replace TOT_EMP="." if missing==1
destring TOT_EMP, generate(empleos)
destring OCC_CODE, generate(codigo) ignore(-)

****Crear numerador de indice RZI (S_ij)

sort AREA
*Cantidad de empleos totales por area
by AREA: egen total_em= max(empleos)
*Industria con mayor cantidad de empleos por area
by AREA: gen S_ij= empleos/total_em if OCC_CODE!="00-0000"
*crear tasa de especializacion (ZI) 
by AREA: egen ZI`i'= max(S_ij)


****Crear denominador de RZI (S_j)

sort OCC_CODE
*numero total de empleos por industria
by OCC_CODE: egen total_industria2= sum(empleos)

sort AREA
egen emp_nacional= max(total_industria2) 
by AREA: gen S_j= total_industria2/emp_nacional 
by AREA: gen div_Sij_Si= S_ij/S_j 
by AREA: egen RZI`i'= max(div_Sij_Si)


*****************************************************************
*Entrega codigo de industria con max participacion

by AREA: gen max_occ=codigo if RZI==div_Sij_Si
by AREA: gen uno_=1 if max_occ==.
by AREA: replace max_occ=0 if uno_==1
by AREA: egen codigo_max`i'=max(max_occ) 
duplicates drop AREA, force
keep AREA AREA_NAME ZI`i' codigo_max`i' RZI`i'

save C:\Users\rodrigo\Desktop\RZI\RZI_`i'.dta
clear
}
