

/*

VARIABLE NAME DESCRIPTIONS:

TEST DATASET:
"schoolcode": School Identifier
"year": School Year
"elapass": Ela Test Pass Rate
"mathpass": Math Test Pass Rate
"schoolmode": Share of "virtual learning" using V computation
"virtualper": Percentage of virtual learning for the year
"hybridper": Percentage of hybrid learing for the year\
"white": percentage of white students enrolled
"black": Percentage of black students enrolled
"hispanic": Percentage of hispanic students enrolled
"asian": Percentage of asian students enrolled
"lowincome": Proporortion of low income students for given school
"totaltested": Total number of students tested (enrolled for dropout)
 for given school

DROPOUT DATASET:
"schoolcode": School Identifier
"year": School Year
"dropout": Dropout Rate
"schoolmode": Share of "virtual learning" using V computation
"virtualper": Percentage of virtual learning for the year
"hybridper": Percentage of hybrid learing for the year\
"white": percentage of white students enrolled
"black": Percentage of black students enrolled
"hispanic": Percentage of hispanic students enrolled
"asian": Percentage of asian students enrolled
"lowincome": Proporortion of low income students for given school

*/




// IMPORT ELA DATASET
insheet using "/Users/natan/Dev/econometrics_compeition/new_ela.csv", clear

// CREATE DESC TABLES
estpost sum elapass schoolmode white black hispanic disability classsize ///
lowincome totaltested
est store DESC1

// GENERATE TIME DUMMIES FOR TIME FIXED EFFECTS
g t18 = 1 if year == 2018
replace t18 = 0 if year != 2018
g t19 = 1 if year == 2019
replace t19 = 0 if year != 2019
g t21 = 1 if year == 2021
replace t21 = 0 if year != 2021

// CREATE INTERACTION VARIABLES
g H_int = hispanic * schoolmode
g B_int = black * schoolmode
g classize_int = classsize * schoolmode
g lowincome_int = schoolmode * lowincome

// REGRESSIONS FOR ELA PASS RATE
eststo ELA_BASE: areg elapass schoolmode white black hispanic asian disability /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

eststo ELA_DEMO_INT: areg elapass schoolmode H_int B_int  black hispanic asian ///
disability t18 t19 lowincome [aweight=totaltested] ///
, absorb(schoolcode) vce(cluster schoolcode)

eststo ELA_CLASS_INT: areg elapass schoolmode white black hispanic disability classize_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

eststo ELA_LOWINC_INT: areg elapass schoolmode white black hispanic disability lowincome_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)





// insheet using "/Users/natan/Dev/virtual_mode_research/new_math.csv", clear
insheet using "/Dev/virtual_mode_research/new_math.csv", clear

// CREATE DESC TABLES
estpost sum mathpass schoolmode white black hispanic disability classsize /// 
lowincome totaltested
est store DESC2

// GENERATE TIME DUMMIES FOR TIME FIXED EFFECTS
g t18 = 1 if year == 2018
replace t18 = 0 if year != 2018
g t19 = 1 if year == 2019
replace t19 = 0 if year != 2019
g t21 = 1 if year == 2021
replace t21 = 0 if year != 2021

g H_int = hispanic * schoolmode
g B_int = black * schoolmode
g classize_int = classsize * schoolmode
g lowincome_int = schoolmode * lowincome
g retention_int = schoolmode * retention


// REGRESSIONS FOR MATH PASS RATE
eststo MATH_BASE: areg mathpass schoolmode white black hispanic asian disability ///
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) ///
vce(cluster schoolcode)

eststo MATH_DEMO_INT: areg mathpass schoolmode white black hispanic asian disability  ///
t18 t19 H_int B_int lowincome  [aweight=totaltested] ///
, absorb(schoolcode) vce(cluster schoolcode)

eststo MATH_CLASS_INT: areg mathpass schoolmode white black hispanic disability classize_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

lincom classize_int + schoolmode

eststo MATH_LOWINC_INT: areg mathpass schoolmode white black hispanic disability lowincome_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)





// insheet using "/Users/natan/Dev/econometrics_compeition/new_drop.csv", clear
// insheet using "/Dev/econometrics_compeition/new_drop.csv", clear
// insheet using "C:/Dev/virtual_mode_research/ny_drop_data_192122.csv", clear
insheet using "C:/Dev/virtual_mode_research/final_drop.csv", clear

drop if year == 2018

// encode schoolcode, generate(finalschoolcode)

