library(httr)
library(jsonlite)
library(dplyr)
library(readr)
library(purrr)

api_key <- "0fb3ea034850ddaa1e3b39cf430736965e994518"

if (api_key == "YOUR_CENSUS_API_KEY") {
  stop("Please enter your Census API key.")
}

years <- c(2014, 2024)
get_income_data <- function(year) {
  url <- paste0(
    "https://api.census.gov/data/",
    year,
    "/acs/acs5"
  )
  response <- GET(
    url,
    query = list(
      get = "NAME,B19013_001E",
      `for` = "county:*",
      `in` = "state:*",
      key = api_key
    )
  )
  
  stop_for_status(response)
  
  result <- fromJSON(
    content(response, as = "text", encoding = "UTF-8")
  )
  data <- as.data.frame(
    result[-1, , drop = FALSE],
    stringsAsFactors = FALSE
  )
  names(data) <- result[1, ]
  data <- data %>%
    transmute(
      county_name = NAME,
      state_fips = state,
      county_fips = county,
      GEOID = paste0(state, county),
      median_income = as.numeric(B19013_001E),
      year = year
    )
  data$median_income[
    data$median_income == -666666666
  ] <- NA_real_
  return(data)
}

income_data <- map_dfr(years, get_income_data)

write_csv(
  income_data,
  "county_income_2014_2024.csv"
)

print(head(income_data))
print(
  income_data %>%
    group_by(year) %>%
    summarise(
      number_of_counties = n(),
      missing_income = sum(is.na(median_income)),
      .groups = "drop"
    )
)
print("Download completed.")