library(tidyverse)

load("data/datos29.03.RData")
tweets1 <- searched_tweets
user_data1 = searched_tweets_user_data


load("data/datos01.04.RData")
tweets2 <- searched_tweets
user_data2 = searched_tweets_user_data

st <- readxl::read_xlsx("data/Tabla_tweets13.3.xlsx")
ut <- readxl::read_xlsx("data/Tabla_usuarios15.3.xlsx") %>% 
  select(or_screen_name = screen_name, 
         or_followers = followers_count, 
         or_favs = favourites_count, rt_screen_name = screen_name)

names(ut)
names(st)

tweets3 <- bind_cols(st, ut)

# Función para los searched_tweets
find_original_user_screen_name <- function(.df) {
  row_original_user_info <- .df[1, 'user'][1, c('screen_name', 'followers_count', 'favourites_count', 'location', 'description')]
  row_original_user_info <- row_original_user_info %>% rename(
    or_screen_name = screen_name,
    or_followers = followers_count,
    or_favs = favourites_count
  )
  
  return(row_original_user_info)
}




# store the extracted information of original tweets' users to a new variable
info_tweet_original1 <- tweets1$retweeted_status %>%
  map_dfr(find_original_user_screen_name)



tweets1 <- bind_cols(tweets1, info_tweet_original1)

info_tweet_original2 <- tweets2$retweeted_status %>%
  map_dfr(find_original_user_screen_name)

tweets2 <- bind_cols(tweets2, info_tweet_original2)

rt_user1 <- user_data1 %>% 
  select(
    screen_name
  ) %>% rename(
    rt_screen_name = screen_name
  )


rt_user2 <- user_data2 %>% 
  select(
    screen_name
  ) %>% rename(
    rt_screen_name = screen_name
  )


tweets1_completos <- dplyr::bind_cols(
  tweets1,
  rt_user1
) %>% 
  select(fecha = created_at, id_tw = id_str, text = full_text, retweet_count, favorite_count, lang,
         or_screen_name, or_followers, or_favs, rt_screen_name, location, description)




tweets2_completos <- dplyr::bind_cols(
  tweets2,
  rt_user2
)  %>% 
  select(fecha = created_at, id_tw = id_str, text = full_text, retweet_count, favorite_count, lang,
         or_screen_name, or_followers, or_favs, rt_screen_name, location, description)





tweets3 <- tweets3 %>% 
  select(fecha = created_at, id_tw = id_str, text = full_text, retweet_count, favorite_count, lang, 
         or_screen_name, or_followers, or_favs, rt_screen_name)


orig <- tweets3 %>% 
  filter(!str_detect(text, "^RT @")) %>% 
  select(id_tw, or_screen_name, or_followers, or_favs)

orig <- orig %>% 
  filter(!duplicated(orig))

orig2 <- orig %>% 
  select(or_screen_name:or_favs)

orig2 <- orig2 %>% 
  filter(!duplicated(orig2))


n_distinct(orig$id_tw)
nrow(orig)

tweets3 <- tweets3 %>% 
  mutate(or_screen_name = ifelse(str_detect(text, "^RT @"), str_match(text, "^RT @(.*?):\\s")[,2], or_screen_name),
         rt_screen_name = ifelse(!str_detect(text, "^RT @"), str_match(text, "^RT @(.*?):\\s")[,2], rt_screen_name),
         or_followers = ifelse(str_detect(text, "^RT @"), NA, or_followers),
         or_favs = ifelse(str_detect(text, "^RT @"), NA, or_favs))

names(tweets3)

tweets3 <- tweets3 %>% 
  select(-or_followers, -or_favs) %>% 
  left_join(orig2, by = "or_screen_name", multiple = "all") 



tweets_completos <- bind_rows(tweets1_completos, tweets2_completos, tweets3)

# Fechas 
tweets_completos %>%
  mutate(fecha = format(as.Date(fecha), "%m-%d")) %>% 
  ggplot(aes(x = fecha)) +
  geom_bar() + 
  coord_flip()


# Cantidad total
tweets_completos %>% 
  filter(!duplicated(tweets_completos)) %>% 
  filter(lang == "es") %>% 
  count()

