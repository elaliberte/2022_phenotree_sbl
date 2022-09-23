library(tidyverse)
library(stars)

zone <- 3
ortho_path <- "E:/output/photogrammetry/metashape/2022-sbl-pheno/2022-05-06-sbl-pheno-z3-WGS84-P4RTK-MS/2022-05-06-sbl-pheno-z3-UTM18-P4RTK-MS-elevcorr.tif"

trees <- read_sf('data/clean/trees/trees.geojson') %>% 
  filter(zone == 3)

plot(trees['sp'])

trees_buffer <- trees %>% 
  st_buffer(-0.3)

plot(trees_buffer['sp'])

hull <- trees %>%
  st_geometry() %>% 
  st_union() %>% 
  st_convex_hull()
plot(hull, reset = F)
plot(trees, add = T)


ortho <- read_stars(ortho_path,
                    proxy = TRUE) %>% 
  st_crop(hull) %>% 
  st_warp(cellsize = 10,
          crs = st_crs(.))
plot(ortho, rgb = 1:3)

                    

ortho2 <- read_stars(ortho_path,
                    RasterIO = rasterio)
ortho2
image(ortho, rgb = 1:3)



          #          proxy = T)