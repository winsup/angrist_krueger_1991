clear
log using "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\02_logfile\Table_II.log", replace 

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
rename v17 SOB
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
**********  QOB*YOB dummies ********
foreach j of numlist 1/3 {
foreach i of numlist 0/9 {
gen QTR`j'YR`i'=QTR`j'*YR`i'
}
}
**********  Select Particular Men Born ********
gen COHORT=2029
replace COHORT=3039 if YOB<=39 & YOB >=30
replace COHORT=4049 if YOB<=49 & YOB >=40
replace AGEQ=AGEQ-1900 if CENSUS==80
gen AGEQSQ= AGEQ*AGEQ

********************
merge m:1 SOB using "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\appendix2_table.dta"

** First Column: 16
scalar yob_table2 = 44
// drop dt2

// drop dt2
gen dt2 = 0
replace dt2=1 if YOB==yob_table2 &at_age1960==16 & EDUC>=12
reg dt2 QTR1 if YOB==yob_table2  & at_age1960==16 // .857225   .0021789
reg dt2 QTR2 QTR3 QTR4 if YOB==yob_table2  & at_age1960==16 // .8489115   .0038272

** Second Column: 17 or 18

drop dt2
gen dt2 = 0
replace dt2=1 if YOB==yob_table2 &(at_age1960==17 | at_age1960==18) & EDUC>=12
reg dt2 QTR1 if YOB==yob_table2  &(at_age1960==17 | at_age1960==18) // .8599152   .0044417
reg dt2 QTR2 QTR3 QTR4 if YOB==yob_table2  &(at_age1960==17 | at_age1960==18) // .857213   .0077054 
log close



