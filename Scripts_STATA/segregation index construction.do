use ipumsdata.dta, clear
***Definicion de variables:

*I. Individuos con grado universitario
tostring educd, generate(degree)
gen univ_deg=0
replace univ_deg=1 if degree=="101" | degree=="115" | degree=="116" | degree=="114"
label variable univ_deg "Individuos con grado universitario"


****Crear individuo que es jefe de hogar y tiene grado universitario.
gen univ_jef=0
replace univ_jef=1 if univ_deg==1 & pernum==1
label variable univ_jef "Individuos jefe de hogar con grado universitario"


*******CALCULAR SEGREGACION**************
set more off

forvalue j = 2005/2006{

preserve
 drop if year!=`j'
 gen D`j'=0
 gen G`j'=0
 egen group= group(met2013)
 su group, meanonly
 
  foreach i of num 1/`r(max)'{
   dicseg puma univ_jef if group==`i'
    replace D`j'=r(D) if group==`i'
    replace G`j'=r(Gini) if group==`i'
	 }
 duplicates drop met2013, force
 sort met2013
 save C:\Users\rodrigo\Desktop\new_segpuma_`j'.dta
restore
       }
	   
	   
*DUNCAN POR MA´s PERIODO 2005-2015 para comparar resultados de "dicseg"********
sort met2013
forvalues i = 2005/2006{  
preserve 
    drop if year!=`i'
	by met2013: duncan2 puma univ_jef , missing d(duncan`i')
	save newduncan`i'
restore
}
