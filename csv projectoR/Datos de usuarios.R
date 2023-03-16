# Este código no me está funcionando. 
library(tidyverse)
library(readxl)

tweets1 <- read_xlsx("tweets_completos2.xlsx")
tweets2 <- read_xlsx("tweets_completos1.xlsx")

names(tweets1)
names(tweets2)

usuarios2 <- lookup_users(tweets1$screen_name)
usuarios1 <- lookup_users(tweets2$screen_name)

