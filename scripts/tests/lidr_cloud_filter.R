library(lidR)
library(terra)
library(sf)
library(tidyverse)

### Parameters ----

# date
date <- '2021-09-02'

# zone
z <- 3

# paths

# selected trees with inner buffer
path_trees <- 'data/clean/trees/trees_buffer_sel.geojson'

# Colorized point cloud for the data and zone
path_las <- 'E:/output/photogrammetry/metashape/2021-09-02-sbl-cloutier-z3-MS/2021-09-02-sbl-cloutier-z3-UTM18-nuage-highdisabled-MS.las'

# DSM to consider as the upper surface of the canopy (should stay the same for entire project)
path_dsm <- 'E:/output/photogrammetry/metashape/2021-09-02-sbl-cloutier-z3-MS/2021-09-02-sbl-cloutier-z3-UTM18-DEM-MS.tif'

# depth of canopy to keep (should remain constant for entire project)
depth_m <- 1


### Read data ----

# read the selected trees
trees <- read_sf(path_trees) %>% 
  filter(zone == z)

# read the point cloud
las <- readLAS(path_las)

# read the DSM
dsm <- rast(path_dsm)


### Data processing ----

# merge the las and the dsm
las_dsm <- merge_spatial(las, dsm, "Zdsm")

# only keep points within upper first meter of canopy
las_filt <- filter_poi(las_dsm, Z > Zdsm - depth_m)

# writeLAS(las_filt,
     #    "data/clean/clouds/2021-09-02-z3-cloud-1m.las")

# get average RGB per tree
names(las_filt)
trees_rgb <- polygon_metrics(las_filt, ~list(R = mean(R), G = mean(G), B = mean(B)), trees)

# add variables: date, Gcc, id
trees_calc <- trees_rgb %>% 
  cbind(trees$id) %>% 
  mutate(date = as.Date(date)) %>% 
  st_drop_geometry() %>% 
  as_tibble() %>% 
  select(id = trees.id, date, R, G, B)


### Save output ----
write_csv(trees_calc,
          file = paste0('data/clean/rgb/', date, '-z', z, '.csv'))

