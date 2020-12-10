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
preserve
collapse WTA_final WTA_initial, by (treatment WTA_group)
insobs 2
gen aggregate = 1 - treatment
replace aggregate = 2 if aggregate == .
label define aggregates 0 "Small" 1 "Large" 2 "Aggegate"
label values aggregate aggregates
bysort WTA_group: egen WTA_initial_agg_high = mean(WTA_initial) if WTA_group == 0
bysort WTA_group: egen WTA_initial_agg_low = mean(WTA_initial) if WTA_group == 1
bysort WTA_group: egen WTA_final_agg_high = mean(WTA_final) if WTA_group == 0
bysort WTA_group: egen WTA_final_agg_low = mean(WTA_final) if WTA_group == 1
replace WTA_group = 0 if _n == 5
replace WTA_group = 1 if _n == 6
replace WTA_initial = WTA_initial_agg_high[_n-4] if _n == 5
replace WTA_initial = WTA_initial_agg_low[_n-2] if _n == 6
replace WTA_final = WTA_final_agg_high[_n-4] if _n == 5
replace WTA_final = WTA_final_agg_low[_n-2] if _n == 6
graph bar (mean) WTA_initial (mean) WTA_final, over(aggregate) name("Figure2") by(WTA_group, note("")) ytitle(Mean WTA) blabel(total, format(%9.2f)) yscale(range(0 10)) legend(label(1 "Phase I WTA") label(2 "Phase III WTA"))
gr_edit .note.text = {}
gr_edit .note.text.Arrpush Note: Aggregate is over market treatments
restore

** Drop temporary variables **
drop mean_WTA_i mean_WTA_f
drop abs_wta_i abs_wta_f
