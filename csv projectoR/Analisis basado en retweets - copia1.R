library(tidyverse)
library(igraph)

load("datos29.03.RData")

find_original_user_screen_name <- function(.df) {
  row_original_user_info <- .df[1, 'user'][1, c('name', 'screen_name', 'location', 'description', 'followers_count', 'friends_count', 'favourites_count')]
  row_original_user_info <- row_original_user_info %>% rename(
    original_tweet_user_name = name,
    original_tweet_user_screen_name = screen_name,
    original_tweet_user_description = description,
    original_tweet_user_location = location,
    original_tweet_user_followers_count = followers_count,
    original_tweet_user_friends_count = friends_count,
    original_tweet_user_favorites_count = favourites_count
  )
  
  return(row_original_user_info)
}



# 4419 tweets
searched_tweets29.03 <- searched_tweets

# store the extracted information of original tweets' users to a new variable
original_tweet_user_info2 <- searched_tweets29.03$retweeted_status %>%
  map_dfr(find_original_user_screen_name)


searched_tweets3 <- searched_tweets2 %>%
  select(-any_of(colnames(original_tweet_user_info2)))



searched_tweets3 <- dplyr::bind_cols(searched_tweets3, original_tweet_user_info2)

searched_tweets_user_data2 = searched_tweets_user_data

retweet_users_subset_columns2 <- searched_tweets_user_data2 %>% 
  select(
    name,
    screen_name
  ) %>% rename(
    retweet_user_name = name,
    retweet_user_screen_name = screen_name
  )

searched_tweets_with_users2 <- dplyr::bind_cols(
  searched_tweets3,
  retweet_users_subset_columns2
)


retweet_subset_columns2 <- searched_tweets_with_users2 %>% 
  select(
    full_text,
    created_at,
    original_tweet_user_name,
    original_tweet_user_screen_name,
    original_tweet_user_location,
    original_tweet_user_description,
    original_tweet_user_location,
    original_tweet_user_followers_count,
    original_tweet_user_friends_count,
    original_tweet_user_favorites_count,
    retweet_user_name,
    retweet_user_screen_name
  ) %>%
  rename (
    retweeted_at = created_at
  )

retweet_subset_columns2 <- retweet_subset_columns2 %>%
  filter(!is.na(original_tweet_user_name))

# Network analysis
tweets2 <- retweet_subset_columns2

#########################################################

load("datos01.04.RData")

# 4500
searched_tweets01.04 <- searched_tweets


# store the extracted information of original tweets' users to a new variable
original_tweet_user_info3 <- searched_tweets01.04$retweeted_status %>%
  map_dfr(find_original_user_screen_name)


searched_tweets4 <- searched_tweets2 %>%
  select(-any_of(colnames(original_tweet_user_info2)))

searched_tweets4 <- dplyr::bind_cols(searched_tweets4, original_tweet_user_info3)

searched_tweets_user_data2 = searched_tweets_user_data

retweet_users_subset_columns2 <- searched_tweets_user_data2 %>% 
  select(
    name,
    screen_name
  ) %>% rename(
    retweet_user_name = name,
    retweet_user_screen_name = screen_name
  )

searched_tweets_with_users2 <- dplyr::bind_cols(
  searched_tweets4,
  retweet_users_subset_columns2
)


retweet_subset_columns2 <- searched_tweets_with_users2 %>% 
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

retweet_subset_columns2 <- retweet_subset_columns2 %>%
  filter(!is.na(original_tweet_user_name))

tweets3 <- retweet_subset_columns2

#########################################################

tweets <- bind_rows(tweets2, tweets3)

user_info <- bind_rows(original_tweet_user_info2, original_tweet_user_info3)

n_distinct(user_info$original_tweet_user_name)
nrow(user_info)

tweets_filtrados <- tweets %>% 
  filter(!str_detect(str_to_lower(original_tweet_user_description), "españa|cuenta oficial del ministerio"),
         !str_detect(str_to_lower(original_tweet_user_description), "ministerio|cuenta oficial de la escuela|cuenta oficial de la comisión nacional|cuenta oficial del servicio de rentas|cuenta oficial de la secretaría|cuenta oficial de la subsecretaría"),
         !str_detect(str_to_lower(original_tweet_user_location), "españa|barcelon|madrid|spain|valencia|sevilla|granada|mediterrànea")) 


tweets_filtrados %>% 
  filter(str_detect(str_to_lower(original_tweet_user_description), "universidad")) %>% 
  select(original_tweet_user_description) %>% 
  view




#########################################################

edges <- tweets_filtrados %>% 
  select(retweet_user_screen_name, original_tweet_user_screen_name) %>% 
  rename(
    from = retweet_user_screen_name,
    to = original_tweet_user_screen_name
  )

edges <- unnest(edges, cols=to)



graph <- graph_from_data_frame(edges, directed = TRUE)

deg <- degree(graph, mode = "in")
deg2 <- degree(graph, mode = "out")

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


users_info <- tweets_filtrados %>%
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

edge.betweenness.community(network)
igraph::gsize(network) # number of edges



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



write_graph(simplify(network),  "network_completo.gml", format = "gml")# igraph y gephi

save.image("datos_completos.RData")

edges %>% 
  count(to) %>% 
  count()

edges %>% 
  count(from) %>% 
  count()
