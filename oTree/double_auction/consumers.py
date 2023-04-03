from channels import Group
from channels.sessions import channel_session
import random
from .models import Player, Group as OtreeGroup, Constants
import json
import time
from django.conf import settings


def ws_connect(message, group_name):
    Group(group_name).add(message.reply_channel)


def get_seller_buyer_list(mygroup):
    seller_list = []
    buyer_list = []
    for i in range(1, mygroup.group_size + 1):
        player = mygroup.get_player_by_id(i)
        if not player.trade == 1 and not player.offer == 0:
            if player.roles == 'buyer':
                buyer_list.append(player.offer)
            else:
                seller_list.append(player.offer)

    seller_list.sort()
    buyer_list.sort(reverse=True)
    return seller_list, buyer_list


def get_trades(mygroup):
    trade_list = []
    for i in range(1, mygroup.group_size + 1):
        player = mygroup.get_player_by_id(i)
        if player.trade == 1:
            trade_list.append(player.price)
    trade_list = list(set(trade_list))
    trades = ''
    for i in trade_list:
        trades = trades + ' ' + str(i)
    return trades


def check_trade(buyer_list, seller_list, mygroup, latest_offer, time_since_start, seller_found, buyer_found):
    counter = 2
    trade_price = 0.0
    if len(seller_list) > 0 and len(buyer_list) > 0:
        if seller_list[0] <= buyer_list[0]:
            for i in range(1, mygroup.group_size + 1):
                player_to_remove = mygroup.get_player_by_id(i)
                if (player_to_remove.roles == 'seller' and seller_found == 1) or \
                        (player_to_remove.roles == 'buyer' and buyer_found == 1):
                    pass
                else:
                    if (player_to_remove.offer == buyer_list[0] or player_to_remove.offer == seller_list[0])\
                            and counter > 0 and player_to_remove.trade == 0:
                        # print('found')
                        if player_to_remove.roles == 'seller':
                            seller_found = 1
                        else:
                            buyer_found = 1
                        counter = counter - 1
                        if buyer_list[0] == latest_offer:
                            trade_price = seller_list[0]
                        else:
                            trade_price = buyer_list[0]
                        player_to_remove.trade = 1
                        player_to_remove.price = trade_price
                        player_to_remove.time = int(time_since_start)
                        player_to_remove.save()
                        mygroup.successful_trades = get_trades(mygroup)
    return seller_found, buyer_found, trade_price


# Connected to websocket.receive
def ws_message(message, group_name):

    group_id = group_name[5:]
    jsonmessage = json.loads(message.content['text'])
    latest_offer = float(str(jsonmessage['value']))
    start_time = int(jsonmessage['start_time'])
    now = time.time()
    time_since_start = int(int(jsonmessage['time_since_start'])/1000)
    #print(test)
    #time_since_start = int(str(now)[:10]) -  int(str(start_time)[:10])
    print(time_since_start)

    mygroup = OtreeGroup.objects.get(id=group_id)

    curbuyer_id_in_group = jsonmessage['id_in_group']
    myplayer = mygroup.get_player_by_id(curbuyer_id_in_group)

    old_offer = myplayer.offer
    myplayer.write_offer(latest_offer, time_since_start)

    offer_accepted = old_offer != myplayer.offer
    myplayer.time = time_since_start

    mygroup.save()
    mygroup.save()
    myplayer.save()
    time_left = round(mygroup.auctionenddate - now)

    seller_list, buyer_list = get_seller_buyer_list(mygroup)

    seller_found = 0
    buyer_found = 0

    seller_found, buyer_found, trade_price = \
        check_trade(buyer_list, seller_list, mygroup, latest_offer, time_since_start, seller_found, buyer_found)

    seller_list, buyer_list = get_seller_buyer_list(mygroup)

    mygroup.active_buyers = ', '.join(str(e) for e in buyer_list)
    mygroup.active_sellers = ', '.join(str(e) for e in seller_list)
    mygroup.save()

    active_ids = []
    for i in range(1, mygroup.group_size + 1):
        player = mygroup.get_player_by_id(i)
        if player.trade == 0:
            active_ids.append(i)

    textforgroup = json.dumps({
        "group_size": mygroup.group_size,
        "successful_trades": mygroup.successful_trades,
        "active_buyers": mygroup.active_buyers,
        "active_sellers": mygroup.active_sellers,
        "time_left": time_left,
        "active_ids": str(active_ids),
        "successful_trade_value": trade_price,
        "current_offer": myplayer.offer,
        "offer_accepted": offer_accepted,
        "offer_origin": curbuyer_id_in_group,
    })
    Group(group_name).send({
        "text": textforgroup,
    })


# Connected to websocket.disconnect
def ws_disconnect(message, group_name):
    Group(group_name).discard(message.reply_channel)
