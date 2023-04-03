import os
from os import environ
import dj_database_url
# import otree.settings

CHANNEL_ROUTING = 'double_auction.routing.channel_routing'
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

os.environ['OTREE_PRODUCTION'] = "1"

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
AUTH_LEVEL = "STUDY"

ADMIN_USERNAME = "admin"
# for security, best to set admin password in an environment variable
ADMIN_PASSWORD = "admin"


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


DATABASES = {
    'default': dj_database_url.config(
        default='sqlite:///' + os.path.join(BASE_DIR, 'db.sqlite3')
    )
}


# if an app is included in SESSION_CONFIGS, you don't need to list it here
# INSTALLED_APPS = ['otree']
INSTALLED_APPS = ['otree','otree_export_utils']
EXTENSION_APPS = ['otree_tools']
