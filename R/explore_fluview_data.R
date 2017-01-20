#######################################
## Exploratory Script for 2009 data
#######################################

library(tidyverse)
library(lubridate)
library(cowplot)


nat_ili <- read_csv("data/national/ILINet.csv", skip = 1)
nat_who <- read_csv("data/national/WHO_NREVSS_Combined_prior_to_2015_16.csv", skip = 1)
