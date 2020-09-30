** Create Low and High Anchor Groups **
label define anchor_groups 1 "Low anchor group" 0 "High anchor group"
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
** Scatter plot of anchor and WTA (Figure 1) **
twoway (scatter WTA_initial anchor) (lfit WTA_initial anchor), ///
ytitle("Phase I WTA (in €)") xtitle("Anchor drawn (in €)") ///
legend( label(2 "Linear fit")) name("Figure1")

** Anchoring table (Table 1) **
quietly eststo q2: estpost tabstat WTA_initial, by(anchor_group_q2) stat(mean semean n) columns(statistics) nototal
quietly eststo q4: estpost tabstat WTA_initial, by(anchor_group_q4) stat(mean semean n) columns(statistics) nototal
quietly eststo q5: estpost tabstat WTA_initial, by(anchor_group_q5) stat(mean semean n) columns(statistics) nototal
esttab q2 q4 q5 , ///
addnotes("Standard deviations in parentheses" "p-values refer to Mann-Whitney ranksum tests") /// 
cells(mean(fmt(2)) semean(par fmt(2))) nonumbers label

** Test for anchoring (p-values in Table 1) **
** Median split **
ranksum WTA_initial, by(anchor_group_q2)
** Quartile split **
ranksum WTA_initial, by(anchor_group_q4)
** Quintile split **
ranksum WTA_initial, by(anchor_group_q5)

** Regression
regress WTA_initial anchor endowment

** Drop temporary variables **
drop p20 p25 p50 p75 p80
drop anchor_group_q2 anchor_group_q4 anchor_group_q5
