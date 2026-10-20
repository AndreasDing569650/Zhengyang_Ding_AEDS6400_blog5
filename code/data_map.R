library(sf)
library(dplyr)

project_path <- ".."
data_path <- file.path(project_path, "data")
shapefile_folder <- file.path(
  data_path,
  "county_shapefile"
)

dir.create(
  shapefile_folder,
  recursive = TRUE,
  showWarnings = FALSE
)

county_url <- paste0(
  "https://www2.census.gov/geo/tiger/",
  "TIGER2024/COUNTY/tl_2024_us_county.zip"
)
zip_path <- file.path(
  data_path,
  "tl_2024_us_county.zip"
)

download.file(
  county_url,
  destfile = zip_path,
  mode = "wb"
)

unzip(
  zipfile = zip_path,
  exdir = shapefile_folder
)

shapefile_path <- file.path(
  shapefile_folder,
  "tl_2024_us_county.shp"
)

if (file.exists(shapefile_path)) {
  
  # Delete the ZIP file after successful extraction
  file.remove(zip_path)
  
  print("ZIP file deleted successfully.")
  
} else {
  
  stop(
    "Shapefile extraction failed. ZIP file was not deleted."
  )
}

county_map <- st_read(
  shapefile_path,
  quiet = TRUE
)

print(county_map)

print(names(county_map))

print(
  head(
    st_drop_geometry(county_map)
  )
)

county_map <- county_map %>%
  select(
    GEOID,
    NAME,
    STATEFP,
    COUNTYFP,
    geometry
  )

print(nrow(county_map))

plot(
  st_geometry(county_map)
)
