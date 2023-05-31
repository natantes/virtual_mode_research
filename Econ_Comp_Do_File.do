

esttab A B C using "table.tex", ///
drop(_cons) ///
coeflabels(Var1 "Var1_Name" Var2 "Var2_Name" ///
Var3 "Var3_Name") ///
refcat(VarN "\textbf{\emph{Controls}} ") /// 
booktabs fragment label replace ///
nonotes nomtitles  ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("Group 1" "Group 2" "Group 3", pattern(1 1 1 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
