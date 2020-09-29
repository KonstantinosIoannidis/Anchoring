** Power analysis **
gen pilot = (sessionlabel == "1826-03" | sessionlabel == "1826-04")
** Median split **
egen p50 = pctile(anchor) if pilot == 1, p(50)
generate anchor_group = (anchor <= p50) if pilot == 1
sum WTA_initial if pilot == 1 & anchor_group == 0
sum WTA_initial if pilot == 1 & anchor_group == 1
** Sample size calculation ** 
power twomeans 6.535714 4.821429, sd1(3.038372) sd2(2.024914)
** Power of null result **
power twomeans 6.073248 5.790566, sd(0.594) n(316)