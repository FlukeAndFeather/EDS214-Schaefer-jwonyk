
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                                      --
## THIS SCRIPT WILL CREATE DATA VISUALIZATION FROM OUR ANALYSIS AND SAVE IN FIGS FOLDE----
##                                                                                      --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Install & Load Packages

## May need to install the following packages
# install.packages("tidyverse")
# install.packages("janitor")
# install.packages("here")
# install.packages("lubridate")
# install.packages("ggplot2")
# install.packages("patchwork")
# install.packages("paletteer")

## Load in all necessary packages
library(tidyverse)
library(janitor)
library(here)
library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(patchwork)

## Assign cleaned data to the variable 
bqprm_k <- read_csv(here("data", "cleaned", "bqprm_k.csv"))
bqprm_no3_n <- read_csv(here("data", "cleaned", "bqprm_no3_n.csv"))
bqprm_mg <- read_csv(here("data", "cleaned", "bqprm_mg.csv"))
bqprm_ca <- read_csv(here("data", "cleaned", "bqprm_ca.csv"))
bqprm_nh4_n <- read_csv(here("data", "cleaned", "bqprm_nh4_n.csv"))

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

# Stack legend using patchwork
(p_k / p_no3 / p_mg / p_ca / p_nh4) + plot_layout(guides = "collect")

# Save
ggsave(here("figs", "fig3_replica.png"))