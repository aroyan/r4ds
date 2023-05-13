library(tidyverse)

View(mpg)

# 
ggplot(data = mpg) +
  geom_point(mapping = aes(x  = displ, y = hwy, color = class)) +
  facet_wrap(~ class, nrow=2)

ggplot(data = mpg)

?mpg

# Highway per miles, Number of cylinders
ggplot(mpg) +
  geom_point(aes(hwy, cyl))

mpg$hwy

# Type of car, type of drive train (front wheel, rear wheel, 4wd)
ggplot(mpg) +
  geom_point(aes(class, drv))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# Exercises
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

?facet_wrap

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
  )

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# Highway per miles, Number of cylinders
ggplot(mpg) +
  geom_line(aes(hwy, cyl))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE, show.legend = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth()

## Will these two graphs looks different? My guess is not

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

## And yes, it's the same result

## Statistical Transformation #######################

?diamonds

ggplot(data = mpg) +
  geom_bar(mapping = aes(x = drv))

# Y axis from this bar chart is get from How many data that match with value from X axis
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  filter(cut == "Fair") %>% 
  nrow()

diamonds %>% 
  filter(cut == "Good") %>% 
  nrow()

diamonds %>% 
  filter(cut == "Ideal") %>% 
  nrow()

diamonds %>% 
  filter(cut == "Very Good") %>% 
  nrow()

?geom_bar

## Get summary of whole data frame
summary(diamonds)

## Get summary for specific variable
summary(diamonds$cut)

## You can recreate box plot like above using stat_count() function
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

? stat_bin
?stat_summary
?stat_smooth
?geom_pointrange

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

## with position = "jitter" adds a small amount of random noise to each point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

## Without position = "jitter" the plot is display only 126 points
## even though there is 234 observations
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

## this one is the same as line 182
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_count()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_boxplot()


## Coordinate systems ##################

## If the screen is to small, the x axis label will be overlapping each other
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

## With coord_flip() function it'll switch the coordinate so it'll be easier to read
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

nz <- map_data("world")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

## Good to read ########################
## https://r4ds.had.co.nz/data-visualisation.html#the-layered-grammar-of-graphics