# cantidad originales
tweets_completos %>% 
  filter(!duplicated(tweets_completos)) %>% 
  filter(!str_detect(text, "^RT @")) %>% 
  count()

# cantidad de retweets
tweets_completos %>% 
  filter(!duplicated(tweets_completos)) %>% 
  filter(str_detect(text, "^RT @")) %>% 
  count()

# Cantidad de cuentas que twittearon los tweets originales. 
n_distinct(tweets_completos$or_screen_name)

# Cantidad de cuentas que retwittearon
n_distinct(tweets_completos$rt_screen_name)



## filtro

filtro <- readxl::read_xlsx("data/cuentas.xlsx")

names(filtro)

filtro <- filtro %>% 
  select(screen_name, cuenta_comunidad, se_incluye) %>% 
  mutate(se_incluye = case_when(se_incluye == "1" ~ 1,
                                se_incluye == "?" ~ 0,
                                is.na(se_incluye) ~ 1,
                                se_incluye == "0" ~ 0)) %>%
  mutate(cuenta_comunidad = case_when(str_detect(screen_name, "chileconci3") ~ 1,
                                      str_detect(screen_name, "GobAbiertoCol") ~ 1,
                                      str_detect(screen_name, "MujeresEnII|ubuntuco") ~ 1,
                                      str_detect(screen_name, "FCird|desdewingu|MxExilio") ~ 0,
                                      is.na(cuenta_comunidad) ~ 0,
                                      cuenta_comunidad == "NO" ~ 0,
                                      cuenta_comunidad == "SI" ~ 1,
                                      TRUE ~ 1)) 


filtro %>% 
  count(se_incluye, cuenta_comunidad)

filtro <- filtro %>% 
  mutate(se_incluye = ifelse(cuenta_comunidad == 1, 1, se_incluye)) %>% 
  select(screen_name, cuenta_comunidad, se_incluye)

filtro_no <- filtro %>%  
  filter(se_incluye == 0) %>% 
  select(or_screen_name=screen_name, cuenta_comunidad)


filtro_si <- filtro %>%  
  filter(se_incluye == 1) %>% 
  select(or_screen_name=screen_name, cuenta_comunidad)


### Filtro para tweets nuevo
tweets1_filtrados <- tweets1_completos %>% 
  mutate(location = ifelse(is.na(location), " ", location)) %>% 
  mutate(description = ifelse(is.na(description), " ", description)) %>% 
  filter(!(str_detect(str_to_lower(description), "españa|cuenta oficial del ministerio") |
             str_detect(or_screen_name, "CNTI_VE|Edgar___es") |
                          str_detect(str_to_lower(description), "ministerio|cuenta oficial de la escuela|cuenta oficial de la comisión nacional|cuenta oficial del servicio de rentas|cuenta oficial de la secretaría|cuenta oficial de la subsecretaría") |
         str_detect(str_to_lower(location), "españa|barcelon|madrid|spain|valencia|sevilla|granada|mediterrànea|alicante|andalucía"))) 

tweets2_filtrados <- tweets2_completos %>% 
  mutate(location = ifelse(is.na(location), " ", location)) %>% 
  mutate(description = ifelse(is.na(description), " ", description)) %>% 
  filter(!(str_detect(str_to_lower(description), "españa|cuenta oficial del ministerio") |
             str_detect(or_screen_name, "CNTI_VE|Edgar___es") |
             str_detect(str_to_lower(description), "ministerio|cuenta oficial de la escuela|cuenta oficial de la comisión nacional|cuenta oficial del servicio de rentas|cuenta oficial de la secretaría|cuenta oficial de la subsecretaría") |
             str_detect(str_to_lower(location), "españa|barcelon|madrid|spain|valencia|sevilla|granada|mediterrànea|alicante|andalucía"))) 



nrow(tweets1_filtrados)
nrow(tweets2_filtrados)



#### 1. Filtrar tweets completos, 

tweets3_filtrados <- tweets3 %>% 
  left_join(filtro, by = c("or_screen_name" = "screen_name"), multiple = "all")


