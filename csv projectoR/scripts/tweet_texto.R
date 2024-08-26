library(tidyverse)

load("data/datos29.03.RData")
tweets1 <- searched_tweets

tweets1$text[1]

load("data/datos01.04.RData")
tweets2 <- searched_tweets
names(tweets2)

st <- readxl::read_xlsx("data/Tabla_tweets13.3.xlsx")
ut <- readxl::read_xlsx("data/Tabla_usuarios15.3.xlsx") %>% 
  select(screen_name, followers_count)

tweets3 <- bind_cols(st, ut)

total <- bind_rows(tweets1, tweets2, tweets3)


names(total)


n_distinct(total$id_str)

original <- total %>% 
  filter(!str_detect(text, "^RT @"))

n_distinct(original$id_str)

n <- read_csv("data/nodos_completos.csv")

nrow(n)

n %>% 
  count(Tweet_original)

original_autores <- total %>% 
  filter(str_detect(text, "^RT @")) %>% 
  mutate(autor = str_match(text, "^RT @(.*?):\\s")[,2])


n_distinct(original_autores$autor)

n %>% 
  anti_join(original_autores, by = c("Label" = "autor")) %>% 
  count()


n_distinct(original$screen_name)

n_distinct(original_autores$autor)


n <- read_csv("data/nodos_completos2.csv")
ed <- read_csv("data/edges_completos.csv")

names(ed)
names(n)

ed %>% 
  right_join(n, by = c("target" = "Label")) %>% 
  count()

retweet_cuenta_unica <- ed %>% 
  filter(!duplicated(ed)) %>% 
  count(target)


# Hashtags

hash <- total %>% 
  mutate(CienciaAbierta = ifelse(str_detect(str_to_lower(text), pattern = "cienciaabierta|ciencia abierta"),1,0),
         OpenScience = ifelse(str_detect(str_to_lower(text), pattern = "openscience|open science"),1,0),
         AccesoAbierto = ifelse(str_detect(str_to_lower(text), pattern = "accesoabierto|acceso abierto"), 1, 0),
         OpenAccess = ifelse(str_detect(str_to_lower(text), pattern = "openaccess|open access"), 1, 0),
         CodigoAbierto = ifelse(str_detect(str_to_lower(text), pattern = "codigo abierto|codigoabierto|código abierto|códigoabierto"), 1, 0),
         OpenSource = ifelse(str_detect(str_to_lower(text), pattern = "open source|opensource"), 1, 0),
         OpenData = ifelse(str_detect(str_to_lower(text), pattern = "opendata|open data"), 1, 0),
         DatosAbiertos = ifelse(str_detect(str_to_lower(text), pattern = "datosabiertos|datos abiertos"), 1, 0),
         SoftwareLibre = ifelse(str_detect(str_to_lower(text), pattern = "softwarelibre|software libre"), 1, 0),
         CiênciaAberta = ifelse(str_detect(str_to_lower(text), pattern = "ciênciaaberta|ciência aberta"), 1, 0),
         CodigoAberto = ifelse(str_detect(str_to_lower(text), pattern = "codigo aberto|codigoaberto|código aberto|códigoaberto"), 1, 0),
         DadosAbertos = ifelse(str_detect(str_to_lower(text), pattern = "dadosabertos|dados abertos"), 1, 0))
  
library(wesanderson)

ggthemr::ggthemr("fresh")


hash %>% 
  summarise_if(is.numeric, .funs = list(sum)) %>% 
  pivot_longer(cols = CienciaAbierta:SoftwareLibre,
               names_to = "Query",
               values_to = "n") %>%
  arrange(n) %>%
  mutate(Query=factor(Query,levels = unique(Query),ordered = T)) %>%
  ggplot(aes(x = Query, y = n)) +
  geom_col(fill = "#00506F") +
  coord_flip() +
  labs(y = "Count", x = "") +
  theme(axis.text = element_text(color = "black"),
        axis.title = element_text(color = "black"),)

# ggsave("graficos/grafico_barras_terminos_de_busqueda.png", dpi = 300)
  



