library(tidyverse)

df <- readxl::read_xlsx("Tablas_nuevas/followers_comunidad.xlsx")
df <- df %>% 
  separate_rows(seguidores, sep = ",")

df$seguidores <- str_remove_all(df$seguidores, "\\'|\\s")

df %>% 
  filter(seguidores == "WBDSLA")

write_csv(df, "C:/Users/Jesi/Desktop/Bipartite Networks in igraph/comunidades.csv")
