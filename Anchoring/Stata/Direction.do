** Create Low and High WTA Groups **
label define WTA_groups 1 "Low WTA" 0 "High WTA"
** Median split **
sort sessioncode group_id WTA_initial
bysort sessioncode group_id: egen rank_WTA = rank(WTA_initial), unique
gen WTA_group = 0
bysort sessioncode group_id: replace WTA_group = 1 if treatment == 0 & rank_WTA < 5
bysort sessioncode group_id: replace WTA_group = 1 if treatment == 1 & rank_WTA == 1
label values WTA_group WTA_groups
drop rank_WTA

** Test for variance reduction (end of page 9) **
bysort sessioncode group_id: egen mean_WTA_i = mean(WTA_initial)
gen abs_wta_i = abs(WTA_initial - mean_WTA_i)
bysort sessioncode group_id: egen mean_WTA_f = mean(WTA_final)
gen abs_wta_f = abs(WTA_final - mean_WTA_f)
signrank abs_wta_f = abs_wta_i

** Phase I and Phase III WTA (Figure 2) **
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
drop mean_WTA_i mean_WTA_f
