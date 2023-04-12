# -*- coding: utf-8 -*-
"""
Created on Tue Apr 11 15:32:49 2023

@author: Jesi
"""

# import the module
import tweepy
import csv
  
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

ids = []

with open("D:/csvconf7/python/nodes.csv", 'r') as file:
  csv = csv.reader(file)
  for row in csv:
    ids.append(row[0])
    
print(ids.pop(0))
    
dicts = {}
keys =ids


for i, screen_name in enumerate(keys[0:2]):
        
    following = []

    for page in tweepy.Cursor(api.get_friends, screen_name=screen_name,
                          count=200).pages(10):
        for user in page:
            name = user.screen_name
            # print(name)
            following.append(name)
    
    dicts[screen_name] = following




