# Data Transformation ##########################################################

library(nycflights13)
library(tidyverse)

glimpse(flights)

head(flights)
tail(flights)

nrow(flights)

?flights

## Filter rows =================================================================
filter(flights, month == 1, day == 1)

(dec25 <- filter(flights, month == 12, day == 25))

### Logical operator -----------------------------------------------------------
filter(flights, month == 11 | month == 12)

nov_dec <- filter(flights, month %in% c(12, 11))
nrow(nov_dec)

# !(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y
# https://r4ds.had.co.nz/transform.html#logical-operators
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

### Missing values (na) --------------------------------------------------------
x <- NA

is.na(x)

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)

filter(df, is.na(x) | x > 1)

### Exercises ------------------------------------------------------------------

# 1.1
arrival_delay_two_more <- filter(flights, arr_delay >= 120)
head(arrival_delay_two_more)

# 1.2
flew_to_houston <- filter(flights, dest == "IAH" | dest == "HOU")
glimpse(flew_to_houston)

# 1.3
## American Airlines == AA
## United Airlines == UA
## Delta Airlines == DL
operated_by_united_american_delta <- filter(flights, carrier %in% c("AA", "UA", "DL"))
glimpse(operated_by_united_american_delta)

ggplot(operated_by_united_american_delta) +
  geom_bar(mapping = aes(carrier, fill = carrier)) +
  labs(title = "Flights in 2013 operated by American, United, and Delta")

# 1.4
## Summer == July, August, September
summer <- c(7, 8, 9)
departed_in_summer <- filter(flights, month %in% summer)

# 1.5
# Arrived more than two hours late, but didn’t leave late
arrived_two_hours_late_but_depart_on_time <- filter(flights, dep_delay == 0 & arr_delay >= 120) 
View(arrived_two_hours_late_but_depart_on_time)

# 1.6
## Were delayed by at least an hour, but made up over 30 minutes in flight
## IDK what made up over 30 minutes in flight in this mean, so I assume that
## the arrival delay is less than 30 minutes
delayed_one_more_hour <- filter(flights, dep_delay >= 60 & arr_delay <= 30)
View(delayed_one_more_hour)

# 1.7
## Departed between midnight and 6am (inclusive)
departed_midnight_and_six_am <- filter(flights, dep_time %in% seq(600, 2400))

View(departed_midnight_and_six_am)
nrow(departed_midnight_and_six_am)
nrow(flights)

# 2
## Using between() function from dplyr to solve 1.7
nrow(filter(flights, between(dep_time, 600, 2400)))

# 3
## How many flights have a missing dep_time? What other variables are missing?
## What might these rows represent?

missing_dep_time <- filter(flights, is.na(dep_time) == TRUE)
View(missing_dep_time)

## Wow, the departure delay, arrival time, arrival delay, air time are missing too
## I guess the flights is canceled 


## Arrange =====================================================================
arrange(flights, year, month, day)

head(arrange(flights, desc(dep_delay)))
tail(arrange(flights, desc(dep_delay)))

# Missing values are always sorted at the end

df <- tibble(x = c(5, 2, NA))
arrange(df, desc(x))

### Exercises ==================================================================

# 1
## How could you use arrange() to sort all missing values to the start?
na_values_in_head <- arrange(flights, desc(is.na(dep_delay)))
head(na_values_in_head)
tail(na_values_in_head)

# 2
## Sort flights to find the most delayed flights.
## Find the flights that left earliest.

most_delayed <- arrange(flights, desc(dep_delay))
head(most_delayed)
