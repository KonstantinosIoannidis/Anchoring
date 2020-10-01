This is the codebook for the "Experimental Data.csv" file.

| Variable | Description |
| :---: | :---: |
| `participant.id_in_session` | Participant number in the session |
| `participant.code` | Unique participant code |
| `participant.label` | Participant label (number of cubicle 1-16) |
| `participant.payoff` | Payoff of participant (without participation fee) |
| `participant.payoff_plus_participation_fee` | Payoff of participant (with participation fee) |
| `session.code` | Matching group code (98 groups) |
| `session.label` | Session label (23 sessions) |
| `session.config.group_size` | Treatment (matching group of two or eight) |
| `session.config.endowment` | Sample size of low anchor group |
| `session.config.auction_time` | Maximum duration of market |
| `session.config.wine_type` | Type of wine used in the session |
| `session.config.participation_fee` | Participation fee |
| `double_auction.1.player.id_in_group` | Participant ID (within matching group) |
| `double_auction.1.player.anchor_value` | Random anchor (result of two die rolls) |
| `double_auction.1.player.bdm_draw` | Randomly drawn value (between 0 and 16) |
| `double_auction.1.player.WTA_anchor` | Whether participant accepted to sell for random anchor price |
| `double_auction.1.player.WTA_initial` | WTA in Phase I |
| `double_auction.1.player.roles` | Participant role in round 1 |
| `double_auction.1.player.offer` | Participant's last offer in round 1 (either bid or ask) |
| `double_auction.1.player.trade` | Whether participant traded in round 1 |
| `double_auction.1.player.price` | Price at which participant traded in round 1 (if they did) |
| `double_auction.1.player.time` | Time as which participant traded in round 1 (if they did) |
| `double_auction.1.player.receive_good` | Whether participant obtained the good in round 1 |
| `double_auction.1.player.payoff` | Participant payoff in round 1 |
| `double_auction.1.group.id_in_subsession` | Matching group ID in subsession |
| `double_auction.2.player.roles` | Participant role in round 2 |
| `double_auction.2.player.offer` | Participant's last offer in round 2 (either bid or ask) |
| `double_auction.2.player.trade` | Whether participant traded in round 2 |
| `double_auction.2.player.price` | Price at which participant traded in round 2 (if they did) |
| `double_auction.2.player.time` | Time as which participant traded in round 2 (if they did) |
| `double_auction.2.player.receive_good` | Whether participant obtained the good in round 2 |
| `double_auction.2.player.WTA_final` | WTA in Phase III |
| `double_auction.2.player.payoff` | Participant payoff in round 2 |
| `double_auction.2.player.age` | Participant age |
| `double_auction.2.player.study` | Participant field of study |
| `double_auction.2.player.gender` | Participant gender |
