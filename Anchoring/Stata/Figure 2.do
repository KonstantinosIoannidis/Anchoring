gen agg = 0
replace agg = 1 if index>105 & index<210
replace agg = 2 if index>=210

label define aggs 0 "Small" 1 "Large" 2 "Aggegate"
label values agg aggs

generate value_b = 7.84 if WTA_group==0 & agg==0
replace value_b = 7.98 if WTA_group==0 & agg==2
replace value_b = 8.12 if WTA_group==0 & agg==1
replace value_b = 4.25 if WTA_group==1 & agg==0
replace value_b = 3.88 if WTA_group==1 & agg==2
replace value_b = 3.53 if WTA_group==1 & agg==1

generate value_a = 7.06 if WTA_group==0 & agg==0
replace value_a = 6.75 if WTA_group==0 & agg==2
replace value_a = 6.46 if WTA_group==0 & agg==1
replace value_a = 5.01 if WTA_group==1 & agg==0
replace value_a = 4.50 if WTA_group==1 & agg==2
replace value_a = 3.99 if WTA_group==1 & agg==1

graph bar (mean) value_b (mean) value_a, over(agg) name("Figure2") ///
by(WTA_group, note("")) ytitle(Mean WTA) blabel(total, format(%9.2f)) ///
yscale(range(0 10)) legend(label(1 "Phase I WTA") label(2 "Phase III WTA"))
gr_edit .note.text = {}
gr_edit .note.text.Arrpush Note: Aggregate is over market treatments

** Drop temporary variables **
drop value_a value_b agg
label drop aggs
