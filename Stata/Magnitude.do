** Average observed behavior **
generate observed_1 = price_1
replace observed_1 = offer_1 if price_1 == 0
generate observed_2 = price_2
replace observed_2 = offer_2 if price_2 == 0
bysort sessioncode group_id: egen obs_sum_1 = sum(observed_1)
generate obs_sum_other_1 = round(obs_sum_1 - observed_1, 0.01)
generate obs_other_1 = round(obs_sum_other_1/(group_size - 1), 0.01)
bysort sessioncode group_id: egen obs_sum_2 = sum(observed_2)
generate obs_sum_other_2 = round(obs_sum_2 - observed_2, 0.01)
generate obs_other_2 = round(obs_sum_other_2/(group_size - 1), 0.01)
generate obs_other = (obs_other_1+obs_other_2)/2
drop observed_1 observed_2 obs_sum_1 obs_sum_2 
drop obs_other_1 obs_other_2 obs_sum_other_1 obs_sum_other_2
label variable obs_other "Observed market information"

** Regression Table for market information (Table 2) **
egen matching=group(sessioncode group_id)
eststo small: quietly ///
regress WTA_final WTA_initial obs_other endowment age gender study if treatment==1, vce(cluster matching)
eststo large: quietly ///
regress WTA_final WTA_initial obs_other endowment age gender study if treatment==0, vce(cluster matching)
eststo both: quietly ///
regress WTA_final WTA_initial obs_other (c.WTA_initial)#i.treatment endowment age gender study, vce(cluster matching)
esttab small large both, ///
indicate(Controls = age gender study) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) b(2) obslast type ///
addnotes("Std. Err. adjusted for 98 matching group clusters" ///
"\sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)")

** Drop temporary variables **
drop obs_other matching
drop _est*

** Footnote 9 **
bysort WTA_group: signrank WTA_final = WTA_initial
drop WTA_group