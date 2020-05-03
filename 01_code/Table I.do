clear
log using "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\02_logfile\Table_I.log", replace 

use "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\raw_data.dta"
rename v1 AGE
rename v2 AGEQ
rename v4 EDUC
rename v5 ENOCENT
rename v6 ESOCENT
rename v9 LWKLYWGE
rename v10 MARRIED
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v16 CENSUS
rename v18 QOB
rename v19 RACE
rename v20 SMSA
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
rename v27 YOB

**********  YOB dummies **********
replace YOB=YOB-1900 if YOB >=1900

foreach i of numlist 0/9 {
	gen YR`i'=0
	replace YR`i'=1 if YOB==20+`i' | YOB==30+`i' | YOB==40+`i' 
}
**********  QOB dummies ***********
foreach i of numlist 1/4 {
	gen QTR`i'=0
	replace QTR`i'=1 if QOB==`i'
}
**********  QOB*YOB dummies  1/4 Not same as 4-8 ********
foreach k of numlist 1/4 {
foreach j in 00 25 50 75 {
	if `k'-1==`j'/25{
	foreach i of numlist 0/9 {
		gen YQ`i'`j'=QTR`k'*YR`i'
	}
	}
}
}
**********  Gen Other Variables ********
gen COHORT=2029
replace COHORT=3039 if YOB<=39 & YOB >=30
replace COHORT=4049 if YOB<=49 & YOB >=40
replace AGEQ=AGEQ-1900 if CENSUS==80
gen AGEQSQ= AGEQ*AGEQ

**********  Gen Table 1 helper Variables ********
// drop YQ
gen YQ=0
foreach j of numlist 1/4 {
foreach i of numlist 20/49 {
replace YQ=100*(`i')+25*(`j'-1) if (YOB==`i' & QOB ==`j')
}
}
**************************************************
**********  Start Total years of Education ********

foreach j of varlist YQ* {
		sum EDUC if (COHORT>3000 & COHORT <3040 & `j'==1)
		scalar mean_3039_`j' = r(mean)
}	
foreach j of varlist YQ* {
		sum EDUC if (COHORT>4000 & `j'==1)
		scalar mean_4049_`j' = r(mean)
}
**********  30-39 **********
drop MA
gen MA=0
replace MA = (mean_3039_YQ000+mean_3039_YQ025+mean_3039_YQ075+mean_3039_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ025+mean_3039_YQ050+mean_3039_YQ100+mean_3039_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ050+mean_3039_YQ075+mean_3039_YQ125+mean_3039_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ075+mean_3039_YQ100+mean_3039_YQ150+mean_3039_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=30 & YQ/100<=39.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_3039_YQ`pm2'+mean_3039_YQ`pm1'+mean_3039_YQ`pn1'+mean_3039_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=30 & YQ/100<=39.75)
}
replace MA = (mean_3039_YQ900+mean_3039_YQ925+mean_3039_YQ975+mean_4049_YQ000)/4 if (mod(YQ,1000)==950 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ925+mean_3039_YQ950+mean_4049_YQ000+mean_4049_YQ025)/4 if (mod(YQ,1000)==975 & YQ/100>=30 & YQ/100<=39.75)

**********  40-49 **********
// drop MA
replace MA = (mean_4049_YQ000+mean_4049_YQ025+mean_4049_YQ075+mean_4049_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ025+mean_4049_YQ050+mean_4049_YQ100+mean_4049_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ050+mean_4049_YQ075+mean_4049_YQ125+mean_4049_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ075+mean_4049_YQ100+mean_4049_YQ150+mean_4049_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=40 & YQ/100<=49.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_4049_YQ`pm2'+mean_4049_YQ`pm1'+mean_4049_YQ`pn1'+mean_4049_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=40 & YQ/100<=49.75)
}
replace MA = (mean_3039_YQ950+mean_3039_YQ975+mean_4049_YQ025+mean_4049_YQ050)/4 if (mod(YQ,1000)==0 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_3039_YQ975+mean_4049_YQ000+mean_4049_YQ050+mean_4049_YQ175)/4 if (mod(YQ,1000)==25 & YQ/100>=40 & YQ/100<=49.75)

**********  Regression Year EDUC **********
gen EDUC_s = EDUC-MA

**********  Total years of Education **********
sum EDUC if (YQ>=3050 & YQ<=3975)
sum EDUC if (YQ>=4000 & YQ<=4925)
eststo clear
reg EDUC_s QTR1-QTR3  if (COHORT>3000 & COHORT <3040 & MA !=0)
eststo model1
reg EDUC_s QTR1-QTR3  if (COHORT>4000 & MA !=0)
eststo model2




**************************************************
**********  Regression Year High School **********
gen hs_grad=0
replace hs_grad=1 if EDUC>=12
sum hs_grad if (YQ>=3050 & YQ<=3975)
sum hs_grad if (YQ>=4000 & YQ<=4925)

sum EDUC if (YQ>=3050 & YQ<=3975 & hs_grad==1)
sum EDUC if (YQ>=4000 & YQ<=4925 & hs_grad==1)

**********  Years of educ. for high school graduates **********
reg EDUC_s QTR1-QTR3  if (COHORT>3000 & COHORT <3040 & MA !=0 & hs_grad==1)
eststo model3
reg EDUC_s QTR1-QTR3  if (COHORT>4000 & MA !=0 & hs_grad==1)
eststo model4

foreach j of varlist YQ* {
		sum hs_grad if (COHORT>3000 & COHORT <3040 & `j'==1)
		scalar mean_3039_`j' = r(mean)
}	
foreach j of varlist YQ* {
		sum hs_grad if (COHORT>4000 & `j'==1)
		scalar mean_4049_`j' = r(mean)
}
**********  30-39 **********
drop MA
gen MA=0
replace MA = (mean_3039_YQ000+mean_3039_YQ025+mean_3039_YQ075+mean_3039_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ025+mean_3039_YQ050+mean_3039_YQ100+mean_3039_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ050+mean_3039_YQ075+mean_3039_YQ125+mean_3039_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ075+mean_3039_YQ100+mean_3039_YQ150+mean_3039_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=30 & YQ/100<=39.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_3039_YQ`pm2'+mean_3039_YQ`pm1'+mean_3039_YQ`pn1'+mean_3039_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=30 & YQ/100<=39.75)
}
replace MA = (mean_3039_YQ900+mean_3039_YQ925+mean_3039_YQ975+mean_4049_YQ000)/4 if (mod(YQ,1000)==950 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ925+mean_3039_YQ950+mean_4049_YQ000+mean_4049_YQ025)/4 if (mod(YQ,1000)==975 & YQ/100>=30 & YQ/100<=39.75)

**********  40-49 **********
// drop MA
replace MA = (mean_4049_YQ000+mean_4049_YQ025+mean_4049_YQ075+mean_4049_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ025+mean_4049_YQ050+mean_4049_YQ100+mean_4049_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ050+mean_4049_YQ075+mean_4049_YQ125+mean_4049_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ075+mean_4049_YQ100+mean_4049_YQ150+mean_4049_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=40 & YQ/100<=49.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_4049_YQ`pm2'+mean_4049_YQ`pm1'+mean_4049_YQ`pn1'+mean_4049_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=40 & YQ/100<=49.75)
}
replace MA = (mean_3039_YQ950+mean_3039_YQ975+mean_4049_YQ025+mean_4049_YQ050)/4 if (mod(YQ,1000)==0 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_3039_YQ975+mean_4049_YQ000+mean_4049_YQ050+mean_4049_YQ175)/4 if (mod(YQ,1000)==25 & YQ/100>=40 & YQ/100<=49.75)

**********  Regression**********
gen hs_grad_s = hs_grad-MA


sum EDUC if (YQ>=3050 & YQ<=3975)
sum EDUC if (YQ>=4000 & YQ<=4925)

reg hs_grad_s QTR1-QTR3  if (COHORT>3000 & COHORT <3040 & MA !=0)
eststo model5
reg hs_grad_s QTR1-QTR3  if (COHORT>4000 & MA !=0)
eststo model6

**************************************************
**********  Regression Year Bachelor **********
// drop bach_grad
gen bach_grad=0
replace bach_grad=1 if EDUC>=16
sum bach_grad if (YQ>=3050 & YQ<=3975)
sum bach_grad if (YQ>=4000 & YQ<=4925)

sum EDUC if (YQ>=3050 & YQ<=3975 & bach_grad==1)
sum EDUC if (YQ>=4000 & YQ<=4925 & bach_grad==1)


foreach j of varlist YQ* {
		sum bach_grad if (COHORT>3000 & COHORT <3040 & `j'==1)
		scalar mean_3039_`j' = r(mean)
}	
foreach j of varlist YQ* {
		sum bach_grad if (COHORT>4000 & `j'==1)
		scalar mean_4049_`j' = r(mean)
}
**********  30-39 **********
drop MA
gen MA=0
replace MA = (mean_3039_YQ000+mean_3039_YQ025+mean_3039_YQ075+mean_3039_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ025+mean_3039_YQ050+mean_3039_YQ100+mean_3039_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ050+mean_3039_YQ075+mean_3039_YQ125+mean_3039_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ075+mean_3039_YQ100+mean_3039_YQ150+mean_3039_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=30 & YQ/100<=39.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_3039_YQ`pm2'+mean_3039_YQ`pm1'+mean_3039_YQ`pn1'+mean_3039_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=30 & YQ/100<=39.75)
}
replace MA = (mean_3039_YQ900+mean_3039_YQ925+mean_3039_YQ975+mean_4049_YQ000)/4 if (mod(YQ,1000)==950 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ925+mean_3039_YQ950+mean_4049_YQ000+mean_4049_YQ025)/4 if (mod(YQ,1000)==975 & YQ/100>=30 & YQ/100<=39.75)

**********  40-49 **********
// drop MA
replace MA = (mean_4049_YQ000+mean_4049_YQ025+mean_4049_YQ075+mean_4049_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ025+mean_4049_YQ050+mean_4049_YQ100+mean_4049_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ050+mean_4049_YQ075+mean_4049_YQ125+mean_4049_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ075+mean_4049_YQ100+mean_4049_YQ150+mean_4049_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=40 & YQ/100<=49.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_4049_YQ`pm2'+mean_4049_YQ`pm1'+mean_4049_YQ`pn1'+mean_4049_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=40 & YQ/100<=49.75)
}
replace MA = (mean_3039_YQ950+mean_3039_YQ975+mean_4049_YQ025+mean_4049_YQ050)/4 if (mod(YQ,1000)==0 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_3039_YQ975+mean_4049_YQ000+mean_4049_YQ050+mean_4049_YQ175)/4 if (mod(YQ,1000)==25 & YQ/100>=40 & YQ/100<=49.75)

**********  Regression **********
// drop EDUC_s
gen bach_grad_s = bach_grad-MA


sum EDUC if (YQ>=3050 & YQ<=3975)
sum EDUC if (YQ>=4000 & YQ<=4925)

reg bach_grad_s QTR1-QTR3  if (COHORT>3000 & COHORT <3040 & MA !=0)
eststo model7
reg bach_grad_s QTR1-QTR3  if (COHORT>4000 & MA !=0)
eststo model8



**************************************************
**********  Regression Year Master **********
// drop bach_grad
gen ms_grad=0
replace ms_grad=1 if EDUC>=18
sum ms_grad if (YQ>=3050 & YQ<=3975)
sum ms_grad if (YQ>=4000 & YQ<=4925)


sum EDUC if (YQ>=3050 & YQ<=3975 & ms_grad==1)
sum EDUC if (YQ>=4000 & YQ<=4925 & ms_grad==1)


foreach j of varlist YQ* {
		sum ms_grad if (COHORT>3000 & COHORT <3040 & `j'==1)
		scalar mean_3039_`j' = r(mean)
}	
foreach j of varlist YQ* {
		sum ms_grad if (COHORT>4000 & `j'==1)
		scalar mean_4049_`j' = r(mean)
}
**********  30-39 **********
drop MA
gen MA=0
replace MA = (mean_3039_YQ000+mean_3039_YQ025+mean_3039_YQ075+mean_3039_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ025+mean_3039_YQ050+mean_3039_YQ100+mean_3039_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ050+mean_3039_YQ075+mean_3039_YQ125+mean_3039_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ075+mean_3039_YQ100+mean_3039_YQ150+mean_3039_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=30 & YQ/100<=39.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_3039_YQ`pm2'+mean_3039_YQ`pm1'+mean_3039_YQ`pn1'+mean_3039_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=30 & YQ/100<=39.75)
}
replace MA = (mean_3039_YQ900+mean_3039_YQ925+mean_3039_YQ975+mean_4049_YQ000)/4 if (mod(YQ,1000)==950 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ925+mean_3039_YQ950+mean_4049_YQ000+mean_4049_YQ025)/4 if (mod(YQ,1000)==975 & YQ/100>=30 & YQ/100<=39.75)

**********  40-49 **********
// drop MA
replace MA = (mean_4049_YQ000+mean_4049_YQ025+mean_4049_YQ075+mean_4049_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ025+mean_4049_YQ050+mean_4049_YQ100+mean_4049_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ050+mean_4049_YQ075+mean_4049_YQ125+mean_4049_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ075+mean_4049_YQ100+mean_4049_YQ150+mean_4049_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=40 & YQ/100<=49.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_4049_YQ`pm2'+mean_4049_YQ`pm1'+mean_4049_YQ`pn1'+mean_4049_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=40 & YQ/100<=49.75)
}
replace MA = (mean_3039_YQ950+mean_3039_YQ975+mean_4049_YQ025+mean_4049_YQ050)/4 if (mod(YQ,1000)==0 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_3039_YQ975+mean_4049_YQ000+mean_4049_YQ050+mean_4049_YQ175)/4 if (mod(YQ,1000)==25 & YQ/100>=40 & YQ/100<=49.75)

**********  Regression **********
// drop EDUC_s
gen ms_grad_s = ms_grad-MA

sum EDUC if (YQ>=3050 & YQ<=3975)
sum EDUC if (YQ>=4000 & YQ<=4925)

reg ms_grad_s QTR1-QTR3  if (COHORT>3000 & COHORT <3040 & MA !=0)
eststo model9
reg ms_grad_s QTR1-QTR3  if (COHORT>4000 & MA !=0)
eststo model10





**************************************************
**********  Regression Year Doctoral **********
// drop bach_grad
gen doc_grad=0
replace doc_grad=1 if EDUC>=20
sum doc_grad if (YQ>=3050 & YQ<=3975)
sum doc_grad if (YQ>=4000 & YQ<=4925)

sum EDUC if (YQ>=3050 & YQ<=3975 & doc_grad==1)
sum EDUC if (YQ>=4000 & YQ<=4925 & doc_grad==1)


foreach j of varlist YQ* {
		sum doc_grad if (COHORT>3000 & COHORT <3040 & `j'==1)
		scalar mean_3039_`j' = r(mean)
}	
foreach j of varlist YQ* {
		sum doc_grad if (COHORT>4000 & `j'==1)
		scalar mean_4049_`j' = r(mean)
}
**********  30-39 **********
drop MA
gen MA=0
replace MA = (mean_3039_YQ000+mean_3039_YQ025+mean_3039_YQ075+mean_3039_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ025+mean_3039_YQ050+mean_3039_YQ100+mean_3039_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ050+mean_3039_YQ075+mean_3039_YQ125+mean_3039_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ075+mean_3039_YQ100+mean_3039_YQ150+mean_3039_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=30 & YQ/100<=39.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_3039_YQ`pm2'+mean_3039_YQ`pm1'+mean_3039_YQ`pn1'+mean_3039_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=30 & YQ/100<=39.75)
}
replace MA = (mean_3039_YQ900+mean_3039_YQ925+mean_3039_YQ975+mean_4049_YQ000)/4 if (mod(YQ,1000)==950 & YQ/100>=30 & YQ/100<=39.75)
replace MA = (mean_3039_YQ925+mean_3039_YQ950+mean_4049_YQ000+mean_4049_YQ025)/4 if (mod(YQ,1000)==975 & YQ/100>=30 & YQ/100<=39.75)

**********  40-49 **********
// drop MA
replace MA = (mean_4049_YQ000+mean_4049_YQ025+mean_4049_YQ075+mean_4049_YQ100)/4 if (mod(YQ,1000)==50 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ025+mean_4049_YQ050+mean_4049_YQ100+mean_4049_YQ125)/4 if (mod(YQ,1000)==75 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ050+mean_4049_YQ075+mean_4049_YQ125+mean_4049_YQ150)/4 if (mod(YQ,1000)==100 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_4049_YQ075+mean_4049_YQ100+mean_4049_YQ150+mean_4049_YQ175)/4 if (mod(YQ,1000)==125 & YQ/100>=40 & YQ/100<=49.75)

foreach j of numlist 6/37{
	// 150->6 925-> 37
	local pm2 = 25*(`j'-2)
	local pm1 = 25*(`j'-1)
	local p0 = 25*(`j')
	local pn1 = 25*(`j'+1)
	local pn2 = 25*(`j'+2)

	replace MA = (mean_4049_YQ`pm2'+mean_4049_YQ`pm1'+mean_4049_YQ`pn1'+mean_4049_YQ`pn2')/4 if (mod(YQ,1000)==`p0' & YQ/100>=40 & YQ/100<=49.75)
}
replace MA = (mean_3039_YQ950+mean_3039_YQ975+mean_4049_YQ025+mean_4049_YQ050)/4 if (mod(YQ,1000)==0 & YQ/100>=40 & YQ/100<=49.75)
replace MA = (mean_3039_YQ975+mean_4049_YQ000+mean_4049_YQ050+mean_4049_YQ175)/4 if (mod(YQ,1000)==25 & YQ/100>=40 & YQ/100<=49.75)

**********  Regression **********
// drop EDUC_s
gen doc_grad_s = doc_grad-MA

sum EDUC if (YQ>=3050 & YQ<=3975)
sum EDUC if (YQ>=4000 & YQ<=4925)

reg doc_grad_s QTR1-QTR3  if (COHORT>3000 & COHORT <3040 & MA !=0)
eststo model11
reg doc_grad_s QTR1-QTR3  if (COHORT>4000 & MA !=0)
eststo model12

********** Table **********
esttab , se r2 drop(_cons) 

log close
