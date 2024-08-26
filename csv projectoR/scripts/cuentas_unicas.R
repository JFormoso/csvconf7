library(tidyverse)

tb <- readxl::read_xlsx("tablas_nuevas/Tabla_usuarios15.3.xlsx")
n_distinct(tb$name)

unicos <- tb %>%
  filter(!duplicated(name)) 

sum(unicos$statuses_count)

view(unicos)

unicos2 <- unicos %>%
  mutate(cuenta_comunidad = "",
         se_incluye = ifelse(str_detect(str_to_lower(description), "cuenta oficial|^facultad|^ministerio|^universidad|^secretaría|^gobierno|^subsecretaría|^vicerrectoría|^rectoría|^biblioteca |^editorial|^instituto|^laboratorio") |
                               str_detect(str_to_lower(location), "madrid|españa|spain|segovia|sevilla|granada|barcelona|valéncia|valencia"), 0, 1)) %>%
  select(id, name, screen_name, location, description, cuenta_comunidad, se_incluye, followers_count, statuses_count, created_at)

writexl::write_xlsx(unicos2, "tablas_nuevas/cuentas.xlsx")

