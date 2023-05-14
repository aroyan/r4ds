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

### Exercises ------------------------------------------------------------------

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
earliest_departure <- arrange(flights, dep_time)
head(earliest_departure)
tail(filter(earliest_departure, !is.na(dep_time)))

# 3
## Sort flights to find the fastest (highest speed) flights.

fastest <- arrange(flights, (air_time/60) / distance )
View(tail(filter(fastest, !is.na(air_time))))

# 4
## Which flights traveled the farthest? Which traveled the shortest?

farthest <- arrange(flights, desc(distance))
this_is_fastest <- head(farthest, 1)

shortest <- head(arrange(flights, distance), 1)

## Select ======================================================================

# Select cols with col name explicitly
select(flights, year, month, day)

# Select cols year to day
select(flights, year:day)

# Select all cols exclude year to day
colnames(select(flights, -(year:day)))

?select

rename(flights, hari = day)

# Rearrange cols using everything() function
select(flights, time_hour, air_time, everything())

### Exercises ------------------------------------------------------------------

# 1
## Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time,
## and arr_delay from flights.

select_challenge_one <- select(flights, dep_time, dep_delay, arr_time, arr_delay)
head(select_challenge_one)

# 2
## What happens if you include the name of a variable multiple times in a select() call?

head(select(flights, day, day))

## Show only once still, doesn't duplicate

# 3
## What does the any_of() function do? Why might it be helpful in conjunction with this vector?

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
head(select(flights, any_of(vars)))

## So it's kinda same like filter using %in% operator

# 4
## Does the result of running the following code surprise you?
## How do the select helpers deal with case by default?
## How can you change that default?

# This is case insensitive 
head(select(flights, contains("TiMe")))

# This is case sensitive
head(select(flights, contains("TIME", ignore.case = FALSE)))

## Add new variables / Mutation ================================================

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

View(flights_sml)

mutate(flights_sml, gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)

View(flights_sml)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# Only keep new created variables
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# %/% (integer division)
# %% (remainder)
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

(x <- 1:10)
lag(x)
lead(x)

x

cumsum(x)
cummean(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

### Exercises ------------------------------------------------------------------

# 1
## Currently dep_time and sched_dep_time are convenient to look at,
## but hard to compute with because they’re not really continuous numbers. 
## Convert them to a more convenient representation of number of minutes since midnight

new_flights <- select(flights, dep_time, sched_dep_time)
mutate(new_flights, dep_time_minutes = dep_time %/% 100 * 60 + dep_time %% 100,
       sched_dep_time_in_minutes = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100)

# 2
## Compare air_time with arr_time - dep_time. What do you expect to see?
## What do you see? What do you need to do to fix it?

flights %>% 
  select(air_time, arr_time, dep_time) %>% 
  mutate(actual_time = arr_time - dep_time)

## Well, you have to convert time format to minutes before
## calculating that arr time and dep time

convert_time_to_minutes_from_midnight <- function(your_time){
  x <- your_time %/% 100 * 60 + your_time %% 100
  return(x)
}

flights %>% 
  select(air_time, arr_time, dep_time) %>% 
  mutate(actual_time = convert_time_to_minutes_from_midnight(arr_time) -
           convert_time_to_minutes_from_midnight(dep_time))

# 3
## Compare dep_time, sched_dep_time, and dep_delay.
## How would you expect those three numbers to be related?

flights %>% 
  select(dep_time, sched_dep_time, dep_delay)

# You will get dep delay value by subtracting dep time and sched dep time

# 4
## Find the 10 most delayed flights using a ranking function.
## How do you want to handle ties? Carefully read the documentation for min_rank().

flights %>% 
  arrange(desc(dep_delay)) %>% 
  filter(!is.na(dep_delay)) %>% 
  head(10) %>% 
  select(dep_delay) %>% 
  min_rank()
  
## There is no tie values so I think I don't need to handle them? Just leave it as default

## Grouped summaries with summarise() ==========================================

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)

summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

by_dest <- group_by(flights, dest)

delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

### Missing values -------------------------------------------------------------

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

batters %>% 
  arrange(desc(ba))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled %>% 
  count(dest)

not_cancelled %>% 
  count(tailnum, wt = distance)  

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))

daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))

(per_month <- summarise(per_day, flights = sum(flights)))

(per_year  <- summarise(per_month, flights = sum(flights)))

daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights

### Exercises ------------------------------------------------------------------

?flights

# 1
## 
early_count <- nrow(filter(flights, dep_delay == -15))
late_count <- nrow(filter(flights, dep_delay == 15))

early_count_30 <- nrow(filter(flights, dep_delay == -30))
late_count_30 <- nrow(filter(flights, dep_delay == 30))

# 1.2 Flight always 10 minutes late
flights %>% 
  filter(dep_delay == 10)


total_flights <- nrow(flights)
on_time_count <- round(0.99 * total_flights)
late_count <- round(0.01 * total_flights)

total_flights == on_time_count + late_count

# 2
not_cancelled %>%
  count(dest) 

not_cancelled %>%
  count(tailnum, wt = distance)