tweets3_filtrados <- tweets3_filtrados %>% 
  mutate(se_incluye = ifelse(is.na(se_incluye), 1, se_incluye)) %>% 
  mutate(cuenta_comunidad = ifelse(is.na(cuenta_comunidad), 0 , cuenta_comunidad)) %>% 
  filter(se_incluye == 1) %>% 
  filter(or_screen_name != "Edgar___es")

names(filtro_no)

tweets2_filtrados <- tweets2_filtrados %>% 
  left_join(filtro_no, by = "or_screen_name") 

tweets1_filtrados <- tweets1_filtrados %>% 
  left_join(filtro_no, by = "or_screen_name") 

## Identificar más cuentas
nodos_cuentas <- read_csv("data/nodes_seguidores.csv") %>% 
  filter(Comunidad == "Comunidad")


tweets2_filtrados <- tweets2_filtrados %>% 
  mutate(cuenta_comunidad = ifelse(or_screen_name %in% nodos_cuentas$Label, 1, cuenta_comunidad))

tweets2_filtrados <- tweets2_filtrados %>% 
  mutate(cuenta_comunidad = ifelse(is.na(cuenta_comunidad), 0, cuenta_comunidad))

tweets1_filtrados <- tweets1_filtrados %>% 
  mutate(cuenta_comunidad = ifelse(or_screen_name %in% nodos_cuentas$Label, 1, cuenta_comunidad))

tweets1_filtrados <- tweets1_filtrados %>% 
  mutate(cuenta_comunidad = ifelse(is.na(cuenta_comunidad), 0, cuenta_comunidad))


tweets_filtrados <- bind_rows(tweets1_filtrados, tweets2_filtrados, tweets3_filtrados)

# Cantidad total
tweets_filtrados %>% 
  filter(!duplicated(tweets_filtrados)) %>% 
  filter(lang == "es") %>% 
  count()

# cantidad originales
tweets_filtrados %>% 
  filter(!duplicated(tweets_filtrados)) %>% 
  filter(!str_detect(text, "^RT @")) %>% 
  count()

# cantidad de retweets
tweets_filtrados %>% 
  filter(!duplicated(tweets_filtrados)) %>% 
  filter(str_detect(text, "^RT @")) %>% 
  count()

# Cantidad de cuentas que twittearon los tweets originales. 
n_distinct(tweets_filtrados$or_screen_name)

# Cantidad de cuentas que retwittearon
n_distinct(tweets_filtrados$rt_screen_name)



### 2. ver si puedo completar los followers de la cuentas
#### de tweets 3 con los datos de las otras bases, 
edges_tw <- tweets_filtrados %>% 
  filter(str_detect(text, "^RT @")) %>% 
  select(source = rt_screen_name, target = or_screen_name)


followers <- read_csv("data/comunidades.csv")
names(followers)

followers <- followers %>% 
  mutate(target = ifelse(target == "karisma", "Karisma", target))

followers <- followers %>% 
  filter(!duplicated(followers))

cuentas_grafico <- data.frame(cuentas_unicas = unique(c(edges_tw$source, edges_tw$target)))

cu_tw <- tweets_filtrados %>% 
  filter(cuenta_comunidad == 1) %>% 
  select(or_screen_name)

cu_tw <- unique(cu_tw)

nodes1t <- cuentas_grafico %>% 
  mutate(sigue_comunidad = ifelse(cuentas_unicas %in% followers$source, 1, 0)) 


names(nodes1t)  

