library(sf)
library(tidyverse)

# deciduous species to select and keep
sp_sel <- c('ACPE',
            'ACRU',
            'ACSA',
            'BEAL',
            'BEPA',
            'BEPO',
            'FAGR',
            'FRNI',
            'LALA',
            'POBA',
            'POGR',
            'POTR',
            'PRPE',
            'QURU')


# read the trees from zone 1
z1_trees <- read_sf("data/raw/trees/z1_trees.geojson") %>% 
  select(sp = Label) %>% 
  filter(sp %in% sp_sel) %>% 
  mutate(zone = 1)

# plot them
plot(z1_trees['sp'])

# read the trees from zone 2

z2_trees <- read_sf("data/raw/trees/z2_trees.geojson") %>% 
  select(sp = Label) %>% 
  filter(sp %in% sp_sel) %>% 
  mutate(zone = 2)

# plot them
plot(z2_trees['sp'])

# read the trees from zone 3
z3_trees <- read_sf("data/raw/trees/z3_trees.geojson") %>% 
  select(sp = Label) %>% 
  filter(sp %in% sp_sel) %>% 
  mutate(zone = 3)

# plot them
plot(z3_trees['sp'])


# combine trees
trees <- rbind(z1_trees,
               z2_trees,
               z3_trees) %>%
  mutate(id = 1:nrow(.)) %>% 
  select(id, sp, zone)

plot(trees['sp'])

## save trees
write_sf(trees,
         "data/clean/trees/trees.geojson")
