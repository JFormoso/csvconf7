# -*- coding: utf-8 -*-
"""
Created on Sat Apr  8 12:37:36 2023

@author: Jesi
"""


# pip3 install snscrape
# If you want to use the development version:
# pip3 install git+https://github.com/JustAnotherArchivist/snscrape.git

import pandas as pd
import snscrape.modules.twitter as twitter
"""
maxTweets = 10
tweets_ca = []
keyword='ciencia abierta'
for i, tweet in enumerate(twitter.TwitterSearchScraper(keyword + ' since:2021-11-01 until:2023-01-01 lang:"es" ').get_items()):
    try:
        tweets = {
                "Tweet" : "Reply",
                "tweet/reply id": "a"+str(tweet.id),
                "inReplyToTweetId": "a"+str(tweet.inReplyToTweetId),
                "conversationId": "a"+str(tweet.conversationId),
                "tweet.username" : tweet.username,
                "tweet.content" : tweet.content,
                "tweet.date" : tweet.date,
                "tweet.user.location" : tweet.user.location,
                "tweet.likeCount" : tweet.likeCount, 
                "tweet.replyCount" : tweet.replyCount,
                "tweet.retweetCount" : tweet.retweetCount,
                "tweet.user.followersCount" : tweet.user.followersCount,
                "tweet.user.description": tweet.user.description,
                "tweet.user.friendsCount": tweet.user.friendsCount,
                "tweet.user.statusesCount": tweet.user.statusesCount,
                "tweet.user.favouritesCount": tweet.user.favouritesCount,
                "tweet.user.listedCount": tweet.user.listedCount,
                "tweet.user.mediaCount": tweet.user.mediaCount,
                "tweet.url" : tweet.url
                }   
        tweets_ca.append(tweets)
    except:
        print("Algo pasó..")
"""

lista = []

scraper = twitter.TwitterTweetScraper('1603167708312309760')
for tweet in scraper.get_items():
    lista.append(tweet)
    
    