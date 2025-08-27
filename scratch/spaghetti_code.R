##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Recreate the Visualization of the Study related to Hurricane effects on stream chemistry ----
##    Jay Kim                                                                                  ~~~~
##    wonyoungkim@ucsb.edu                                                                     
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
library(zoo)

moving_average <- function(focal_date, dates, concentration, win_size_wks) {
  
  # Which dates are in the window?
  is_in_window <- (dates > focal_date - (win_size_wks / 2) * 7) &
    (dates < focal_date + (win_size_wks / 2) * 7)
  
  # Find the associated concentration
  window_concentration <- concentration[is_in_window]
  
  # Calculate the mean
  result <- mean(window_concentration)
  
  return(result)
  
}

BQ1 <- read_csv(here("data", "QuebradaCuenca1-Bisley.csv")) %>% 
  clean_names()
BQ2 <- read_csv(here("data", "QuebradaCuenca2-Bisley.csv")) %>% 
  clean_names()
BQ3 <- read_csv(here("data", "QuebradaCuenca3-Bisley.csv")) %>% 
  clean_names()
prm <- read_csv(here("data", "RioMameyesPuenteRoto.csv")) %>% 
  clean_names()

BQ1_fig_3 <-  BQ1 %>% 
  mutate(weeks = lubridate::week(sample_date)) %>% 
  pivot_longer(cols = c("k", "no3_n", "mg", "ca", "nh4_n"),
               names_to = "nutrients", values_to = "concentration") %>% 
  select(sample_date, sample_id, nutrients, concentration, weeks) %>% 
  ungroup()

BQ2_fig_3 <-  BQ2 %>% 
  mutate(weeks = lubridate::week(sample_date)) %>% 
  pivot_longer(cols = c("k", "no3_n", "mg", "ca", "nh4_n"),
               names_to = "nutrients", values_to = "concentration") %>% 
  select(sample_date, sample_id, nutrients, concentration, weeks) %>% 
  ungroup()

BQ3_fig_3 <-  BQ3 %>% 
  mutate(weeks = lubridate::week(sample_date)) %>% 
  pivot_longer(cols = c("k", "no3_n", "mg", "ca", "nh4_n"),
               names_to = "nutrients", values_to = "concentration") %>% 
  select(sample_date, sample_id, nutrients, concentration, weeks) %>% 
  ungroup()

prm_fig_3 <-  prm %>% 
  mutate(weeks = lubridate::week(sample_date)) %>% 
  pivot_longer(cols = c("k", "no3_n", "mg", "ca", "nh4_n"),
               names_to = "nutrients", values_to = "concentration") %>% 
  select(sample_date, sample_id, nutrients, concentration, weeks) %>% 
  ungroup()

bqprm <- full_join(BQ1_fig_3, BQ2_fig_3) %>%
  full_join(BQ3_fig_3) %>%
  full_join(prm_fig_3) %>% 
  ungroup()
  # mutate(rolling_average = moving_average(focal_date, dates, concentration, win_size_wks))
