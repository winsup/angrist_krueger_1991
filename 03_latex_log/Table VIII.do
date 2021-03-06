clear
/* log using "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\02_logfile\Table_VIII.log", replace  */

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
*************************************
keep if COHORT>3000 & COHORT <3040 & RACE==1
*************************************
tabulate SOB, generate(state)

foreach j of numlist 1/3 {
foreach i of numlist 1/50 {
gen QTR`j'state`i'=QTR`j'*state`i'
}
}
**********  Start Regression ********
eststo clear

reg  LWKLYWGE EDUC  YR0-YR8 state1-state50
eststo model1

ivregress 2sls LWKLYWGE YR0-YR8 state1-state50 (EDUC = QTR1YR0-QTR1YR9 QTR2YR0-QTR2YR9 QTR3YR0-QTR3YR9 YR0-YR8 QTR1state1-QTR3state50)
eststo model2

reg  LWKLYWGE EDUC YR0-YR8 AGEQ AGEQSQ state1-state50
eststo model3

ivregress 2sls LWKLYWGE YR0-YR8 AGEQ AGEQSQ state1-state50 (EDUC = QTR1YR0-QTR1YR9 QTR2YR0-QTR2YR9 QTR3YR0-QTR3YR9 YR0-YR8 QTR1state1-QTR3state50)
eststo model4

reg  LWKLYWGE EDUC MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT YR0-YR8  state1-state50
eststo model5

ivregress 2sls LWKLYWGE YR0-YR8 MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT  state1-state50 (EDUC = QTR1YR0-QTR1YR9 QTR2YR0-QTR2YR9 QTR3YR0-QTR3YR9 YR0-YR8 QTR1state1-QTR3state50)
eststo model6

reg  LWKLYWGE EDUC MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT YR0-YR8 AGEQ AGEQSQ state1-state50
eststo model7

ivregress 2sls LWKLYWGE YR0-YR8 MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT AGEQ AGEQSQ state1-state50 (EDUC = QTR1YR0-QTR1YR9 QTR2YR0-QTR2YR9 QTR3YR0-QTR3YR9 YR0-YR8 QTR1state1-QTR3state50)
eststo model8

**********  Table Decoration ********

label variable EDUC   "Years of education"
label variable RACE   "Race(1 = black)"
label variable SMSA   "SMSA (1 = center city)"
label variable MARRIED   "Married (1 = married)"
label variable AGEQ   "Age"
label variable AGEQSQ   "Age-squared"

/* esttab using "C:\Users\Win\OneDrive - Chulalongkorn University\Chula\junior2\Microecono\reproduce_project\01_paper\tables\table8.tex", se varwidth(25) label keep(EDUC SMSA MARRIED AGEQ AGEQSQ) order(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) title("TABLE VIII") nonumbers mtitles("(1) OLS" "(2) TSLS" "(3) OLS" "(4) TSLS" "(5) OLS" "(6) TSLS" "(7) OLS" "(8) TSLS") */

/* log close */
