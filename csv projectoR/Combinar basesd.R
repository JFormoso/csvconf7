
busquedas <- list()
busquedas12.3 <- list()

archivos <- list.files("Datos/")
archivos

for(i in 1:length(archivos)){
  
  if (str_detect(archivos[i], "12.3")) {
    
    tabla <- readxl::read_xlsx(str_c("Datos/",archivos[i]))
    tabla$archivo <- str_remove(archivos[i], ".xlsx")
    
    if (nrow(tabla != 0)){
      busquedas12.3[[i]] <- tabla
    }
    
  } else {
    
    tabla2 <- readxl::read_xlsx(str_c("Datos/",archivos[i]))
    tabla2$archivo <- str_remove(archivos[i], ".xlsx")
    
    if (nrow(tabla2 != 0)){
      busquedas[[i]] <- tabla2
    }
    
  }

}

tabla <- bind_rows(busquedas)
tabla %>%  view

writexl::write_xlsx(tabla, "Datos/tweets_completos12.3.xlsx")
