library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

site_nums <- c("01427207", "01432160", "01435000", "01436690", "01466500")
p1_targets_list <- list(
  tar_target(site_data_1, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[1], ".csv")), format="file"),
  tar_target(site_data_2, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[2], ".csv")), format="file"),
  tar_target(site_data_3, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[3], ".csv")), format="file"),
  tar_target(site_data_4, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[4], ".csv")), format="file"),
  tar_target(site_data_5, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[5], ".csv")), format="file")
)

p2_targets_list <- list(
  tar_target(site_data_clean_1, process_data(site_data_1)),
  tar_target(site_data_clean_2, process_data(site_data_2)),
  tar_target(site_data_clean_3, process_data(site_data_3)),
  tar_target(site_data_clean_4, process_data(site_data_4)),
  tar_target(site_data_clean_5, process_data(site_data_5)),
  tar_target(site_data_annotated_1, annotate_data(site_data_clean_1, site_filename = site_info_csv_1)),
  tar_target(site_data_annotated_2, annotate_data(site_data_clean_2, site_filename = site_info_csv_2)),
  tar_target(site_data_annotated_3, annotate_data(site_data_clean_3, site_filename = site_info_csv_3)),
  tar_target(site_data_annotated_4, annotate_data(site_data_clean_4, site_filename = site_info_csv_4)),
  tar_target(site_data_annotated_5, annotate_data(site_data_clean_5, site_filename = site_info_csv_5)),
  tar_target(site_data_styled_1, style_data(site_data_annotated_1)),
  tar_target(site_data_styled_2, style_data(site_data_annotated_2)),
  tar_target(site_data_styled_3, style_data(site_data_annotated_3)),
  tar_target(site_data_styled_4, style_data(site_data_annotated_4)),
  tar_target(site_data_styled_5, style_data(site_data_annotated_5))
)

p3_targets_list <- list(
  tar_target(figure_1_1_png, plot_nwis_timeseries(fileout = "3_visualize/out/figure_1_1.png", site_data_styled_1), format = "file"), 
  tar_target(figure_1_2_png, plot_nwis_timeseries(fileout = "3_visualize/out/figure_1_2.png", site_data_styled_2), format = "file"),
  tar_target(figure_1_3_png, plot_nwis_timeseries(fileout = "3_visualize/out/figure_1_3.png", site_data_styled_3), format = "file"),
  tar_target(figure_1_4_png, plot_nwis_timeseries(fileout = "3_visualize/out/figure_1_4.png", site_data_styled_4), format = "file"),
  tar_target(figure_1_5_png, plot_nwis_timeseries(fileout = "3_visualize/out/figure_1_5.png", site_data_styled_5), format = "file")
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
