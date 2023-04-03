from otree.api import Currency as c, currency_range
from . import models
from ._builtin import Page, WaitPage
from .models import Constants
# from datetime import datetime
import time
import datetime


class Welcome(Page):
    def is_displayed(self):
        return self.round_number == 1

    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'anchor_low': self.session.config['anchor_low'],
                'anchor_high': self.session.config['anchor_high'],
                'participation_fee': self.session.config['participation_fee'],
                'num_decisions': self.session.config['repetitions']+3,
                'wine_type': self.session.config['wine_type'],
                'repetitions': self.session.config['repetitions']}

    def before_next_page(self):
        for i in range(1, self.session.config['repetitions']+1):
            self.player.in_round(i).bdm_draw = round(self.participant.vars['bdm_draw'], 1)


class Phase0RandomAnchor(Page):
    form_model = 'player'
    form_fields = ['anchor_value']

    def is_displayed(self):
        return self.session.config['treatment_random'] is True and self.round_number == 1

    def before_next_page(self):
        for i in range(1, self.session.config['repetitions']+1):
            self.player.in_round(i).anchor_value = self.player.anchor_value
            if self.session.config['treatment_random'] is not True:
                if self.player.anchor_value == self.session.config['anchor_low']:
                    self.player.in_round(i).anchor_type = 'low'
                elif self.player.anchor_value == self.session.config['anchor_high']:
                    self.player.in_round(i).anchor_type = 'high'


class Phase1Anchor(Page):
    form_model = 'player'
    form_fields = ['WTA_anchor']

    def is_displayed(self):
        return self.round_number == 1

    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'anchor_low': self.session.config['anchor_low'],
                'anchor_high': self.session.config['anchor_high']}


class Phase1Valuation(Page):
    form_model = 'player'
    form_fields = ['WTA_initial', 'full_history']

    def is_displayed(self):
        return self.round_number == 1

    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'anchor_low': self.session.config['anchor_low'],
                'anchor_high': self.session.config['anchor_high'],
                'bdm_upper': self.session.vars['bdm_upper']}


class Phase2Instructions(Page):
    def vars_for_template(self):
        return {'decision': self.round_number+2,
                'repetitions': self.session.config['repetitions'],
                'treatment_control': self.session.config['treatment_control'],
                'auctioned_item': self.session.config['auctioned_item'],
                'control_item': self.session.config['control_item'],
                'anchor_low': self.session.config['anchor_low'],
                'anchor_high': self.session.config['anchor_high'],
                'num_buyers': int(self.group.group_size/2),
                'num_sellers': int(self.group.group_size/2),
                'auction_time': self.session.config['auction_time']
                }

    def is_displayed(self):
        return self.round_number == 1


class Phase2RulesAuction(Page):
    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'control_item': self.session.config['control_item'],
                'treatment_control': self.session.config['treatment_control'],
                }

    def is_displayed(self):
        return self.session.config['group_size'] != 2 and self.round_number == 1


class Phase2RulesGroup(Page):
    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'control_item': self.session.config['control_item'],
                'treatment_control': self.session.config['treatment_control'],
                }

    def is_displayed(self):
        return self.session.config['group_size'] == 2 and self.round_number == 1


class WP(WaitPage):
    def after_all_players_arrive(self):
        now = time.time()
        self.group.auctionenddate = now + self.session.config['auction_time']

    def is_displayed(self):
        return self.round_number <= self.session.config['repetitions']


class Phase2Market(Page):
    form_model = 'player'
    form_fields = ['full_history']

    def is_displayed(self):
        return self.round_number <= self.session.config['repetitions']

    def vars_for_template(self):
        return {'time_left': self.group.time_left(),
                'decision': self.round_number+2,
                'repetitions': self.session.config['repetitions'],
                'auctioned_item': self.session.config['auctioned_item'],
                'control_item': self.session.config['control_item'],
                'anchor_low': self.session.config['anchor_low'],
                'anchor_high': self.session.config['anchor_high']
                }


class Phase3Valuation(Page):
    form_model = 'player'
    form_fields = ['WTA_final', 'full_history']

    def is_displayed(self):
        return self.round_number == self.session.config['repetitions']

    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'anchor_low': self.session.config['anchor_low'],
                'anchor_high': self.session.config['anchor_high'],
                'decision': self.session.config['repetitions'] + 3,
                'bdm_upper': self.session.vars['bdm_upper']}


class ResultsWP(WaitPage):
    def after_all_players_arrive(self):
        self.group.set_payoffs()
        if self.round_number == self.session.config['repetitions']:
            for p in self.session.get_participants():
                p.vars['receive_good'] = sum([g.receive_good for g in p.get_players()])
                p.vars['good'] = bool(p.vars['receive_good'])

    def is_displayed(self):
        return self.round_number <= self.session.config['repetitions']


class Phase2MarketSummary(Page):
    def is_displayed(self):
        return self.round_number <= self.session.config['repetitions']

    def vars_for_template(self):
        return {'auctioned_item': self.session.config['auctioned_item'],
                'round': self.round_number,
                'repetitions': self.session.config['repetitions']}


class Results(Page):
    def vars_for_template(self):
        return {'payment': self.participant.payoff_plus_participation_fee(),
                'payoff': self.participant.payoff,
                'auctioned_item': self.session.config['auctioned_item'],
                'paying_decision': self.session.vars['paying_decision'],
                'paying_round': self.session.vars['paying_round'],
                'participation_fee': self.session.config['participation_fee'],
                'endowment': self.session.config['endowment'],
                'bdm_draw': self.player.bdm_draw,
                'WTA_anchor': self.player.in_round(1).WTA_anchor,
                'WTA_initial': self.player.in_round(1).WTA_initial,
                'anchor_value': self.player.in_round(1).anchor_value,
                'roles': self.player.in_round(self.session.vars['paying_round']).roles,
                'price': self.player.in_round(self.session.vars['paying_round']).price,
                'trade': self.player.in_round(self.session.vars['paying_round']).trade,
                'WTA_final': self.player.in_round(self.session.config['repetitions']).WTA_final,
                'repetitions': self.session.config['repetitions'],
                'decision_final': self.session.config['repetitions'] + 3,
                'decision_market': self.session.vars['paying_round'] + 2,
                'receive_good': self.participant.vars['receive_good']}

    def is_displayed(self):
        return self.round_number == self.session.config['repetitions']


class Demographics(Page):
    form_model = 'player'
    form_fields = ['age', 'study', 'gender']

    def is_displayed(self):
        return self.round_number == self.session.config['repetitions']


page_sequence = [
    Welcome,
    Phase0RandomAnchor,
    Phase1Anchor,
    Phase1Valuation,
    WP,
    Phase2Instructions,
    Phase2RulesAuction,
    Phase2RulesGroup,
    WP,
    Phase2Market,
    Phase2MarketSummary,
    Phase3Valuation,
    ResultsWP,
    Demographics,
    Results
]
