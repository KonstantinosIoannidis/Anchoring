from otree.api import (
    models, widgets, BaseConstants, BaseSubsession, BaseGroup, BasePlayer,
    Currency as c, currency_range
)
import random
from numpy import arange, reshape, asmatrix, array, ndarray
from django import forms
from django.conf import settings
import time
import datetime

author = 'Konstantinos loannidis & Tina Marjanov'

doc = """
Double auction with anchoring
"""


class Constants(BaseConstants):
    name_in_url = 'double_auction'
    players_per_group = None
    num_rounds = 3


class Subsession(BaseSubsession):
    def creating_session(self):
        num_groups = int(self.session.num_participants/self.session.config['group_size'])
        matrix = array([arange(1, self.session.num_participants+1)])
        matrix = reshape(matrix, (num_groups, self.session.config['group_size']))
        self.set_group_matrix(matrix.tolist())

        # Initializing group parameters
        for g in self.get_groups():
            g.threshold = 16
            # g.threshold = self.session.config['endowment'] + float(self.session.config['participation_fee'])
            g.group_size = self.session.config['group_size']

        # Initializing parameters of the experiment
        if self.round_number == 1:
            self.session.vars['paying_decision'] = random.choice(['WTA_anchor', 'WTA_initial', 'market', 'WTA_final'])
            self.session.vars['paying_round'] = random.randint(1, self.session.config['repetitions'])
            self.session.vars['bdm_upper'] = 2 * self.session.config['endowment']
            print(self.session.vars['paying_decision'], self.session.vars['paying_round'])
            for p in self.session.get_participants():
                p.vars['bdm_draw'] = round(random.uniform(0, self.session.vars['bdm_upper']), 1)
                print(p.vars['bdm_draw'])

        # Reversing roles every round
        for p in self.get_players():
            if self.round_number % 2 == 1:
                if p.id_in_group % 2 == 1:
                    p.roles = 'buyer'
                elif p.id_in_group % 2 == 0:
                    p.roles = 'seller'
            else:
                if p.id_in_group % 2 == 1:
                    p.roles = 'seller'
                elif p.id_in_group % 2 == 0:
                    p.roles = 'buyer'

        # Assigning anchors
        if self.session.config['treatment_random'] is not True:
            for participant in self.session.get_participants():
                if participant.id_in_session % 8 == 1 or participant.id_in_session % 8 == 5:
                    for player in participant.get_players():
                        player.anchor_type = 'high'
                        player.anchor_value = self.session.config['anchor_high']
                elif participant.id_in_session % 8 == 4 or participant.id_in_session % 8 == 6:
                    for player in participant.get_players():
                        player.anchor_type = 'high'
                        player.anchor_value = self.session.config['anchor_high']
                elif participant.id_in_session % 8 == 3 or participant.id_in_session % 8 == 7:
                    for player in participant.get_players():
                        player.anchor_type = 'low'
                        player.anchor_value = self.session.config['anchor_low']
                elif participant.id_in_session % 8 == 2 or participant.id_in_session % 8 == 0:
                    for player in participant.get_players():
                        player.anchor_type = 'low'
                        player.anchor_value = self.session.config['anchor_low']
        for player in self.get_players():
            player.history = ''
        for player in self.get_players():
            player.offer = 0

    def vars_for_admin_report(self):
        participants = [p for p in self.session.get_participants()]
        total_payments = sum(p.payoff_plus_participation_fee() for p in self.session.get_participants())
        mean_payment = total_payments/self.session.num_participants
        return {'participants': participants,
                'participation_fee': self.session.config['participation_fee'],
                'wine_type': self.session.config['wine_type'].capitalize(),
                'total_payments': total_payments,
                'mean_payment': mean_payment,
                'experimenter_name': self.session.config['experimenter_name']}


class Group(BaseGroup):
    group_size = models.IntegerField()
    threshold = models.FloatField()
    successful_trades = models.StringField(initial=0)
    active_buyers = models.StringField(initial=0)
    active_sellers = models.StringField(initial=0)
    auctionenddate = models.FloatField()

    def time_left(self):
            now = time.time()
            time_left = self.auctionenddate - now
            time_left = round(time_left) if time_left > 0 else 0
            return time_left

    def set_payoffs(self):
        for player in self.get_players():
            if self.session.vars['paying_decision'] == 'WTA_anchor' and self.round_number == 1:
                player.payoff = player.WTA_anchor*player.anchor_value
                player.receive_good = not player.WTA_anchor
            elif self.session.vars['paying_decision'] == 'WTA_initial' and self.round_number == 1:
                if player.bdm_draw < player.WTA_initial:
                    player.payoff = 0
                    player.receive_good = True
                else:
                    player.payoff = player.bdm_draw
            elif self.session.vars['paying_decision'] == 'market' and self.round_number == self.session.vars['paying_round']:
                if player.roles == 'buyer':
                    player.payoff = self.session.config['endowment'] - player.trade*player.price
                    player.receive_good = player.trade
                elif player.roles == 'seller':
                    player.payoff = player.trade*player.price
                    player.receive_good = int(not bool(player.trade))
            elif self.session.vars['paying_decision'] == 'WTA_final' and self.round_number == self.session.config['repetitions']:
                if player.bdm_draw < player.WTA_final:
                    player.payoff = 0
                    player.receive_good = True
                else:
                    player.payoff = player.bdm_draw


class Player(BasePlayer):
    roles = models.StringField()
    anchor_type = models.StringField()
    anchor_value = models.CurrencyField()
    bdm_draw = models.CurrencyField()
    WTA_anchor = models.BooleanField(initial=0)
    WTA_initial = models.CurrencyField(min=0)
    offer = models.FloatField(initial=0)
    history = models.StringField()
    full_history = models.StringField()
    trade = models.IntegerField(initial=0)
    price = models.FloatField(initial=0)
    time = models.IntegerField()
    WTA_final = models.CurrencyField(min=0)
    receive_good = models.IntegerField(initial=0)
    age = models.IntegerField(min=18)
    study = models.StringField(choices=['Economics', 'Social Sciences (Non-economics)', 'Natural Sciences', 'Humanities', 'Applied Sciences', 'Other'], widget=widgets.RadioSelect)
    gender = models.StringField(choices=['Male', 'Female', 'Prefer not to answer'], widget=widgets.RadioSelect)

    def write_offer(self, offer, cur_time):
        if self.roles == 'seller':              # seller can only decrease ask
            if offer > self.offer and self.offer != 0:
                return
        if self.roles == 'buyer':               # buyer can only increase bid
            if offer < self.offer and self.offer != 0:
                return
        self.offer = round(offer, 2)
        self.history += ' [' + str(round(offer, 2)) + ',' + str(int(cur_time)) + ']'

    def trade_value(self):
        return self.trade
