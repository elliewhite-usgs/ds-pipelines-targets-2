source("1_fetch/src/get_nwis_data.R")

site_nums <- c("01427207", "01432160", "01436690", "01466500")
p1_targets_list <- list(
  tar_target(site_data_1, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[1], ".csv")), format="file"),
  tar_target(site_data_2, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[2], ".csv")), format="file"),
  tar_target(site_data_3, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[3], ".csv")), format="file"),
  tar_target(site_data_4, download_nwis_site_data(paste0("1_fetch/tmp/site_data_", site_nums[4], ".csv")), format="file"), 
  tar_target(site_data, combine_nwis_site_data(files_in = c(site_data_1, site_data_2, site_data_3, site_data_4))),
  tar_target(site_info, nwis_site_info(site_data = site_data))
)