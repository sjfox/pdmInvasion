require(tidyverse)
require(lubridate)

## First read in the csvs
nat_ili <- read_csv("data/national/ILINet.csv", skip = 1, na="X")
nat_who <- read_csv("data/national/WHO_NREVSS_Combined_prior_to_2015_16.csv", skip = 1, na="X")

reg_ili <- read_csv("data/regional/ILINet.csv", skip = 1, na=c("X", ""), col_types = cols(`AGE 25-49` = col_integer(),
                                                                                          `AGE 50-64` = col_integer()))
reg_who <- read_csv("data/regional/WHO_NREVSS_Combined_prior_to_2015_16.csv", skip = 1, na = "X")

## Specify the first reading day (each observation is one week addition to this day)
first_day <- dmy("03-10-1997")

## Setup dates for national and regional datasets
nat_ili$date <- seq(first_day, first_day + 7 * (nrow(nat_ili) - 1), by = "1 week")
nat_who$date <- seq(first_day, first_day + 7 * (nrow(nat_who) - 1), by = "1 week")

reg_ili$date <- rep(seq(first_day, first_day + 7*(nrow(reg_ili)/10 - 1), by = "1 week"), each = 10)
reg_who$date <- rep(seq(first_day, first_day + 7*(nrow(reg_who)/10 - 1), by = "1 week"), each = 10)

## Combine National and Regional ILI and WHO data all in one
nat_ili <- nat_ili %>% filter(date <= max(nat_who$date))
reg_ili <- reg_ili %>% filter(date <= max(reg_who$date))

ili <- bind_rows(nat_ili, reg_ili)
who <- bind_rows(nat_who, reg_who)

flu_data <- ili %>% left_join(who, by = c("date", "REGION"))

## Rename columns
flu_data <- flu_data %>% select(-YEAR.x, -WEEK.x, -(`REGION TYPE.y`:WEEK.y)) %>%
                            rename(region_type = `REGION TYPE.x`,
                                   region = REGION,
                                   weight_ili = `% WEIGHTED ILI`,
                                   unweight_ili = `%UNWEIGHTED ILI`,
                                   ili_age_0to4 = `AGE 0-4`,
                                   ili_age_25to49 = `AGE 25-49`,
                                   ili_age_25to64 = `AGE 25-64`,
                                   ili_age_5to24 = `AGE 5-24`,
                                   ili_age_50to64 = `AGE 50-64`,
                                   ili_age_65 = `AGE 65`,
                                   ili_total = ILITOTAL,
                                   num_providers = `NUM. OF PROVIDERS`,
                                   tot_patients = `TOTAL PATIENTS`,
                                   who_specimens = `TOTAL SPECIMENS`,
                                   who_per_pos = `PERCENT POSITIVE`,
                                   a_h1n1_2009 = `A (2009 H1N1)`,
                                   a_h1 = `A (H1)`,
                                   a_h3 = `A (H3)`,
                                   a_nosubtype = `A (Subtyping not Performed)`,
                                   a_unable = `A (Unable to Subtype)`,
                                   b = B,
                                   h3n2v = H3N2v)

rm(list=setdiff(ls(), "flu_data"))
