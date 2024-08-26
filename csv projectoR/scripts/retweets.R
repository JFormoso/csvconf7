library(tidyverse)

nodos <- read_csv("data/nodos_completos.csv")
edges <- read_csv("data/edges_completos.csv")

n_distinct(edges$target)
n_distinct(nodos$Label)

nro_retweets <- edges %>% 
  count(target) %>% 
  arrange(desc(n))

nodos <- nodos %>% 
  filter(!(Label == "mapeoabierto_la" & Comunidad == "Sigue_comunidad"))

nrow(nodos)

nodos <- nodos %>% 
  left_join(nro_retweets, by = c("Label" = "target")) %>% 
  mutate(n = ifelse(is.na(n), 0, n))


# write_csv(nodos, "data/nodos_completos2.csv")

nro_retweets <- nro_retweets %>% 
  left_join(nodos, by = c("target" = "Label", "n"))

nro_retweets %>% 
  group_by(Comunidad) %>% 
  summarise(mean(n, na.rm = TRUE))

nro_retweets %>% 
  group_by(Comunidad) %>% 
  summarise(mean(Tweet_original))

edges2 <- edges %>% 
  filter(!duplicated(edges))

# write_csv(edges2, "data/edges_completos2.csv")

