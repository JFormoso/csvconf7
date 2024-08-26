# -*- coding: utf-8 -*-
"""
Created on Tue Apr 11 15:32:49 2023

@author: Jesi
"""

# import the module
import tweepy
import time

  
# assign the values accordingly
consumer_key = "U2VUelplQUNDNkg4MHVlZmFNMFo6MTpjaQ"
consumer_secret = "-x_7DHsKIblA6VBv4Cjqa1QY96wbDm6r2Bw1tqkd4k9XUNVHSf"
access_token = "2276200944-MEsBFk0EtCmOrpL0Bzq3kwRfi87aCMymL8IiZI4"
access_token_secret = "B0jfwzY9i4dRp3osvaLbfih8BBDrvJfJyWa60rtHA25Wr"
  



# authorization of consumer key and consumer secret
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
  
# set access to user's access key and access secret 
auth.set_access_token(access_token, access_token_secret)
  

# calling the api 
api = tweepy.API(auth, wait_on_rate_limit=True)

ids = ['WBDSLA','ildalatam', 'lasdesistemas', 'AIinclusive', 'CienciaAbiertaL',
       'ElGatoyLaCaja', 'PyladiesEc', 'RLadiesBA', 'RLadiesCDMX', 'RLadiesSantiago']


"""
Me bloquea con el gato y la caja que tiene 117.000 seguidores, ildalatam


"""


sn = 'ildalatam'

dicts = {}
keys =ids


followers = []

for page in tweepy.Cursor(api.get_followers, screen_name=sn,
                    count=200).pages():
    try:
        for user in page:
            name = user.screen_name
            print(name)
            followers.append(name)

    except tweepy.errors.TweepyException as e:
        time.sleep(60*1)

        
dicts[sn] = followers


"""

def get_followers(api,user_name):
    print(f'Getting followers from {user_name}')
    followers = []
    for page in tweepy.Cursor(api.get_followers, screen_name=user_name,count=200).pages():
        try:
            followers.extend(page)
        except tweepy.errors.TweepyException as e:
            print(f'Waiting {60}s for limit:', e)
            time.sleep(60)
    return followers

followers = get_followers(api, sn)
"""


