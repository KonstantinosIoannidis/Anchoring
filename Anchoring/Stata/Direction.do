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
** Phase I and Phase III WTA (Figure 2) **
run "..\Stata\Figure 2.do"

** Test for variance reduction (end of page 9) **
bysort sessioncode group_id: egen mean_WTA_i = mean(WTA_initial)
gen abs_wta_i = abs(WTA_initial - mean_WTA_i)
bysort sessioncode group_id: egen mean_WTA_f = mean(WTA_final)
gen abs_wta_f = abs(WTA_final - mean_WTA_f)
signrank abs_wta_f = abs_wta_i

** Drop temporary variables **
drop mean_WTA_i mean_WTA_f