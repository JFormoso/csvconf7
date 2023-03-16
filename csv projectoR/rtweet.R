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


tabla_usuarios <- do.call("rbind", u)
tabla_usuarios
# writexl::write_xlsx(tabla_usuarios, "tablas_nuevas/Tabla_usuarios15.3.xlsx")

tabla_tweets <- do.call("rbind", t)
tabla_tweets
# writexl::write_xlsx(tabla_tweets, "tablas_nuevas/Tabla_tweets13.3.xlsx")
