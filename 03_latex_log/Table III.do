clear
/* log using "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\02_logfile\Table_III.log", replace  */

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


**********  Panel A ********
sum LWKLYWGE if QTR1==1 & COHORT==2029 // 1
sum LWKLYWGE if QTR1!=1 & COHORT==2029 // 2
sum EDUC if QTR1==1 & COHORT==2029 // 4
sum EDUC if QTR1!=1 & COHORT==2029 // 5

reg LWKLYWGE QTR1 if COHORT==2029 // 3
reg EDUC QTR1 if COHORT==2029 // 6

sureg (eq1:  LWKLYWGE QTR1 ) (eq2:  EDUC QTR1 ) if COHORT==2029
nlcom ratio: [eq1]_b[QTR1]/[eq2]_b[QTR1] // 7

reg LWKLYWGE EDUC if  COHORT==2029 // 8

**********  Panel B ********
sum LWKLYWGE if QTR1==1 & COHORT==3039 // 9
sum LWKLYWGE if QTR1!=1 & COHORT==3039 // 10
sum EDUC if QTR1==1 & COHORT==3039 //12
sum EDUC if QTR1!=1 & COHORT==3039 // 13

reg LWKLYWGE QTR1 if COHORT==3039 // 11
reg EDUC QTR1 if COHORT==3039 // 14

sureg (eq1:  LWKLYWGE QTR1 ) (eq2:  EDUC QTR1 ) if COHORT==3039
nlcom ratio: [eq1]_b[QTR1]/[eq2]_b[QTR1] // 15

reg LWKLYWGE EDUC if  COHORT==3039 // 16

/* log close */
