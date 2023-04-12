library(tidyverse)

base <- readxl::read_xlsx("tablas_nuevas/Tabla_tweets13.3.xlsx")

base %>% 
  count(text) %>% 
  filter(n > 1) %>% 
  arrange(desc(n))


base %>% 
  mutate(RT = ifelse(str_detect(text, "^RT @"), 1, 0)) %>% 
  mutate(text2 = str_remove(text, pattern = "^RT\\s@[a-zA-ZáéíóúÁÉÍÓÚüöÜÖ\\_]+:\\s")) %>% 
  select(text, text2)
