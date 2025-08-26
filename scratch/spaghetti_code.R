library(tidyverse)
library(janitor)
library(here)
library(tidyr)
library(dplyr)
library(lubridate)
library(usethis)
library(flowchart)
library(patchwork)
library(paletteer)

BQ1 <- read_csv(here("data", "QuebradaCuenca1-Bisley.csv"))
BQ2 <- read_csv(here("data", "QuebradaCuenca2-Bisley.csv"))
BQ3 <- read_csv(here("data", "QuebradaCuenca3-Bisley.csv"))
prm <- read_csv(here("data", "RioMameyesPuenteRoto.csv"))

BQ1_years <-  BQ1 %>% 
  mutate(year = lubridate::year(Sample_Date)) %>% 
  relocate(year, .after = Code) %>% 
  group_by(year) %>% 
  summarise(BQ1_K = mean(`K`, na.rm = TRUE), 
            BQ1_NO3_N = mean(`NO3-N`, na.rm = TRUE),
            BQ1_Mg = mean(`Mg`, na.rm = TRUE),
            BQ1_Ca = mean(`Ca`, na.rm = TRUE),
            BQ1_NH4_N = mean(`NH4-N`, na.rm = TRUE)) %>% 
  ungroup()

BQ2_years <-  BQ2 %>% 
  mutate(year = lubridate::year(Sample_Date)) %>% 
  relocate(year, .after = Code) %>% 
  group_by(year) %>% 
  summarise(BQ2_K = mean(`K`, na.rm = TRUE), 
            BQ2_NO3_N = mean(`NO3-N`, na.rm = TRUE),
            BQ2_Mg = mean(`Mg`, na.rm = TRUE),
            BQ2_Ca = mean(`Ca`, na.rm = TRUE),
            BQ2_NH4_N = mean(`NH4-N`, na.rm = TRUE)) %>% 
  ungroup()

BQ3_years <-  BQ3 %>% 
  mutate(year = lubridate::year(Sample_Date)) %>% 
  relocate(year, .after = Code) %>% 
  group_by(year) %>% 
  summarise(BQ3_K = mean(`K`, na.rm = TRUE), 
            BQ3_NO3_N = mean(`NO3-N`, na.rm = TRUE),
            BQ3_Mg = mean(`Mg`, na.rm = TRUE),
            BQ3_Ca = mean(`Ca`, na.rm = TRUE),
            BQ3_NH4_N = mean(`NH4-N`, na.rm = TRUE)) %>% 
  ungroup()

prm_years <-  prm %>% 
  mutate(year = lubridate::year(Sample_Date)) %>% 
  relocate(year, .after = Code) %>% 
  group_by(year) %>% 
  summarise(prm_K = mean(`K`, na.rm = TRUE), 
            prm_NO3_N = mean(`NO3-N`, na.rm = TRUE),
            prm_Mg = mean(`Mg`, na.rm = TRUE),
            prm_Ca = mean(`Ca`, na.rm = TRUE),
            prm_NH4_N = mean(`NH4-N`, na.rm = TRUE)) %>% 
  ungroup()

bqprm <- full_join(BQ1_years, BQ2_years) %>% 
  full_join(BQ3_years) %>% 
  full_join(prm_years)

k_join <- bqprm %>% 
  select(year, BQ1_K, BQ2_K, BQ3_K, prm_K)

no3_N_join <- bqprm %>% 
  select(year, BQ1_NO3_N, BQ2_NO3_N, BQ3_NO3_N, prm_NO3_N)

Mg_join <- bqprm %>% 
  select(year, BQ1_Mg, BQ2_Mg, BQ3_Mg, prm_Mg)

Ca_join <- bqprm %>% 
  select(year, BQ1_Ca, BQ2_Ca, BQ3_Ca, prm_Ca)

NH4_N_join <- bqprm %>% 
  select(year, BQ1_NH4_N, BQ2_NH4_N, BQ3_NH4_N, prm_NH4_N)

# No changes are made, just testing
