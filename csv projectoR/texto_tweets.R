library(tidyverse)

tb <- readxl::read_xlsx("tablas_nuevas/tabla_tweets13.3.xlsx") 

tb %>% 
  filter(str_detect(str_to_lower(text), "metadocencia"))


tb %>% 
  filter(str_detect(str_to_lower(text), "rladies"))

tb %>% 
  filter(str_detect(str_to_lower(text), "flisol"))

tb %>% 
  filter(str_detect(str_to_lower(text), "red de ciencia abierta"))

tb %>% 
  filter(str_detect(str_to_lower(text), "hackbo"))

