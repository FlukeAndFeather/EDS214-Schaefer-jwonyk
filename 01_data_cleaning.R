##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            --
##------- THIS SCRIPT WILL CREATE SUBSET CSV FILES FOR OUR ANALYSIS.------------
##                                                                            --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Load in all necessary packages
library(tidyverse)
library(janitor)
library(here)
library(tidyr)
library(dplyr)
library(lubridate)

# Assign the data to the variable 

## Load and clean dataset from BQ1 to PRM
BQ1 <- read_csv(here("data", "raw", "QuebradaCuenca1-Bisley.csv")) %>% 
  clean_names()
BQ2 <- read_csv(here("data", "raw", "QuebradaCuenca2-Bisley.csv")) %>% 
  clean_names()
BQ3 <- read_csv(here("data", "raw", "QuebradaCuenca3-Bisley.csv")) %>% 
  clean_names()
prm <- read_csv(here("data", "raw", "RioMameyesPuenteRoto.csv")) %>% 
  clean_names()

## Call in the function from R folder to be used for data wrangling
source(here("R", "moving_average.R"))

# Data Cleaning

## Reshape BQ1 and PRM data to long format with weeks and nutrient concentrations
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

## Combine all datasets and calculate rolling averages for each nutrient
bqprm <- full_join(BQ1_fig_3, BQ2_fig_3) %>%
  full_join(BQ3_fig_3) %>%
  full_join(prm_fig_3) %>% 
  group_by(sample_id, nutrients) %>% 
  relocate(weeks, .after = sample_date) %>% 
  mutate(sample_id = as.factor(sample_id), nutrients = as.factor(nutrients)) %>% 
  mutate(rolling_average = sapply(as.Date(sample_date), moving_average, dates = as.Date(sample_date), concentration = concentration, win_size_wks = 9))

## Filter dataset for the selected nutrients and years between 1988 to 1995
bqprm_k <- bqprm %>% 
  filter(nutrients == "k") %>% 
  filter(between(lubridate::year(sample_date), 1988, 1995))
bqprm_no3_n <- bqprm %>% 
  filter(nutrients == "no3_n") %>% 
  filter(between(lubridate::year(sample_date), 1988, 1995))
bqprm_mg <- bqprm %>% 
  filter(nutrients == "mg") %>% 
  filter(between(lubridate::year(sample_date), 1988, 1995))
bqprm_ca <- bqprm %>% 
  filter(nutrients == "ca") %>% 
  filter(between(lubridate::year(sample_date), 1988, 1995))
bqprm_nh4_n <- bqprm %>% 
  filter(nutrients == "nh4_n") %>% 
  filter(between(lubridate::year(sample_date), 1988, 1995))

# Export Data
## Saving cleaned data frames to a new CSV to data folder (change as needed)
write_csv(bqprm_k, file = here("output", "cleaned", "bqprm_k.csv"))
write_csv(bqprm_no3_n, file = here("output", "cleaned", "bqprm_no3_n.csv"))
write_csv(bqprm_mg, file = here("output", "cleaned", "bqprm_mg.csv"))
write_csv(bqprm_ca, file = here("output", "cleaned", "bqprm_ca.csv"))
write_csv(bqprm_nh4_n, file = here("output", "cleaned", "bqprm_nh4_n.csv"))