nodes1t <- nodes1t %>% 
  mutate(cuenta_comunidad = ifelse(cuentas_unicas %in% cu_tw$or_screen_name, 1, 0)) %>% 
  mutate(cuenta_comunidad = ifelse(cuentas_unicas %in% followers$target, 1, cuenta_comunidad)) %>% 
  filter(!cuentas_unicas %in% c("senacytgt", "Edgar__es", "CNTI_VE")) %>% 
  mutate(cuenta_comunidad = ifelse(str_detect(cuentas_unicas, "sibcolombia|AyudaMaestros|GeochicasOSM|socialtic|SinCadenasECU|datalat|TicEducativas|mapeoabierto_la|FlisolCABA"), 1, cuenta_comunidad)) %>% 
  mutate(cuenta_comunidad = ifelse(is.na(cuenta_comunidad), 0, cuenta_comunidad)) %>% 
  mutate(comunidad = case_when(cuenta_comunidad == 1 ~ "Es_comunidad",
                               cuenta_comunidad == 0 & sigue_comunidad == 1 ~"Sigue_comunidad",
                               cuenta_comunidad == 0 & sigue_comunidad == 0 ~"Sin_vinculos")) %>% 
  mutate(Id = cuentas_unicas,
         Label = cuentas_unicas,
         Comunidad = comunidad) %>% 
  mutate(Tweet_original = ifelse(cuentas_unicas %in% edges_tw$target, 1, 0)) %>% 
  select(Id, Label, Comunidad, Tweet_original)


nodes1t_f <- nodes1t %>% 
  filter(!duplicated(nodes1t))



sin_vinculos <- nodes1t_f %>% 
  filter(Comunidad == "Sin_vinculos")

Es_com <- nodes1t_f %>% 
  filter(Comunidad == "Es_comunidad")

sigue_com2 <- edges_tw %>% 
  mutate(sigue_com2 = ifelse(source %in% sin_vinculos$Label & target %in% Es_com$Label, "Sigue_comunidad", "Sin_vinculo")) %>% 
  filter(sigue_com2 == "Sigue_comunidad")


nodes1t_f <- nodes1t_f %>% 
  mutate(Comunidad = ifelse(Label %in% sigue_com2$source, "Sigue_comunidad", Comunidad)) %>% 
  mutate(Comunidad = ifelse(Label == "TicEducativas", "Es_comunidad", Comunidad))


edges_tw <- edges_tw %>% 
  filter(target != "senacytgt")

# write_csv(nodes1t_f, "datos/nodos_completos3.csv")
# write_csv(edges_tw, "datos/edges_completos3.csv")



lb <- nodes1t_f %>% 
  filter(Comunidad == "Es_comunidad") %>% 
  select(Label)
  

setdiff(followers$target, lb$Label)
unique(followers$target)
unique(lb$Label)

# promedio de retweets
edges_tw %>% 
  left_join(nodes1t_f, by = c("target" = "Label")) %>% 
  mutate(Comunidad = ifelse(Comunidad == "Sigue_comunidad", "Sin_vinculos", Comunidad)) %>% 
  group_by(Comunidad, target) %>% 
  summarise(n = n()) %>% 
  group_by(Comunidad) %>% 
  summarise(mean(n),
            median(n))

nodes1t_f %>% 
  count(Comunidad) 

## Proporcion de usuarios influyentes
edges_tw %>% 
  left_join(nodes1t_f, by = c("target" = "Label")) %>% 
  filter(!duplicated(edges_tw)) %>% 
  mutate(Comunidad = ifelse(Comunidad == "Sigue_comunidad", "Sin_vinculos", Comunidad)) %>%   count(Comunidad, target) %>% 
  arrange(desc(n)) %>% 
  ggplot(aes(n)) +
  geom_histogram()

edges_tw %>% 
  left_join(nodes1t_f, by = c("target" = "Label")) %>% 
  filter(!duplicated(edges_tw)) %>% 
  mutate(Comunidad = ifelse(Comunidad == "Sigue_comunidad", "Sin_vinculos", Comunidad)) %>% 
  count(Comunidad, target) %>% 
  filter(n >= 100) %>% 
  count(Comunidad)

nodes1t_f %>% 
  mutate(Comunidad = ifelse(Comunidad == "Sigue_comunidad", "Sin_vinculos", Comunidad)) %>%   count(Comunidad)


# Retweets de cuentas únicas

edges_tw %>% 
  left_join(nodes1t_f, by = c("target" = "Label")) %>% 
  filter(!duplicated(edges_tw)) %>% 
  mutate(Comunidad = ifelse(Comunidad == "Sigue_comunidad", "Sin_vinculos", Comunidad)) %>% 
  count(target, Comunidad) %>% 
  count(Comunidad)

