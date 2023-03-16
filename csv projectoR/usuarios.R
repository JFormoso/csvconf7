library(rtweet)
library(tidyverse)

tabla_tweets <- read_xlsx("Datos/accesibilidad_ciencia_15.2.xlsx")
users_data(tabla_tweets)
