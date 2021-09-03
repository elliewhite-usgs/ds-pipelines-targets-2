process_data <- function(nwis_data){
  nwis_data_clean <- nwis_data %>% 
    rename(water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, -tz_cd)
  return(nwis_data_clean)
}

annotate_data <- function(site_data_clean, site_info, file_out){
  annotated_data <- left_join(site_data_clean, site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)
  write.csv(annotated_data, file_out, row.names = FALSE)
  return(file_out)
}


style_data <- function(site_data_annotated_file){
  site_data_annotated <- read.csv(site_data_annotated_file, colClasses = c("character", "factor", "character", rep("numeric", 3)))
  site_data_annotated$dateTime <- as.Date(site_data_annotated$dateTime, format = "%Y-%m-%dT%H:%M:%SZ")
  site_data_styled <- mutate(site_data_annotated, station_name = as.factor(station_name))
  return(site_data_styled)
}