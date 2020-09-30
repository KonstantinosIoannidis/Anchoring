** Consistent answers **
** Create consistency variable **
generate consistency=0, after(WTA_initial)
replace consistency=1 if ((WTA_initial>=anchor & WTA_anchor==0) | (WTA_initial<=anchor & WTA_anchor==1))
label variable consistency "Consistency"
** Median split **
egen p50 = pctile(anchor) if consistency==1, p(50)
generate anchor_group_q2 = (anchor <= p50) if consistency==1
label values anchor_group_q2 anchor_groups
** Quartile split **
generate anchor_group_q4 = .
egen p25 = pctile(anchor) if consistency==1, p(25)
egen p75 = pctile(anchor) if consistency==1, p(75)
replace anchor_group_q4=1 if anchor<p25 & consistency==1
replace anchor_group_q4=0 if anchor>=p75 & consistency==1
label values anchor_group_q4 anchor_groups
** Quintile split **
generate anchor_group_q5 = .
egen p20 = pctile(anchor) if consistency==1, p(20)
egen p80 = pctile(anchor) if consistency==1, p(80)
replace anchor_group_q5=1 if anchor<p20 & consistency==1
replace anchor_group_q5=0 if anchor>=p80 & consistency==1
label values anchor_group_q5 anchor_groups
** Test for anchoring **
** Median split **
ranksum WTA_initial, by(anchor_group_q2)
** Quartile split **
ranksum WTA_initial, by(anchor_group_q4)
** Quintile split **
ranksum WTA_initial, by(anchor_group_q5)
** Regression
regress WTA_initial anchor endowment if consistency==1
** Drop anchor groups **
drop p20 p25 p50 p75 p80
drop anchor_group_q2 anchor_group_q4 anchor_group_q5
drop consistency

** Truncated answers **
generate WTA_initial_t = WTA_initial
replace WTA_initial_t = 10 if WTA_initial_t>10
** Median split **
egen p50 = pctile(anchor), p(50)
generate anchor_group_q2 = (anchor <= p50)
label values anchor_group_q2 anchor_groups
** Quartile split **
generate anchor_group_q4 = .
egen p25 = pctile(anchor), p(25)
egen p75 = pctile(anchor), p(75)
replace anchor_group_q4=1 if anchor<=p25
replace anchor_group_q4=0 if anchor>=p75
label values anchor_group_q4 anchor_groups
** Quintile split **
generate anchor_group_q5 = .
egen p20 = pctile(anchor), p(20)
egen p80 = pctile(anchor), p(80)
replace anchor_group_q5=1 if anchor<p20
replace anchor_group_q5=0 if anchor>p80
label values anchor_group_q5 anchor_groups
** Test for anchoring **
** Median split **
ranksum WTA_initial_t, by(anchor_group_q2)
** Quartile split **
ranksum WTA_initial_t, by(anchor_group_q4)
** Quintile split **
ranksum WTA_initial_t, by(anchor_group_q5)
** Regression
regress WTA_initial_t anchor endowment
** Drop anchor groups **
drop p20 p25 p50 p75 p80
drop anchor_group_q2 anchor_group_q4 anchor_group_q5
drop WTA_initial_t

** Demographics **
** Per type of study **
bysort study: regress WTA_initial anchor endowment
** Per gender **
bysort gender: regress WTA_initial anchor endowment

** Footnote 7 **
eststo wine_0: quietly regress WTA_initial anchor if wine_type == 0
eststo wine_1: quietly regress WTA_initial anchor if wine_type == 1
eststo wine_2: quietly regress WTA_initial anchor if wine_type == 2
eststo wine_3: quietly regress WTA_initial anchor if wine_type == 3
esttab wine_0 wine_1 wine_2 wine_3, ///
p r2 label nonumber noomitted nobaselevels b(2) obslast
