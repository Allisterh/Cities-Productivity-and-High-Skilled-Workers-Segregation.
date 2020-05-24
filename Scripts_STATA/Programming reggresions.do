************************************************************************************************************

*Tabla1
sum Duncan Gini if YEAR==2005
sum Duncan Gini if YEAR==2015
sum Duncan Gini 

*Tabla2
sum  prod density semp educ_ if YEAR==2005
sum  prod density semp educ_ if YEAR==2015
sum  prod density semp educ_

*Scatter 
graph twoway (scatter logprod logemp , msymbol(o)) (lfit logprod logemp ), title("Productivity vs Employees number")
graph twoway (scatter logprod educ_ , msymbol(o)) (lfit logprod educ_ ), title("Productivity vs Education rate")
graph twoway (scatter logprod logdensity , msymbol(o)) (lfit logprod logdensity ), title("Productivity vs Population density")
graph twoway (scatter logprod logpob , msymbol(o)) (lfit logprod logpob ), title("Productivity vs Population")

 

****Scatter Productividad vs pob condicionando en educ
graph twoway (scatter logprod logpob , msymbol(o)) (lfit logprod logpob ) if educ_<.275, title("Productivity vs Population")
graph twoway (scatter logprod logpob , msymbol(o)) (lfit logprod logpob) if educ_>.275, title("Productivity vs Population")

****Scatter Productividad vs seg
graph twoway (scatter logprod Gini , msymbol(o)) (lfit logprod Gini ), title("Productivity vs Gini")
graph twoway (scatter logprod Duncan , msymbol(o)) (lfit logprod Duncan), title("Productivity vs Duncan")

**Primera etapa
graph twoway (scatter Gini log_tri , msymbol(o)) (lfit Gini log_tri  ) , title("Gini vs TRI")
graph twoway (scatter Duncan log_tri , msymbol(o)) (lfit Duncan log_tri ) , title("Duncan vs TRI")



*(ii)Estimates
xtset AREA YEAR

//OLS. 
eststo clear   /

foreach x in Gini Duncan {              // Cada loop genera una columna
      
eststo: quietly reg logprod `x' logdensity semp educ_ , robust

eststo: quietly reg logprod `x' logdensity semp educ_ i.YEAR, robust

eststo: quietly reg logprod `x' logdensity semp educ_ i.statenum, robust

eststo: quietly reg logprod `x' logdensity semp educ_ i.YEAR i.statenum, robust
   
   
}
esttab using “resultados.tex”, replace f ///
cells(b(fmt(2) star) se(fmt(2)  par)) ///
label booktabs noobs nonotes nomtitle collabels(none) stats(r2 N, labels("R^2" "Observaciones"))  ///
mgroups(“Productividad” , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))



//IVREG2
eststo clear   

foreach x in Gini Duncan {              
 eststo: quietly ivreg2 logprod logdensity semp educ_ (`x'=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.YEAR (`x'=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.statenum (`x'=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.YEAR i.statenum (`x'=tri_), robust
}
esttab using “resultados2.tex”, replace f ///
cells(b(fmt(2) star) se(fmt(2)  par)) ///
label booktabs noobs nonotes nomtitle collabels(none) stats(r2 N, labels("R^2" "Observaciones"))  ///
mgroups(“Productividad” , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


********ESPECIALIZACIÓN***********
//gen prim=0
//replace prim=1 if codigo_max==470000 / 47-0000 => "Construction and Extraction Occupations"

//gen phd=0
//replace phd=1 if codigo_max==150000 / 15-0000 => "Computer and Mathematical Occupations"

********************COMPLEMENTARIEDAD Y PROD****************************
*eststo clear
///Reg captura efecto de complemt. para ciudades prim, phd y el resto.
*quietly reg logprod dcomplement comprim comphd , robust
*quietly reg logprod dcomplement comprim comphd i.YEAR , robust
///Reg captura efecto de complemt. para ciudades prim y phd.
*quietly reg logprod comprim comphd , robust
*quietly reg logprod comprim comphd  i.YEAR, robust
***********************************************************************

//IVREG2 PRIM
eststo clear   // clear any existing stored estimates

foreach x in Gini Duncan {             
eststo: quietly ivreg2 logprod logdensity semp educ_ (`x'_prim=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.YEAR (`x'_prim=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.statenum  (`x'_prim=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.YEAR i.statenum  (`x'_prim=tri_), robust
   
}
esttab using “resultados3.tex”, replace f ///
cells(b(fmt(2) star) se(fmt(2)  par)) ///
label booktabs noobs nonotes nomtitle collabels(none) stats(r2 N, labels("R^2" "Observaciones"))  ///
mgroups(“Productividad” , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

//IVREG2 PRIM + COST CONST
eststo clear   // clear any existing stored estimates

foreach x in Gini Duncan {             
eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas (`x'_prim=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas i.YEAR (`x'_prim=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas i.statenum  (`x'_prim=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas i.YEAR i.statenum  (`x'_prim=tri_), robust
   
}
esttab using “resultados_ivcost_prim.tex”, replace f ///
cells(b(fmt(2) star) se(fmt(2)  par)) ///
label booktabs noobs nonotes nomtitle collabels(none) stats(r2 N, labels("R^2" "Observaciones"))  ///
mgroups(“Productividad” , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


//IVREG2 PHD
eststo clear   /

foreach x in Gini Duncan {              // Cada loop genera una columna
  eststo: quietly ivreg2 logprod logdensity semp educ_ (`x'_phd=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.YEAR (`x'_phd=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.statenum  (`x'_phd=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ i.YEAR i.statenum  (`x'_phd=tri_), robust
}
esttab using “resultados4.tex”, replace f ///
cells(b(fmt(2) star) se(fmt(2)  par)) ///
label booktabs noobs nonotes nomtitle collabels(none) stats(r2 N, labels("R^2" "Observaciones"))  ///
mgroups(“Productividad” , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

//IVREG2 PHD controlando por costo en construcción
eststo clear   

foreach x in Gini Duncan {              // Cada loop genera una columna
  eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas (`x'_phd2=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas i.YEAR (`x'_phd2=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas i.statenum  (`x'_phd2=tri_), robust

eststo: quietly ivreg2 logprod logdensity semp educ_ cost_mas i.YEAR i.statenum  (`x'_phd2=tri_), robust
}
esttab using “resultados_ivcost_phd.tex”, replace f ///
cells(b(fmt(2) star) se(fmt(2)  par)) ///
label booktabs noobs nonotes nomtitle collabels(none) stats(r2 N, labels("R^2" "Observaciones"))  ///
mgroups(“Productividad” , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

//Para betas estandarzados utilizando ivreg2
qui ivreg2 logprod logdensity semp educ_  cost_mas i.YEAR i.statenum (Duncan_phd2=tri_) , robust
qui sum logprod if e(sample)
local betaSD `r(sd)' 

foreach var in Duncan logdensity semp educ_ {
qui sum `var' if e(sample)==1
di "`var'" _col(71) r(sd)/`betaSD'* _b[`var']
}
