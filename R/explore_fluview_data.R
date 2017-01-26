#######################################
## Exploratory Script for 2009 data
#######################################

library(tidyverse)
library(lubridate)
library(cowplot)


source("R/load_flu_data.R")


flu_data %>% filter(region_type == "National") %>%
  ggplot(aes(date, weight_ili)) + geom_line()

flu_data %>% filter(year(date) == 2009) %>%
  ggplot(aes(date, weight_ili)) + geom_line() + facet_wrap(~region)


flu_data %>% filter(year(date) == 2009, week(date) < 25, is.na(region)) %>%
  gather(key = flu_subtype, value = num_pos, a_h1n1_2009:h3n2v) %>%
  ggplot(aes(date, num_pos, color = flu_subtype)) + geom_line()


