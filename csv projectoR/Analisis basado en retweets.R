library(tidyverse)
library(igraph)
library(rtweet)

# search term
# can be a hashtag (e.g., #microsoft), a mention (e.g., @nike), or a keyword (e.g., iphone)
search_term = '"ciencia abierta" OR "cienciaabierta" OR "open science" OR "openscience" OR
          "ciência aberta" OR "ciênciaaberta" OR "open source" OR "opensource" OR
          "open access" OR "openaccess" OR "open research" OR "openresearch" OR
          "investigación abierta ciencia" OR
          "código abierto" OR "códigoabierto" OR "pesquisa aberta" OR "pesquisaaberta" OR
          "códigoaberto" OR "código aberto" OR "acesso aberto" OR "acessoaberto"' 

# search tweets
# we specify lang = "en" to retrieve only English tweets
# include_rts must be TRUE since our network analysis uses retweets
searched_tweets <- search_tweets(
  search_term,
  n = 10000,
  include_rts = TRUE,
  parse = TRUE,
  lang = "es"
)


find_original_user_screen_name <- function(.df) {
  row_original_user_info <- .df[1, 'user'][1, c('name', 'screen_name',  'description', 'followers_count', 'friends_count', 'favourites_count')]
  row_original_user_info <- row_original_user_info %>% rename(
    original_tweet_user_name = name,
    original_tweet_user_screen_name = screen_name,
    original_tweet_user_description = description,
    original_tweet_user_followers_count = followers_count,
    original_tweet_user_friends_count = friends_count,
    original_tweet_user_favorites_count = favourites_count
  )
  
  return(row_original_user_info)
}


# store the extracted information of original tweets' users to a new variable
original_tweet_user_info <- searched_tweets$retweeted_status %>%
  map_dfr(find_original_user_screen_name)


searched_tweets2 <- searched_tweets %>%
  select(-any_of(colnames(original_tweet_user_info)))

searched_tweets2 <- dplyr::bind_cols(searched_tweets2, original_tweet_user_info)

searched_tweets_user_data = users_data(tweets = searched_tweets)

retweet_users_subset_columns <- searched_tweets_user_data %>% 
  select(
    name,
    screen_name
  ) %>% rename(
    retweet_user_name = name,
    retweet_user_screen_name = screen_name
  )

searched_tweets_with_users <- dplyr::bind_cols(
  searched_tweets2,
  retweet_users_subset_columns
)


retweet_subset_columns <- searched_tweets_with_users %>% 
  select(
    full_text,
    created_at,
    original_tweet_user_name,
    original_tweet_user_screen_name,
    original_tweet_user_description,
    original_tweet_user_followers_count,
    original_tweet_user_friends_count,
    original_tweet_user_favorites_count,
    retweet_user_name,
    retweet_user_screen_name
  ) %>%
  rename (
    retweeted_at = created_at
  )

retweet_subset_columns <- retweet_subset_columns %>%
  filter(!is.na(original_tweet_user_name))

# Network analysis
tweets <- retweet_subset_columns

edges <- tweets %>% 
  select(retweet_user_screen_name, original_tweet_user_screen_name) %>% 
  rename(
    from = retweet_user_screen_name,
    to = original_tweet_user_screen_name
  )

edges <- unnest(edges, cols=to)



graph <- graph_from_data_frame(edges, directed = TRUE)

deg <- degree(graph, mode = "in")

# sort by degree centrality in descending order
deg <- deg %>%
  sort(decreasing = TRUE)

gorder(graph)

deg

top100 <- deg[which(deg >= 10)]

df_top100 <- top100 %>%
  enframe(name = "screen_name", value="retweeted_count")

nodes <- data.frame(name = unique(c(edges$from, edges$to)))

nodes$inf <- ifelse(nodes$name %in% df_top100$screen_name, 1, 0)

nodes %>% 
  count(inf)


users_info <- tweets %>%
  select(
    original_tweet_user_name,
    original_tweet_user_screen_name,
    original_tweet_user_description,
    original_tweet_user_followers_count,
    original_tweet_user_friends_count,
    original_tweet_user_favorites_count,
  ) %>% 
  rename(
    name = original_tweet_user_name,
    screen_name = original_tweet_user_screen_name,
    description = original_tweet_user_description,
    followers_count = original_tweet_user_followers_count,
    friends_count = original_tweet_user_friends_count,
    favorites_count = original_tweet_user_favorites_count
  ) %>%
  distinct(screen_name, .keep_all = TRUE)

top100_details <- df_top100 %>%
  inner_join(users_info)

ggplot(
  data = head(top100_details, n = 21),
  aes(x = retweeted_count, y = reorder(screen_name, retweeted_count))
) +
  geom_col() +
  theme_classic() +
  xlab("Number of Retweets by Other Users") +
  ylab("User")

plot(
  graph,
  layout = layout_with_fr(graph),
  main="Retweets network graph of all nodes",
  vertex.size = 4,
  vertex.label = NA,
  edge.arrow.size = 0,
)

network <- graph_from_data_frame(d=edges, vertices=nodes, directed=F) 

coul  <- c("green", "red") 
size <- c(4, 8)

# Create a vector of color
my_color <- coul[as.numeric(as.factor(V(network)$inf))]
my_size <- size[as.numeric(as.factor(V(network)$inf))]

plot(
  network,
  layout = layout_with_fr(network),
  vertex.size = 4,
  vertex.label = NA,
  edge.arrow.size = 0,
  vertex.color = my_color
)



write_graph(simplify(network),  "network1_4.gml", format = "gml")# igraph y gephi

save.image("datos01.04.RData")
