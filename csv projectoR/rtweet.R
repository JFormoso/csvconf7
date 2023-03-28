# Código horrible y muy poco eficiente, pero que funciona. 

library(rtweet)
library(tidyverse)

query = c("ciencia abierta", "cienciaabierta", "open science", "openscience",
          "ciência aberta", "ciênciaaberta", "open source", "opensource",
          "open access", "openaccess", "open research", "openresearch",
          "accesibilidad AND datos", "accesibilidad AND ciencia", "transparencia AND datos",
          "transparecia AND ciencia", "acceso libre AND ciencia", "investigación abierta ciencia",
          "código abierto", "códigoabierto", "pesquisa aberta", "pesquisaaberta",
          "códigoaberto", "código aberto", "acesso aberto", "acessoaberto",
          "technolatinas", "geochicas")

t <- list()
u <- list()

for(i in query){

  t[[i]] <- search_tweets(q = i, n = 18000, lang = "es", include_rts = TRUE, retryonratelimit = TRUE)
  u[[i]] <- users_data(t[[i]])
  
  
  
}

id <- lookup_users(users = "1564922322745712640")
tw <- lookup_tweets(statuses = "1564922322745712640")
names(tw)
view(tw)
names(id)
id$screen_name
id$followers_count
id$created_at
id$description

tabla_usuarios <- do.call("rbind", u)
tabla_usuarios
# writexl::write_xlsx(tabla_usuarios, "tablas_nuevas/Tabla_usuarios15.3.xlsx")

tabla_tweets <- do.call("rbind", t)
tabla_tweets$retweet_count
names(tabla_tweets)

# writexl::write_xlsx(tabla_tweets, "tablas_nuevas/Tabla_tweets13.3.xlsx")


## Tabla de influencia
lookup_tweets()

library(rtweet)

# tweet ID for example purposes
tweet_id <- "139000001234567890"

# get the tweet data
tweet <- get_tweet(tweet_id)

lookup_tweets(user_id)



# extract the user ID
user_id <- tweet$user_id

# print the user ID
print(user_id)

