** Compute columns 6, 7 and 8 of Table 3 **
asgen ratio_m = ratio, by(paper good anchor elicitation paid)
replace ratio_m = round(ratio_m, 0.01)
asgen g_m = g_effect, by(paper good anchor elicitation paid)
replace g_m = round(g_m, 0.001)
egen n_m = mean(n_total), by(paper good anchor elicitation paid)
replace n_m = round(n_m, 1)
order ratio_m, after(elicitation)
order g_m, after(ratio_m)
order n_m, after(elicitation)

** Create Figures 3a and 3b **
meta set g_effect g_se, studylabel(paper) studysize(n_total) eslabel(Hedge's g)
meta forestplot if paid == 2 & anchor < 3, subgroup(good elicitation anchor) columnopts(_id, title(Variable)) columnopts(_K, title(#Results)) noohetstats xscale(range(-0.5 1)) xlabel(-0.5 0 0.5 1) name("Figure3a")
meta forestplot if paid==2 & anchor == 3, subgroup(good elicitation) columnopts(_id, title(Variable)) columnopts(_K, title(#Results)) noohetstats noghetstats nogbhomtests crop(-0.5 1) xlabel(-0.5 0 0.5 1)  name("Figure3b")

** Computation of weights for Table 3 **
* Weights of Good (column 2) *
egen familiar_a_sum = sum(g_weights * (good == 1) * (anchor < 3) ) if ((good == 1) & (anchor < 3))
egen familiar_b_sum = sum(g_weights * (good == 1) * (anchor == 3) ) if ((good == 1) & (anchor == 3))
egen unfamiliar_a_sum = sum(g_weights * (good == 2) * (anchor < 3) ) if ((good == 2) & (anchor < 3))
egen unfamiliar_b_sum = sum(g_weights * (good == 2) * (anchor == 3) ) if ((good == 2) & (anchor == 3))
gen g_familiar_a = g_weights/familiar_a_sum
gen g_familiar_b = g_weights/familiar_b_sum
gen g_unfamiliar_a = g_weights/unfamiliar_a_sum
gen g_unfamiliar_b = g_weights/unfamiliar_b_sum
drop familiar_* unfamiliar_*
bysort paper good anchor elicitation: egen col2af = sum(g_familiar_a)
bysort paper good anchor elicitation: egen col2au = sum(g_unfamiliar_a)
bysort paper good anchor elicitation: egen col2bf = sum(g_familiar_b)
bysort paper good anchor elicitation: egen col2bu = sum(g_unfamiliar_b)
gen good_weights = max(col2af, col2au, col2bf, col2bu), after(good)
replace good_weights = round(good_weights*100, 0.1)
drop col*
drop g_fam* g_unf*
* Weights of Anchor (column 3) *
egen informative_a_sum = sum(g_weights * (anchor == 1)) if (anchor == 1)
egen questionable_a_sum = sum(g_weights * (anchor == 2)) if (anchor == 2)
egen uninformative_b_sum = sum(g_weights * (anchor == 3)) if (anchor == 3)
gen g_informative_a = g_weights/informative_a_sum
gen g_questionable_a = g_weights/questionable_a_sum
gen g_uninformative_b = g_weights/uninformative_b_sum
drop info* que*
drop uninfo*
bysort paper good anchor elicitation: egen col3ai = sum(g_informative_a)
bysort paper good anchor elicitation: egen col3aq = sum(g_questionable_a)
bysort paper good anchor elicitation: egen col3bu = sum(g_uninformative_b)
gen anchor_weights = max(col3ai, col3aq, col3bu), after(anchor)
replace anchor_weights = round(anchor_weights*100, 0.1)
drop col*
drop g_informative_a g_questionable_a g_uninformative_b
* Weights of wtp_wta (column 4) *
egen wta_a_sum = sum(g_weights * (elicitation == 1) * (anchor < 3) ) if ((elicitation == 1) & (anchor < 3))
egen wta_b_sum = sum(g_weights * (elicitation == 1) * (anchor == 3) ) if ((elicitation == 1) & (anchor == 3))
egen wtp_a_sum = sum(g_weights * (elicitation == 2) * (anchor < 3) ) if ((elicitation == 2) & (anchor < 3))
egen wtp_b_sum = sum(g_weights * (elicitation == 2) * (anchor == 3) ) if ((elicitation == 2) & (anchor == 3))
gen g_wta_a = g_weights/wta_a_sum
gen g_wta_b = g_weights/wta_b_sum
gen g_wtp_a = g_weights/wtp_a_sum
gen g_wtp_b = g_weights/wtp_b_sum
drop wta_* wtp_*
bysort paper good anchor elicitation: egen col4ap = sum(g_wtp_a)
bysort paper good anchor elicitation: egen col4aa = sum(g_wta_a)
bysort paper good anchor elicitation: egen col4bp = sum(g_wtp_b)
bysort paper good anchor elicitation: egen col4ba = sum(g_wta_b)
gen wtp_wta_weights = max(col4ap, col4aa, col4bp, col4ba), after(elicitation)
replace wtp_wta_weights = round(wtp_wta_weights*100, 0.1)
drop col*
drop g_wt*

** Drop temporary variables **
drop _meta*
