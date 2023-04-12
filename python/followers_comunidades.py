# -*- coding: utf-8 -*-
"""
Created on Tue Apr 11 15:32:49 2023

@author: Jesi
"""

# import the module
import tweepy
import time
  
# assign the values accordingly
consumer_key = "BvdmECpOJxfxt5rjKmNV8gRKi"
consumer_secret = "tcNgxauZovnZZ1UawBIwnK7qbEU2aCDbe2U3EuYx2bAwL9BtZm"
access_token = "1025507591349329922-1ezXqBUFKSxURGc649vaVYVgxi0EbH"
access_token_secret = "jP8qj2AeW59co6okKwDXjbsLl6Y3oGdETODm7QwDOtLxv"
  
# authorization of consumer key and consumer secret
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
  
# set access to user's access key and access secret 
auth.set_access_token(access_token, access_token_secret)
  

# calling the api 
api = tweepy.API(auth, wait_on_rate_limit=True)

ids = ['WBDSLA', 'CabanaGcrf', 'FViaLibre', 
       'ildalatam', 'lasdesistemas', 'AIinclusive', 'CienciaAbiertaL',
       'ElGatoyLaCaja',
       'PyladiesEc', 'RLadiesBA', 'RLadiesCDMX', 'RLadiesSantiago']


"""
Me bloquea con el gato y la caja que tiene 117.000 seguidores, ildalatam


"""

sn = 'ildalatam'

dicts = {}
keys =ids


followers = []


backoff_counter = 1
while True:
    try:
        for page in tweepy.Cursor(api.get_followers, screen_name=sn,
                             count=200).pages():
           for user in page:
                name = user.screen_name
                # print(name)
                followers.append(name)
                break
    except tweepy.TweepError as e:
        print(e.reason)
        time.sleep(60*backoff_counter)
        backoff_counter += 1
        continue




        
dicts[sn] = followers








