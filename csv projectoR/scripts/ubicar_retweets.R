library(tidyverse)

base <- readxl::read_xlsx("data/Tabla_tweets13.3.xlsx")
base2 <- readxl::read_xlsx("data/Tabla_usuarios15.3.xlsx")

base %>% 
  count(text) %>% 
  filter(n > 1) %>% 
  arrange(desc(n))


base %>% 
  mutate(RT = ifelse(str_detect(text, "^RT @"), 1, 0)) %>% 
  mutate(text2 = str_remove(text, pattern = "^RT\\s@[a-zA-ZáéíóúÁÉÍÓÚüöÜÖ\\_]+:\\s")) %>% 
  select(text, text2)

names(base2)

base$retweet_user_screen_name = base2$screen_name  

base <- base %>% 
  filter(str_detect(text, "^RT @"))  
  

base$original_tweet_user_screen_name = str_match(base$text, "^RT\\s@(.*?):\\s")[,2]
  
base3 <- base %>% 
  select(from = retweet_user_screen_name, to = original_tweet_user_screen_name)


filtro <- readxl::read_xlsx("data/cuentas.xlsx")

names(filtro)

filtro <- filtro %>% 
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
  select(to=screen_name, cuenta_comunidad)


filtro_si <- filtro %>%  
  filter(se_incluye == 1) %>% 
  select(to=screen_name, cuenta_comunidad)



filtro_si %>% 
  count(cuenta_comunidad)



tweets_sin_cuentas <- base3 %>% 
  right_join(filtro_si, by = "to") %>% 
  filter(!is.na(to), !is.na(from))

tweets_sin_cuentas %>% 
  count(cuenta_comunidad)

followers <- read_csv("data/comunidades.csv")

cuentas_grafico <- data.frame(cuentas_unicas = unique(c(tweets_sin_cuentas$from, tweets_sin_cuentas$to)))

nodes2 <- cuentas_grafico %>% 
  mutate(sigue_comunidad = ifelse(cuentas_unicas %in% followers$seguidores, 1, 0)) 

names(nodes2)

nodes2 <- nodes2 %>% 
  left_join(filtro, by = c("cuentas_unicas" = "screen_name")) %>%
  mutate(cuenta_comunidad = ifelse(cuentas_unicas %in% followers$comunidad, 1, cuenta_comunidad)) %>% 
  mutate(cuenta_comunidad = ifelse(is.na(cuenta_comunidad), 0, cuenta_comunidad)) %>% 
  mutate(comunidad = case_when(cuenta_comunidad == 1 ~ "Es_comunidad",
                               cuenta_comunidad == 0 & sigue_comunidad == 1 ~"Sigue_comunidad",
                               cuenta_comunidad == 0 & sigue_comunidad == 0 ~"Sin_vinculos")) %>% 
  mutate(Id = cuentas_unicas,
         Label = cuentas_unicas,
         Comunidad = comunidad) %>% 
  mutate(Tweet_original = ifelse(cuentas_unicas %in% tweets_sin_cuentas$to, 1, 0)) %>% 
  select(Id, Label, Comunidad, Tweet_original)


names(nodes2)

# write_csv(nodes, "data/nodes_gephi.csv")

