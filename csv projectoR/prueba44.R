library(rtweet)
library(tidyverse)

access_token = "1025507591349329922-ug61NKdsUdT8jV0zdHsRAZm47I3VaW"
access_secret = "kU08uY8r3R8TsculwKhesI6m3kXJYw8wc5NPLtQhOiloX"

rtweet_user(
  client_id = "c0hIOeul10UbWUHWKYAde3Uc8",
  client_secret = "HnRcrWqZ6xl1UwmkIBhnKdNoVZ7z9BuMrmMVvUBUaAnKhNbugl",
  api_key = client_id,
  api_secret = client_secret
)

rtweet_bot(api_key, api_secret, access_token, access_secret, app = "rtweet")

rtweet_app(bearer_token)

rtweet_oauth2(client = NULL, scopes = NULL)

tweets <- readxl::read_xlsx("tablas_nuevas/tabla_tweets13.3.xlsx")


get_followers(user = 1241762784502824965)
