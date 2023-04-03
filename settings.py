import os
from os import environ
import dj_database_url
# import otree.settings

CHANNEL_ROUTING = 'double_auction.routing.channel_routing'
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

os.environ['OTREE_PRODUCTION'] = "1"
os.environ['OTREE_AUTH_LEVEL'] = "STUDY"
os.environ['OTREE_ADMIN_PASSWORD'] = "CREED"
os.environ['DATABASE_URL'] = 'postgres://postgres@localhost/django_db'
os.environ['SENTRY_DSN'] = 'https://e610c2444f7b4907b693e040f416a38e:f949ee7ffb2747c0ac129bb63070fba2@sentry2.otree.org/16 '


# if you set a property in SESSION_CONFIG_DEFAULTS, it will be inherited by all configs
# in SESSION_CONFIGS, except those that explicitly override it.
# the session config can be accessed from methods in your apps as self.session.config,
# e.g. self.session.config['participation_fee']

SESSION_CONFIG_DEFAULTS = {
    'real_world_currency_per_point': 1.00,
    'participation_fee': 8.00,
    'doc': "",
}

SESSION_CONFIGS = [
    {
        'name': 'Anchoring_Bias_in_Markets',
        'display_name': 'Anchoring Bias in Markets',
        'app_sequence': ['double_auction'],
        'session_code': '',
        'treatment_random': True,
        'treatment_control': False,
        'group_size': 3,
        'num_demo_participants': 3,
        'repetitions': 2,
        'auctioned_item': 'bottle of wine',
        'wine_type': '',
        'control_item': 'box of chocolate',
        'endowment': 6.00,
        'anchor_low': 3,
        'anchor_high': 9,
        'auction_time': 300,
        'experimenter_name': 'Konstantinos Ioannidis'
    },
]
# see the end of this file for the inactive session configs


# ISO-639 code
# for example: de, fr, ja, ko, zh-hans
LANGUAGE_CODE = 'en'

# e.g. EUR, GBP, CNY, JPY
REAL_WORLD_CURRENCY_CODE = 'EUR'
REAL_WORLD_CURRENCY_DECIMAL_PLACES = 1
USE_POINTS = False

ROOMS = [
    {
        'name': 'Amsterdam1',
        'display_name': 'Amsterdam1',
        'participant_label_file': '_rooms/amsterdam.txt',
    },
    {
        'name': 'Amsterdam2',
        'display_name': 'Amsterdam2',
        'participant_label_file': '_rooms/amsterdam.txt',
    },
]


# AUTH_LEVEL:
# this setting controls which parts of your site are freely accessible,
# and which are password protected:
# - If it's not set (the default), then the whole site is freely accessible.
# - If you are launching a study and want visitors to only be able to
#   play your app if you provided them with a start link, set it to STUDY.
# - If you would like to put your site online in public demo mode where
#   anybody can play a demo version of your game, but not access the rest
#   of the admin interface, set it to DEMO.

# for flexibility, you can set it in the environment variable OTREE_AUTH_LEVEL
AUTH_LEVEL = environ.get('OTREE_AUTH_LEVEL')

ADMIN_USERNAME = 'admin'
# for security, best to set admin password in an environment variable
ADMIN_PASSWORD = environ.get('OTREE_ADMIN_PASSWORD')


# Consider '', None, and '0' to be empty/false
# DEBUG = (environ.get('OTREE_PRODUCTION') not in {None, '', '0'})
if environ.get('OTREE_PRODUCTION') not in {None, '', '0'}:
    DEBUG = False
else:
    DEBUG = True

DEMO_PAGE_INTRO_HTML = """
Here are various games implemented with 
oTree. These games are open
source, and you can modify them as you wish.
"""

# don't share this with anybody.
SECRET_KEY = 'iowcny5&q53yi=zm(zcba4-7#s_kijtijs5-d)!hwd#tt1dgqg'

DATABASES = {
    'default': dj_database_url.config(
        default='sqlite:///' + os.path.join(BASE_DIR, 'db.sqlite3')
    )
}


# if an app is included in SESSION_CONFIGS, you don't need to list it here
# INSTALLED_APPS = ['otree']
INSTALLED_APPS = ['otree','otree_export_utils']
EXTENSION_APPS = ['otree_tools']

