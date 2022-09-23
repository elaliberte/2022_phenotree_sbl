library(sf)
library(tidyverse)
library(units)

trees <- read_sf("data/clean/trees/trees.geojson")

# remove inner buffer of 25 from each tree
trees_buffer <- trees %>% 
  st_buffer(-0.25) %>% 
  filter(!st_is_empty(.)) %>% 
  st_cast("MULTIPOLYGON")

plot(trees_buffer['sp'])


# check tree areas
trees_buffer <- trees_buffer %>% 
  mutate(area = st_area(.))

areas <- trees_buffer %>% 
  st_drop_geometry()

areas_plot <- ggplot(areas, aes(x = area)) +
  geom_histogram() +
  facet_wrap(~sp)
areas_plot


# how many trees per species?
trees_n <- areas %>% 
  count(sp) %>% 
  arrange(desc(n))

# check areas of trees
trees_areas_stats <- areas %>% 
  group_by(sp) %>% 
  mutate(area_min = min(area),
         area_5 = quantile(area, 0.05),
         area_10 = quantile(area, 0.1),
         area_25 = quantile(area, 0.25))

# how many trees per species if areas >= 2 m2?
trees_n_2 <- areas %>% 
  filter(area >= as_units(2, 'm^2')) %>% 
  count(sp) %>% 
  arrange(desc(n))


# how many trees per species if areas >= 4 m2?
trees_n_4 <- areas %>% 
  filter(area >= as_units(4, 'm^2')) %>% 
  count(sp) %>% 
  arrange(desc(n))

# how many trees per species if areas >= 3 m2?
trees_n_3 <- areas %>% 
  filter(area >= as_units(3, 'm^2')) %>% 
  count(sp) %>% 
  arrange(desc(n))

trees_n_3

# select trees greater or equal to 3 m2 and remove species with fewer than 100 trees
trees_sel <- trees_buffer %>% 
  filter(area >= as_units(3, 'm^2'),
         !sp %in% c('POTR',
                    'FRNI',
                    'QURU',
                    'POBA',
                    'PRPE'))

# check n trees
trees_sel %>% 
  st_drop_geometry() %>% 
  count(sp) %>% 
  arrange(desc(n))

nrow(trees_sel) # 11 265 trees


## save selected trees with inner buffer
write_sf(trees_sel,
         "data/clean/trees/trees_buffer_sel.geojson")
