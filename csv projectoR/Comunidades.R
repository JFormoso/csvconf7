library(tidyverse)
library(tm)

tb <- readxl::read_xlsx("tablas_nuevas/cuentas.xlsx")
sw <- read.csv("https://raw.githubusercontent.com/JFormoso/stopwords-es/main/stopwords_es.csv", fileEncoding = "windows-1252")

#Create a vector containing only the text
text <- tb$description

# Create a corpus  
docs <- Corpus(VectorSource(text))

# Clean corpus
docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, sw$STOPWORD)


dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

df

writexl::write_xlsx(df, "palabras_descripcion.xlsx")