rename totalenroll totaltested
rename blackenroll black
rename whiteenroll white
rename hispanicenroll hispanic
rename lowincomeenroll lowincome

// estpost sum dropout schoolmode white black hispanic classsize lowincome ///
// totaltested retention attendance 
// est store DESC3

// generate time fixed effects
g t18 = 1 if year == 2018
replace t18 = 0 if year != 2018
g t19 = 1 if year == 2019
replace t19 = 0 if year != 2019
g t21 = 1 if year == 2021
replace t21 = 0 if year != 2021

g H_int = hispanic * schoolmode
g B_int = black * schoolmode
// g classize_int = classsize * schoolmode
g lowincome_int = schoolmode * lowincome
g virtual_per_int = virtual_per * lowincome
g hybrid_per_int = hybrid_per * lowincome
replace virtual_per = virtual_per * 100

// REGRESSIONS FOR MATH PASS RATE
eststo DROP_BIAS: reg dropout schoolmode t21, absorb(schoolcode)

eststo DROP_BASE: areg dropout schoolmode white black hispanic lowincome ///
t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_ALT: areg dropout virtual_per hybrid_per white black hispanic ///
lowincome t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_LOWINC_INT: areg dropout schoolmode white black hispanic lowincome /// 
low_income_int t21 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

eststo DROP_CLASS_INT: areg dropout schoolmode white black hispanic lowincome /// 
low_income_int t21 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

// eststo DROP_NORMAL: areg dropout virtual_per hybrid_per white black hispanic lowincome ///
// t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_LOWINC: areg dropout schoolmode white black hispanic lowincome_int lowincome ///
// t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

// drop if retention < 40
// g retention_int = schoolmode * retention
//
// eststo DROP_RET: areg dropout schoolmode white black hispanic  retention_int lowincome ///
// t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention ///
// t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention  ///
// t21 [aweight=totaltested] if schoolmode <= 0.75, absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention  ///
// t21 [aweight=totaltested] if schoolmode <= 0.50, absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention  ///
// t21 [aweight=totaltested] if schoolmode <= 0.25, absorb(schoolcode) vce(cluster schoolcode)
//
//
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
// t19 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
// t19 [aweight=totaltested] if schoolmode <= 0.75, absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
// t19 [aweight=totaltested] if schoolmode <= 0.50, absorb(schoolcode) vce(cluster schoolcode)
//
// eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
// t19 [aweight=totaltested] if schoolmode <= 0.25, absorb(schoolcode) vce(cluster schoolcode)




// insheet using "/Users/natan/Dev/econometrics_compeition/new_drop.csv", clear
//
// rename totalenroll totaltested
// rename blackenroll black
// rename whiteenroll white
// rename hispanicenroll hispanic
// rename lowincomeenroll lowincome
//
// estpost sum dropout schoolmode white black hispanic classsize lowincome ///
// totaltested retention attendance 
// est store DESC3
//
// // generate time fixed effects
// g t18 = 1 if year == 2018
// replace t18 = 0 if year != 2018
// g t19 = 1 if year == 2019
// replace t19 = 0 if year != 2019
// g t21 = 1 if year == 2021
// replace t21 = 0 if year != 2021
//
// g H_int = hispanic * schoolmode
// g B_int = black * schoolmode
// g classize_int = classsize * schoolmode



esttab DROP_NORMAL using "/Dev/virtual_mode_research/table12.tex", ///
drop(_cons white black hispanic t21) ///
coeflabels(virtual_per "Virtual" hybrid_per "Hybrid" ///
lowincome "Low Income"  ///
) ///
refcat(lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("DROP" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab A C E using "/Users/natan/Dev/econometrics_compeition/table1.tex", ///
drop(_cons white black asian hispanic disability t18 t19 attendance) ///
coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
retention "Retention" classsize_int "Class Size I" ) ///
refcat(lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab AA BA DROP_NORMAL AL BL DROP_LOWINC using "/Users/natan/Dev/econometrics_compeition/table2.tex", ///
drop(_cons white black hispanic disability t18 t19 attendance) ///
coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
retention "Retention" classize_int "Class Size I") ///
refcat(classize_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}" "\textbf{\emph{Dependent Variables W/ Low Income I}}", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab B D F using "/Users/natan/Dev/econometrics_compeition/table3.tex", ///
drop(_cons white black asian hispanic disability t18 t19 attendance) ///
coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
retention "Retention") ///
refcat(H_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))







