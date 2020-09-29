** Median split **
egen p50 = pctile(anchor) if study == 0, p(50)
generate anchor_group_q20 = (anchor <= p50) if study == 0
label values anchor_group_q20 anchor_groups
** Quartile split **
generate anchor_group_q40 = .
egen p25 = pctile(anchor) if study == 0, p(25)
egen p75 = pctile(anchor) if study == 0, p(75)
replace anchor_group_q40=1 if anchor<=p25 & study == 0
replace anchor_group_q40=0 if anchor>=p75 & study == 0
label values anchor_group_q40 anchor_groups
** Quintile split **
generate anchor_group_q50 = .
egen p20 = pctile(anchor) if study == 0, p(20)
egen p80 = pctile(anchor) if study == 0, p(80)
replace anchor_group_q50=1 if anchor<=p20 & study == 0
replace anchor_group_q50=0 if anchor>=p80 & study == 0
label values anchor_group_q50 anchor_groups

** Drop temporary variables **
drop p20 p25 p50 p75 p80

** Test for anchoring (p-values in Table 1) **
** Median split **
ranksum WTA_initial, by(anchor_group_q20)
** Quartile split **
ranksum WTA_initial, by(anchor_group_q40)
** Quintile split **
ranksum WTA_initial, by(anchor_group_q50)

** Median split **
egen p50 = pctile(anchor) if study == 1, p(50)
generate anchor_group_q21 = (anchor <= p50) if study == 1
label values anchor_group_q21 anchor_groups
** Quartile split **
generate anchor_group_q41 = .
egen p25 = pctile(anchor) if study == 1, p(25)
egen p75 = pctile(anchor) if study == 1, p(75)
replace anchor_group_q41=1 if anchor<=p25 & study == 1
replace anchor_group_q41=0 if anchor>=p75 & study == 1
label values anchor_group_q41 anchor_groups
** Quintile split **
generate anchor_group_q51 = .
egen p20 = pctile(anchor) if study == 1, p(20)
egen p80 = pctile(anchor) if study == 1, p(80)
replace anchor_group_q51=1 if anchor<=p20 & study == 1
replace anchor_group_q51=0 if anchor>=p80 & study == 1
label values anchor_group_q51 anchor_groups

** Test for anchoring **
** Median split **
ranksum WTA_initial, by(anchor_group_q21)
** Quartile split **
ranksum WTA_initial, by(anchor_group_q41)
** Quintile split **
ranksum WTA_initial, by(anchor_group_q51)

** Drop temporary variables **
drop p20 p25 p50 p75 p80
drop anchor_group_*