seq(1, 10)

y <- seq(1, 10, length.out = 5)
y

## Like IIFE in JS
(y <- seq(1, 10, length.out = 5))

library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

# ALT + SHIFT + K -> See all shortcuts