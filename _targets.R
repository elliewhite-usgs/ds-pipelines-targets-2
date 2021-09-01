library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

site_nums <- c("01427207", "01432160", "01436690", "01466500")
p1_targets_list <- list(
  tar_target(site_data_1, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[1], ".csv")), format="file"),
  tar_target(site_data_2, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[2], ".csv")), format="file"),
  tar_target(site_data_3, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[3], ".csv")), format="file"),
  tar_target(site_data_4, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[4], ".csv")), format="file"), 
  tar_target(site_data, 
             combine_nwis_site_data(
               files_in = c(site_data_1, site_data_2, site_data_3, site_data_4), 
               file_out = "1_fetch/out/site_data_all.csv"), 
             format="file"),
  tar_target(site_info_csv, nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data_filein = site_data), format = "file")
)

p2_targets_list <- list(
  tar_target(site_data_clean, process_data(site_data)),
  tar_target(site_data_annotated, annotate_data(site_data_clean, site_filename = site_info_csv)),
  tar_target(site_data_styled, style_data(site_data_annotated))
)

p3_targets_list <- list(
  tar_target(figure_1_png, plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled), format = "file")
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
