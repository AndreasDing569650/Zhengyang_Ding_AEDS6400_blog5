library(sf)
library(dplyr)
library(readr)
library(ggplot2)

project_path <- ".."
data_path <- file.path(project_path, "data")
shapefile_path <- file.path(
  data_path,
  "county_shapefile",
  "tl_2024_us_county.shp"
)
figure_path <- file.path(project_path, "figure")

income_path <- file.path(
  data_path,
  "county_income_2014_2024.csv"
)

income_data <- read_csv(income_path)
print(head(income_data))
print(str(income_data))

county_map <- st_read(
  shapefile_path,
  quiet = TRUE
)
print(county_map)
print(names(county_map))

income_data <- income_data %>%
  mutate(
    GEOID = as.character(GEOID)
  )
county_map <- county_map %>%
  mutate(
    GEOID = as.character(GEOID)
  )
print(head(income_data$GEOID))
print(head(county_map$GEOID))

county_map <- county_map %>%
  filter(
    STATEFP %in% sprintf("%02d", 1:56)
  )

# Merge income data with geographic data

income_map <- county_map %>%
  left_join(
    income_data,
    by = "GEOID"
  )
print(income_map)
merge_check <- income_map %>%
  st_drop_geometry() %>%
  group_by(year) %>%
  summarise(
    total_counties = n(),
    missing_income = sum(is.na(median_income)),
    .groups = "drop"
  )
print(merge_check)

income_map <- income_map %>%
  group_by(year) %>%
  mutate(
    income_quintile = ntile(
      median_income,
      5
    )
  ) %>%
  ungroup()
income_map <- income_map %>%
  mutate(
    income_group = case_when(
      income_quintile == 1 ~ "Lowest 20%",
      income_quintile == 2 ~ "20–40%",
      income_quintile == 3 ~ "40–60%",
      income_quintile == 4 ~ "60–80%",
      income_quintile == 5 ~ "Highest 20%",
      TRUE ~ NA_character_
    )
  )
income_map$income_group <- factor(
  income_map$income_group,
  levels = c(
    "Lowest 20%",
    "20–40%",
    "40–60%",
    "60–80%",
    "Highest 20%"
  )
)

dir.create(
  figure_path,
  recursive = TRUE,
  showWarnings = FALSE
)
county_map_contiguous <- income_map %>%
  filter(
    !STATEFP %in% c(
      "02",   # Alaska
      "15",   # Hawaii
      "60",   # American Samoa
      "66",   # Guam
      "69",   # Northern Mariana Islands
      "72",   # Puerto Rico
      "78"    # U.S. Virgin Islands
    )
  )

# Map: 2024 Median Household Income

map_2024 <- county_map_contiguous %>%
  filter(year == 2024)

plot_2024_income <- ggplot(map_2024) +
  geom_sf(
    aes(fill = median_income),
    color = NA
  ) +
  coord_sf(
    xlim = c(-125, -66),
    ylim = c(24, 50),
    expand = FALSE
  ) +
  labs(
    title = "Median Household Income by County, 2024",
    fill = "Median Household\nIncome ($)"
  ) +
  theme_void() +
  theme(
    plot.background = element_rect(
      fill = "white",
      color = NA
    ),
    panel.background = element_rect(
      fill = "white",
      color = NA
    ),
    plot.title = element_text(
      size = 20,
      face = "bold",
      hjust = 0.5
    ),
    legend.title = element_text(
      size = 12
    ),
    legend.text = element_text(
      size = 10
    ),
    legend.position = "right"
  )

print(plot_2024_income)

ggsave(
  filename = file.path(
    figure_path,
    "income_map_2024.png"
  ),
  plot = plot_2024_income,
  width = 12,
  height = 9,
  dpi = 300
)

# Map: Relative Income Distribution, 2014

map_2014 <- county_map_contiguous %>%
  filter(year == 2014)

plot_2014_income <- ggplot(map_2014) +
  geom_sf(
    aes(fill = income_group),
    color = NA
  ) +
  coord_sf(
    xlim = c(-125, -66),
    ylim = c(24, 50),
    expand = FALSE
  ) +
  labs(
    title = "Relative Income Distribution Across U.S. Counties, 2014",
    fill = "Income Group"
  ) +
  theme_void() +
  theme(
    plot.background = element_rect(
      fill = "white",
      color = NA
    ),
    panel.background = element_rect(
      fill = "white",
      color = NA
    ),
    plot.title = element_text(
      size = 20,
      face = "bold",
      hjust = 0.5
    ),
    legend.title = element_text(
      size = 12
    ),
    legend.text = element_text(
      size = 10
    ),
    legend.position = "right"
  )

print(plot_2014_income)

ggsave(
  filename = file.path(
    figure_path,
    "income_quintile_map_2014.png"
  ),
  plot = plot_2014_income,
  width = 12,
  height = 9,
  dpi = 300
)

# Map: Relative Income Distribution, 2024

plot_2024_quintile <- ggplot(map_2024) +
  geom_sf(
    aes(fill = income_group),
    color = NA
  ) +
  coord_sf(
    xlim = c(-125, -66),
    ylim = c(24, 50),
    expand = FALSE
  ) +
  labs(
    title = "Relative Income Distribution Across U.S. Counties, 2024",
    fill = "Income Group"
  ) +
  theme_void() +
  theme(
    plot.background = element_rect(
      fill = "white",
      color = NA
    ),
    panel.background = element_rect(
      fill = "white",
      color = NA
    ),
    plot.title = element_text(
      size = 20,
      face = "bold",
      hjust = 0.5
    ),
    legend.title = element_text(
      size = 12
    ),
    legend.text = element_text(
      size = 10
    ),
    legend.position = "right"
  )

print(plot_2024_quintile)

ggsave(
  filename = file.path(
    figure_path,
    "income_quintile_map_2024.png"
  ),
  plot = plot_2024_quintile,
  width = 12,
  height = 9,
  dpi = 300
)
