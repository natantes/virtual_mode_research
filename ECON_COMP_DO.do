//
// insheet using "/Users/natan/Dev/econometrics_compeition/elascoremode.csv", clear
//
// replace schoolmode = 0 if year != 2021
// encode schoolname, generate(school)
// encode schoolcode, generate(finalschoolcode)
//
// generate year2021 = (year == 2021)
// generate year2019 = (year == 2019)
//
// xtset finalschoolcode year, yearly
//
// xtreg elapass schoolmode male lowincome black year2021 year2019 [pweights=totaltested], r fe



// use dataset
insheet using "/Users/natan/Dev/econometrics_compeition/elascoremode.csv", clear
replace schoolmode = 0 if year != 2021

// generate time fixed effects
g t18 = 1 if year == 2018
replace t18 = 0 if year != 2018
g t19 = 1 if year == 2019
replace t19 = 0 if year != 2019
g t21 = 1 if year == 2021
replace t21 = 0 if year != 2021

g H_int = hispanic * schoolmode
g B_int = black * schoolmode

// regress elapass against 
eststo A: areg elapass schoolmode white black hispanic asian disability /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

eststo B: areg elapass schoolmode black hispanic asian disability   ///
t18 t19 H_int B_int lowincome [aweight=totaltested] ///
, absorb(schoolcode) vce(cluster schoolcode)








insheet using "/Users/natan/Dev/econometrics_compeition/mathscoremode.csv", clear
replace schoolmode = 0 if year != 2021

// generate time fixed effects
g t18 = 1 if year == 2018
replace t18 = 0 if year != 2018
g t19 = 1 if year == 2019
replace t19 = 0 if year != 2019
g t21 = 1 if year == 2021
replace t21 = 0 if year != 2021

g H_int = hispanic * schoolmode
g B_int = black * schoolmode


// regress elapass against 
eststo C: areg mathpass schoolmode white black hispanic asian disability lowincome  ///
t18 t19 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

eststo D: areg mathpass schoolmode white black hispanic asian disability  ///
t18 t19 H_int B_int lowincome  [aweight=totaltested] ///
, absorb(schoolcode) vce(cluster schoolcode)






insheet using "/Users/natan/Dev/econometrics_compeition/new_ela.csv", clear

// DESC
estpost sum elapass schoolmode white black hispanic disability classsize lowincome ///
totaltested
est store DESC1

// generate time fixed effects
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

// regress elapass against 
eststo AA: areg elapass schoolmode white black hispanic disability classize_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

eststo AL: areg elapass schoolmode white black hispanic disability lowincome_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)





insheet using "/Users/natan/Dev/econometrics_compeition/new_math.csv", clear

estpost sum mathpass schoolmode white black hispanic disability classsize lowincome ///
totaltested
est store DESC2

// generate time fixed effects
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


// regress elapass against 
eststo BA: areg mathpass schoolmode white black hispanic disability classize_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)

lincom classize_int + schoolmode

eststo BL: areg mathpass schoolmode white black hispanic disability lowincome_int /// 
lowincome t18 t19 [aweight=totaltested], absorb(schoolcode) /// 
vce(cluster schoolcode)





// insheet using "/Users/natan/Dev/econometrics_compeition/new_drop.csv", clear
insheet using "/Dev/econometrics_compeition/new_drop.csv", clear

drop if year == 2018

encode schoolcode, generate(finalschoolcode)

rename totalenroll totaltested
rename blackenroll black
rename whiteenroll white
rename hispanicenroll hispanic
rename lowincomeenroll lowincome

estpost sum dropout schoolmode white black hispanic classsize lowincome ///
totaltested retention attendance 
est store DESC3

// generate time fixed effects
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

eststo DROP_NORMAL: reg dropout schoolmode

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome attendance ///
t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention attendance ///
t21 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention attendance ///
t21 [aweight=totaltested] if schoolmode <= 0.75, absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention attendance ///
t21 [aweight=totaltested] if schoolmode <= 0.50, absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome retention attendance ///
t21 [aweight=totaltested] if schoolmode <= 0.25, absorb(schoolcode) vce(cluster schoolcode)



eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
t19 [aweight=totaltested], absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
t19 [aweight=totaltested] if schoolmode <= 0.75, absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
t19 [aweight=totaltested] if schoolmode <= 0.50, absorb(schoolcode) vce(cluster schoolcode)

eststo DROP_NORMAL: areg dropout schoolmode white black hispanic lowincome_int lowincome retention attendance ///
t19 [aweight=totaltested] if schoolmode <= 0.25, absorb(schoolcode) vce(cluster schoolcode)




insheet using "/Users/natan/Dev/econometrics_compeition/new_drop.csv", clear

rename totalenroll totaltested
rename blackenroll black
rename whiteenroll white
rename hispanicenroll hispanic
rename lowincomeenroll lowincome

estpost sum dropout schoolmode white black hispanic classsize lowincome ///
totaltested retention attendance 
est store DESC3

// generate time fixed effects
g t18 = 1 if year == 2018
replace t18 = 0 if year != 2018
g t19 = 1 if year == 2019
replace t19 = 0 if year != 2019
g t21 = 1 if year == 2021
replace t21 = 0 if year != 2021

g H_int = hispanic * schoolmode
g B_int = black * schoolmode
g classize_int = classsize * schoolmode





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







