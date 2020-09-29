** Drop All Labels **
foreach var of varlist _all {
label var `var' ""
}

** Drop Server Variables **
** Participant Level **
drop participant_is_bot
drop participant_index_in_pages
drop participant_max_page_index
drop participant_current_app_name
drop participant_current_page_name
drop participantip_address
drop participanttime_started
drop participantvisited
drop participantmturk_worker_id
drop participantmturk_assignment_id
** Session Level **
drop sessionexperimenter_name
drop sessionmturk_HITId
drop sessionmturk_HITGroupId
drop sessioncomment
drop sessionis_demo
drop sessionconfigreal_world_curren
drop sessionconfigrepetitions
drop sessionconfigauctioned_item
drop sessionconfiganchor_high
drop sessionconfiganchor_low
drop sessionconfigsession_code
drop sessionconfigexperimenter_name
drop sessionconfigtreatment_random
drop sessionconfigcontrol_item
** Player Level **
drop double_auction1playeranchor_t
drop double_auction1playerWTA_fina
drop double_auction1playerage
drop double_auction1playerstudy
drop double_auction1playergender
drop double_auction2playerid_in_gr
drop double_auction2playeranchor_t
drop double_auction2playeranchor_v
drop double_auction2playerbdm_draw
drop double_auction2playerWTA_anch
drop double_auction2playerWTA_init
drop double_auction3playerid_in_gr
drop double_auction3playerroles
drop double_auction3playeranchor_t
drop double_auction3playeranchor_v
drop double_auction3playerbdm_draw
drop double_auction3playerWTA_anch
drop double_auction3playerWTA_init
drop double_auction3playeroffer
drop double_auction3playerhistory
drop double_auction3playerfull_his
drop double_auction3playertrade
drop double_auction3playerprice
drop double_auction3playertime
drop double_auction3playerWTA_fina
drop double_auction3playerreceive_
drop double_auction3playerage
drop double_auction3playerstudy
drop double_auction3playergender
drop double_auction3playerpayoff
drop double_auction1playerhistory
drop double_auction1playerfull_his
drop double_auction2playerhistory
drop double_auction2playerfull_his
** Group Level **
drop double_auction1groupgroup_siz
drop double_auction1groupthreshold
drop double_auction1groupsuccessfu
drop double_auction1groupactive_bu
drop double_auction1groupactive_se
drop double_auction1groupauctionen
drop double_auction2groupid_in_sub
drop double_auction2groupgroup_siz
drop double_auction2groupthreshold
drop double_auction2groupsuccessfu
drop double_auction2groupactive_bu
drop double_auction2groupactive_se
drop double_auction2groupauctionen
drop double_auction3groupid_in_sub
drop double_auction3groupgroup_siz
drop double_auction3groupthreshold
drop double_auction3groupsuccessfu
drop double_auction3groupactive_bu
drop double_auction3groupactive_se
drop double_auction3groupauctionen
drop double_auction3subsessionroun

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
rename sessionconfigtreatment_control control
rename sessionconfigendowment endowment
rename sessionconfigauction_time duration
rename sessionconfigparticipation_fee participation_fee
rename sessionconfiggroup_size group_size
rename double_auction1subsessionroun round_1
rename double_auction2subsessionroun round_2
rename double_auction1playeranchor_v anchor
rename double_auction1playerbdm_draw bdm
rename double_auction1playerWTA_anch WTA_anchor
rename double_auction1playerWTA_init WTA_initial
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
rename double_auction2playerWTA_fina WTA_final
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
label variable control "Random"
label variable round_1 "Round 1"
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
label variable round_2 "Round 2"
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
drop control
drop duration
drop participation_fee
drop payoff
drop bdm
drop participantlabel
drop participantcode
drop receive_good_1
drop payoff_1
drop round_1
drop receive_good_2
drop payoff_2
drop round_2

** Correct typo **
replace trade_1 = 0 in 3
replace price_1 = 0 in 3
replace endowment = 7.5 if sessionlabel == "1826-16"

