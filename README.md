# AEDS 6400 Blog Post 5: The Geography of U.S. Income Distribution: A Decade of Sticky Divides

## Project Intro

This repository contains the data pipeline and visualization code for an analysis of U.S. county-level income distribution. The project investigates the spatial concentration of high- and low-income communities across the United States and evaluates whether these geographic divides have hardened over the past decade. The unit of analysis is the U.S. County (or county-equivalents). Counties serve as the fundamental administrative building blocks of local economies, providing a granular geographic resolution that captures the divergence between urban cores, suburban peripheries, and rural areas better than state-level data.

## Data and Method

Income Data: The source is U.S. Census Bureau, American Community Survey (ACS), with the variable of Median Household Income (B19013_001E). Data is retrieved programmatically using the Census Bureau API.
Estimate Type: 5-year estimates (e.g., 2020-2024). 5-year estimates are utilized instead of 1-year estimates because they provide complete geographic coverage for all U.S. counties, including those with populations below the 65,000 threshold required for 1-year data. This ensures a continuous and comparable national map.
Relative Income Transformation: Because nominal income levels change over time due to inflation, comparing absolute dollar amounts across a decade can be misleading. To measure relative economic standing, we rank all counties nationally in each year and assign them into Quintiles (Relative Percentiles): Lowest 20%; 20–40%; 40–60%; 60–80%; and Highest 20%.

Geospatial Data: U.S. Census Bureau TIGER/Line Shapefiles (county boundaries), conducted in R. It is merged with the income variable data.

## Analytical Logic

The analysis is structured in two steps:

1. We map the 2024 relative income quintiles to identify current spatial patterns (e.g., coastal clustering vs. Southern contiguous blocks). To validate that this relative ranking reflects real-world wealth gaps, we supplement this with an absolute income map (Median Household Income in USD) for the same year.

2. We compare the 2024 relative distribution map with the 2014 map. By holding the relative metric constant across the decade, we can isolate shifts in spatial inequality—observing whether middle-income counties are slipping, whether high-income clusters are expanding, and whether the geographic structure of poverty remains structurally sticky.

## Repository Structure

Note: The SHP spatial data file of county shapes is beyond 25mb, thus cannot be uploaded to GitHub. The structure below still includes the file, forming a complete structure. One can always download the data with the code I uploaded.

```text
Zhengyang_Ding_AEDS6400_blog5/
│
├── code/
│   ├── data_variable.R
│   ├── data_map.R
│   └── data_analysis.R
│
├── data/
│   ├── county_income_2014_2024.csv
│   └── county_shapefile/
|       ├── tl_2024_us_county.cpg
|       ├── tl_2024_us_county.dbf
|       ├── tl_2024_us_county.prj
|       ├── tl_2024_us_county.shp
|       └── tl_2024_us_county.shx
│
├── figure/
│   ├── income_map_2024.png
│   ├── income_quintile_map_2014.png
│   └── income_quintile_map_2024.png
│
└── README.md
