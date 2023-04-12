# -*- coding: utf-8 -*-
"""
Created on Sat Apr  8 14:08:45 2023

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
api = tweepy.API(auth)

ids = []

with open("D:/csvconf7/python/id_str.csv", 'r') as file:
  csv = csv.reader(file)
  for row in csv:
    ids.append(row)

  

"""

id_tweet = []
user_retweet = []
users_retweet = []

for i, row in enumerate(ids):
    try:
        id_tweet.append(ids[i][1])
        retweets_list = api.get_retweets(ids[i][1])
        for retweet in retweets_list:
            user_retweet.append(retweet.user.screen_name)
        users_retweet.append(user_retweet)
    except:
        print("error")
        
"""

retweets_list = api.get_retweets(ids[1][1])
for retweet in retweets_list:
    print(retweet.user.screen_name)


