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
library(ggplot2)

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
write_csv(bqprm_k, file = here("data", "cleaned", "bqprm_k.csv"))
write_csv(bqprm_no3_n, file = here("data", "cleaned", "bqprm_no3_n.csv"))
write_csv(bqprm_mg, file = here("data", "cleaned", "bqprm_mg.csv"))
write_csv(bqprm_ca, file = here("data", "cleaned", "bqprm_ca.csv"))
write_csv(bqprm_nh4_n, file = here("data", "cleaned", "bqprm_nh4_n.csv"))

#..................plotting of Figure 3 replica..................

## hurricane date
hurricane_hugo <- as.Date("1989-09-18")

## plotting for all the nutrients
p_k <- ggplot(bqprm_k, aes(sample_date, rolling_average, linetype = sample_id)) +
  geom_line(size = 0.4) +
  geom_vline(xintercept = hurricane_hugo, linetype = "dashed", linewidth = 0.5) +
  scale_linetype_manual(values = c("solid","dotted","longdash","dotdash")) +
  scale_x_date(limits = as.Date(c("1988-01-01","1994-12-31")),
               breaks = seq(as.Date("1988-01-01"), 
                            as.Date("1994-12-31"), 
                            by = "year"),
               date_labels = "%Y") +
  labs(y = "K mg l^-1", x = NULL, linetype = NULL) +
  theme_classic(base_size = 10) +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5))

p_no3 <- ggplot(bqprm_no3_n, aes(sample_date, rolling_average, linetype = sample_id)) +
  geom_line(size = 0.4) +
  geom_vline(xintercept = hurricane_hugo, linetype = "dashed", linewidth = 0.5) +
  scale_linetype_manual(values = c("solid","dotted","longdash","dotdash")) +
  scale_x_date(limits = as.Date(c("1988-01-01","1994-12-31")),
               breaks = seq(as.Date("1988-01-01"), 
                            as.Date("1994-12-31"), 
                            by = "year"),
               date_labels = "%Y") +
  labs(y = "NO3-N ug l^-1", x = NULL, linetype = NULL) +
  theme_classic(base_size = 10) +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5))

p_mg <- ggplot(bqprm_mg, aes(sample_date, rolling_average, linetype = sample_id)) +
  geom_line(size = 0.4) +
  geom_vline(xintercept = hurricane_hugo, linetype = "dashed", linewidth = 0.5) +
  scale_linetype_manual(values = c("solid","dotted","longdash","dotdash")) +
  scale_x_date(limits = as.Date(c("1988-01-01","1994-12-31")),
               breaks = seq(as.Date("1988-01-01"), 
                            as.Date("1994-12-31"), 
                            by = "year"),
               date_labels = "%Y") +
  labs(y = "Mg mg l^-1", x = NULL, linetype = NULL) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5))

p_ca <- ggplot(bqprm_ca, aes(sample_date, rolling_average, linetype = sample_id)) +
  geom_line(size = 0.4) +
  geom_vline(xintercept = hurricane_hugo, linetype = "dashed", linewidth = 0.5) +
  scale_linetype_manual(values = c("solid","dotted","longdash","dotdash")) +
  scale_x_date(limits = as.Date(c("1988-01-01","1994-12-31")),
               breaks = seq(as.Date("1988-01-01"), 
                            as.Date("1994-12-31"), 
                            by = "year"),
               date_labels = "%Y") +
  labs(y = "Ca mg l^-1", x = NULL, linetype = NULL) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5))

p_nh4 <- ggplot(bqprm_nh4_n, aes(sample_date, rolling_average, linetype = sample_id)) +
  geom_line(size = 0.4) +
  geom_vline(xintercept = hurricane_hugo, linetype = "dashed", linewidth = 0.5) +
  scale_linetype_manual(values = c("solid","dotted","longdash","dotdash")) +
  scale_x_date(limits = as.Date(c("1988-01-01","1994-12-31")),
               breaks = seq(as.Date("1988-01-01"), 
                            as.Date("1994-12-31"), 
                            by = "year"),
               date_labels = "%Y") +
  labs(y = "NH4-N ug l^-1", x = "Years", linetype = NULL) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none") +
  theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5))

# stack and share legend
(p_k / p_no3 / p_mg / p_ca / p_nh4) + plot_layout(guides = "collect")

ggsave(here("figs", "fig3_replica_test0.png"))

