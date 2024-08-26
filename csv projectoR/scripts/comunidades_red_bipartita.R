library(tidyverse)
library(igraph)

df <- read_csv("comunidades.csv")
head(df)

names(df) <- c("V1", "V2")

comunidades <- unique(df$V1)
df %>% 
  count(V1)


df <- df %>% 
  filter(!V2 %in% comunidades) %>% 
  filter(!is.na(V2))

df <- df %>% 
  filter(!duplicated(df))


# Crear la red
g <- graph_from_data_frame(df, directed=FALSE)

# bipartite.mapping(g)
bipartite_mapping(g)

# Indicarle que es bipartita
V(g)$type <- bipartite_mapping(g)$type


# Cambiar colores de comunidades y usuarios
V(g)$color <- ifelse(V(g)$type, "lightblue", "salmon")
V(g)$shape <- ifelse(V(g)$type, "circle", "square")
E(g)$color <- "lightgray"
V(g)$label.cex <- ifelse(V(g)$type, 0.001, 0.7)
V(g)$size <- ifelse(V(g)$type, 2, 7)



# ver que onda
plot(g, layout=layout.bipartite)

write_graph(simplify(g),  "bipartita.gml", format = "gml")# igraph y gephi


write_csv(df, "edges.csv")

df2 <- data.frame(nodes = c(unique(df$V1), unique(df$V2)),
                  rol = c(rep("Comunidad", length(unique(df$V1))), rep("Seguidor", length(unique(df$V2))))) 

write_csv(df2, "nodes.csv")


