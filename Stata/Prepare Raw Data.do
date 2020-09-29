** Recode Variables **
** treatment **
generate treatment=0, after(sessionlabel)
replace treatment=1 if sessionconfiggroup_size==2
** wine_type **
generate wine_type=0, after(sessionconfigwine_type)
replace wine_type=1 if (sessionconfigwine_type == "Arrogant Frog Cabernet Sauvignon Merlot")
replace wine_type=2 if (sessionconfigwine_type == "Arrogant Frog Chardonnay Viognier")
replace wine_type=3 if (sessionconfigwine_type == "Piccini Chianti")
drop sessionconfigwine_type
** role_1 **
generate role_1=0, before(double_auction1playeroffer)
replace role_1=1 if (double_auction1playerroles == "seller")
drop double_auction1playerroles
** role_2 **
generate role_2=0, after(double_auction2playerroles)
replace role_2=1 if (double_auction2playerroles == "seller")
drop double_auction2playerroles
** study **
generate study=0, after(double_auction2playerstudy)
replace study=1 if (double_auction2playerstudy == "Economics")
drop double_auction2playerstudy
** gender **
generate gender=0, after(double_auction2playergender)
replace gender=1 if (double_auction2playergender == "Male")
drop double_auction2playergender

** Rename Variables **
rename participantpayoff payoff
rename participantpayoff_plus_particip payoff_total
rename sessionconfigendowment endowment
rename sessionconfigauction_time duration
rename sessionconfigparticipation_fee participation_fee
rename sessionconfiggroup_size group_size
rename double_auction1playeranchor_v anchor
rename double_auction1playerbdm_draw bdm
rename double_auction1playerwta_anchor WTA_anchor
rename double_auction1playerwta_initial WTA_initial
rename double_auction1playeroffer offer_1
rename double_auction1playertrade trade_1
rename double_auction1playerprice price_1
rename double_auction1playertime time_1
rename double_auction1playerreceive_ receive_good_1
rename double_auction1playerpayoff payoff_1
rename double_auction1groupid_in_sub group_id
rename double_auction1playerid_in_gr player_id
rename double_auction2playeroffer offer_2
rename double_auction2playertrade trade_2
rename double_auction2playerprice price_2
rename double_auction2playertime time_2
rename double_auction2playerwta_final WTA_final
rename double_auction2playerreceive_ receive_good_2
rename double_auction2playerage age
rename double_auction2playerpayoff payoff_2

** Label Dataset **
label data "Anchoring Bias and Markets - Experiment"

** Label Variables **
label variable sessioncode "Session code"
label variable sessionlabel "Session label"
label variable participantcode "Participant code "
label variable participantlabel "Participant label"
label variable participantid_in_session "Participant id"
label variable group_size "Group size"
label variable payoff_total "Total payoff"
label variable payoff "Payoff"
label variable endowment "Wine price"
label variable duration "Market duration"
label variable wine_type "Wine type"
label variable participation_fee "Participation fee"
label variable treatment "Treatment"
label variable player_id "Player id"
label variable role_1 "Role(1)"
label variable anchor "Anchor"
label variable bdm "BDM draw"
label variable WTA_anchor "WTA anchor"
label variable WTA_initial "Phase I WTA"
label variable WTA_final "Phase III WTA"
label variable offer_1 "Last offer(1)"
label variable trade_1 "Trade(1)"
label variable price_1 "Price(1)"
label variable time_1 "Time(1)"
label variable receive_good_1 "Wine(1)"
label variable payoff_1 "Payoff(1)"
label variable group_id "Group id"
label variable role_2 "Role(2)"
label variable offer_2 "Last offer(2)"
label variable trade_2 "Trade(2)"
label variable price_2 "Price(2)"
label variable time_2 "Time(2)"
label variable receive_good_2 "Wine(2)"
label variable payoff_2 "Payoff(2)"
label variable age "Age"
label variable study "Study"
label variable gender "Gender"

** Label Values **
label define treatments 0 "Large" 1 "Small"
label values treatment treatments
label define wines 0 "Adriatico Verdicchio" 1 "Arrogant Frog Cabernet Sauvignon Merlot" 2 "Arrogant Frog Chardonnay Viognier" 3 "Piccini Chianti"
label values wine_type wines
label define roles 0 "Buyer" 1 "Seller"
label values role_1 roles
label values role_2 roles
label define anchors 0 "Reject" 1 "Accept"
label values WTA_anchor anchors
label define genders 0 "Female" 1 "Male" 2 "Other"
label values gender genders
label define study_fields 0 "Non-econ" 1 "Economics"
label values study study_fields

** index **
generate index = _n, before(participantid_in_session)
label variable index "Index" 

** Drop unused variables **
drop duration
drop participation_fee
drop payoff
drop bdm
drop participantlabel
drop participantcode
drop receive_good_1
drop payoff_1
drop receive_good_2
drop payoff_2

** Correct typo **
replace trade_1 = 0 in 3
replace price_1 = 0 in 3
replace endowment = 7.5 if sessionlabel == "1826-16"

