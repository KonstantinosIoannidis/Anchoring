* Code lotteries as unfamiliar goods *
replace good = "unfamiliar" if good == "lottery"
* Encode string variables to numeric *
encode good, gen(good_type)
encode anchor, gen(anchor_type)
encode incentives, gen(paid)
encode elicitation, gen(wtp_wta)
order good_type, after(good)
order anchor_type, after(anchor)
order wtp_wta, after(elicitation)
order paid, after(incentives)
drop good
drop anchor
drop elicitation
drop incentives
rename good_type good
rename anchor_type anchor
rename wtp_wta elicitation
* Drop unincentivized studies *
drop if paid == 1