# inactive session configs
# {
#     'name': 'public_goods',
#     'display_name': "Public Goods",
#     'num_demo_participants': 3,
#     'app_sequence': ['public_goods', 'payment_info'],
# },
# {
#     'name': 'guess_two_thirds',
#     'display_name': "Guess 2/3 of the Average",
#     'num_demo_participants': 3,
#     'app_sequence': ['guess_two_thirds', 'payment_info'],
# },
# {
#     'name': 'survey',
#     'num_demo_participants': 1,
#     'app_sequence': ['survey', 'payment_info'],
# },
# {
#     'name': 'quiz',
#     'num_demo_participants': 1,
#     'app_sequence': ['quiz'],
# },
# {
#     'name': 'trust',
#     'display_name': "Trust Game",
#     'num_demo_participants': 2,
#     'app_sequence': ['trust', 'payment_info'],
# },
# {
#     'name': 'prisoner',
#     'display_name': "Prisoner's Dilemma",
#     'num_demo_participants': 2,
#     'app_sequence': ['prisoner', 'payment_info'],
# },
# {
#     'name': 'ultimatum',
#     'display_name': "Ultimatum (randomized: strategy vs. direct response)",
#     'num_demo_participants': 2,
#     'app_sequence': ['ultimatum', 'payment_info'],
# },
# {
#     'name': 'ultimatum_strategy',
#     'display_name': "Ultimatum (strategy method treatment)",
#     'num_demo_participants': 2,
#     'app_sequence': ['ultimatum', 'payment_info'],
#     'use_strategy_method': True,
# },
# {
#     'name': 'ultimatum_non_strategy',
#     'display_name': "Ultimatum (direct response treatment)",
#     'num_demo_participants': 2,
#     'app_sequence': ['ultimatum', 'payment_info'],
#     'use_strategy_method': False,
# },
# {
#     'name': 'vickrey_auction',
#     'display_name': "Vickrey Auction",
#     'num_demo_participants': 3,
#     'app_sequence': ['vickrey_auction', 'payment_info'],
# },
# {
#     'name': 'volunteer_dilemma',
#     'display_name': "Volunteer's Dilemma",
#     'num_demo_participants': 3,
#     'app_sequence': ['volunteer_dilemma', 'payment_info'],
# },
# {
#     'name': 'cournot',
#     'display_name': "Cournot Competition",
#     'num_demo_participants': 2,
#     'app_sequence': [
#         'cournot', 'payment_info'
#     ],
# },
# {
#     'name': 'principal_agent',
#     'display_name': "Principal Agent",
#     'num_demo_participants': 2,
#     'app_sequence': ['principal_agent', 'payment_info'],
# },
# {
#     'name': 'dictator',
#     'display_name': "Dictator Game",
#     'num_demo_participants': 2,
#     'app_sequence': ['dictator', 'payment_info'],
# },
# {
#     'name': 'matching_pennies',
#     'display_name': "Matching Pennies",
#     'num_demo_participants': 2,
#     'app_sequence': [
#         'matching_pennies',
#     ],
# },
# {
#     'name': 'traveler_dilemma',
#     'display_name': "Traveler's Dilemma",
#     'num_demo_participants': 2,
#     'app_sequence': ['traveler_dilemma', 'payment_info'],
# },
# {
#     'name': 'bargaining',
#     'display_name': "Bargaining Game",
#     'num_demo_participants': 2,
#     'app_sequence': ['bargaining', 'payment_info'],
# },
# {
#     'name': 'common_value_auction',
#     'display_name': "Common Value Auction",
#     'num_demo_participants': 3,
#     'app_sequence': ['common_value_auction', 'payment_info'],
# },
# {
#     'name': 'bertrand',
#     'display_name': "Bertrand Competition",
#     'num_demo_participants': 2,
#     'app_sequence': [
#         'bertrand', 'payment_info'
#     ],
# },
# {
#     'name': 'real_effort',
#     'display_name': "Real-effort transcription task",
#     'num_demo_participants': 1,
#     'app_sequence': [
#         'real_effort',
#     ],
# },
# {
#     'name': 'lemon_market',
#     'display_name': "Lemon Market Game",
#     'num_demo_participants': 3,
#     'app_sequence': [
#         'lemon_market', 'payment_info'
#     ],
# },
# {
#     'name': 'public_goods_simple',
#     'display_name': "Public Goods (simple version from tutorial)",
#     'num_demo_participants': 3,
#     'app_sequence': ['public_goods_simple', 'payment_info'],
# },
# {
#     'name': 'trust_simple',
#     'display_name': "Trust Game (simple version from tutorial)",
#     'num_demo_participants': 2,
#     'app_sequence': ['trust_simple'],
# },
