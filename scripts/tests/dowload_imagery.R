library(devtools)
devtools::install_github("stenevang/sftp")
library(sftp)
library(tidyverse)

# Store your username and passwords in system environment variables
Sys.setenv("MY_SFTP_USER" = 'username')
Sys.setenv("MY_SFTP_PASS" = 'password')

url = "lefodata-irbv.irbv.umontreal.ca"
parent_folder <- '/data/metashape/2022-sbl-pheno'


### 2022-05-06 ----
date <- "2022-05-06"
new_folder <- "data/raw/orthos/2022-05-06"
dir.create(new_folder)

# zone 1
zone <- "z1"
folder <- "/2022-05-06-sbl-pheno-z1-WGS84-P4RTK-MS"
file <- "2022-05-06-sbl-pheno-z1-UTM18-P4RTK-MS-elevcorr.tif"

sftp_con <- sftp_connect(server = url,
                         folder = paste0(parent_folder, folder),
                         username = Sys.getenv("MY_SFTP_USER"),
                         password = Sys.getenv("MY_SFTP_PASS"),
                         protocol = "sftp://",
                         port = 22,
                         timeout = 60)
sftp_download(file,
              tofolder = new_folder)
file.rename(paste0(new_folder, '/', file),
            paste0(new_folder, '/', date, '-ortho-', zone, '.tif'))
