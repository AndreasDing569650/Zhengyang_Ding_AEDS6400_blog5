# AEDS 6400 Blog Post 5: The Geography of U.S. Income Distribution: A Decade of Sticky Divides

## Project Intro

This repository contains the data pipeline and visualization code for an analysis of U.S. county-level income distribution. The project investigates the spatial concentration of high- and low-income counties over time and examines how the distribution changes between 2014 and 2024.

## Data and Method

Income Data: The source is U.S. Census Bureau, American Community Survey (ACS), with the variable of Median Household Income (B19013_001E). Data is retrieved programmatically using the Census Bureau API.

Estimate Type: 5-year estimates (e.g., 2020-2024). 5-year estimates are utilized instead of 1-year estimates because they provide complete geographic coverage for all U.S. counties, including those with smaller populations.

Relative Income Transformation: Because nominal income levels change over time due to inflation, comparing absolute dollar amounts across a decade can be misleading. To measure relative economic standing, county-level incomes are ranked into quintiles within each year, allowing the analysis to focus on position in the distribution rather than nominal value.

Geospatial Data: U.S. Census Bureau TIGER/Line Shapefiles (county boundaries), conducted in R. It is merged with the income variable data.

## Analytical Logic

The analysis is structured in two steps:

1. We map the 2024 relative income quintiles to identify current spatial patterns (e.g., coastal clustering vs. Southern contiguous blocks). To validate that this relative ranking reflects real-world income differences, we compare the geographic clustering to the median-income map.

2. We compare the 2024 relative distribution map with the 2014 map. By holding the relative metric constant across the decade, we can isolate shifts in spatial inequality—observing whether middle-income counties are losing ground, whether low-income clusters expand, and whether high-income counties remain spatially concentrated.

## Code Overview

data_variable.R
This script downloads the county-level median household income data from the U.S. Census Bureau API for 2014 and 2024 using the ACS 5-year estimates. It queries the B19013_001E variable for all counties across states, cleans the returned data, and creates a single combined dataset with county identifiers, income values, and year labels. The final output is saved to data/county_income_2014_2024.csv, which serves as the foundation for the later mapping and analysis steps.

data_map.R
This script downloads the 2024 U.S. county shapefile from the Census TIGER/Line repository and stores it in the data/county_shapefile/ directory. It unzips the files and loads the spatial county geometry into R so the project has a geographic base layer for each county. This script is essential for creating the map objects used later in the analysis and ensures that the county boundaries are aligned with the income data by county GEOID.

data_analysis.R
This script reads the income dataset and the county shapefile, merges them by GEOID, and prepares the data for spatial analysis. It groups counties into income quintiles, removes non-contiguous territories, and generates visualizations of median household income and relative income distribution for 2014 and 2024. The script then saves the final output plots to the figure/ folder, producing the maps used to illustrate the spatial geography of U.S. income inequality over the decade.

## Repository Structure

Note: The SHP spatial data file of county shapes is beyond 25mb, thus cannot be uploaded to GitHub. The structure below still includes the file, forming a complete structure. One can always download the shapefile and place it in the `data/county_shapefile` folder.

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
```

## Running the analysis

The R scripts assume they are run from the `code/` directory, because several files use relative paths such as `..` to reach the repository root, the `data/` folder, and the `figure/` output folder. To run the project successfully, open a terminal in the repository root and change into `code/` before executing the scripts:

```bash
cd code
# edit data_variable.R and replace the placeholder Census API key first
Rscript data_variable.R
Rscript data_map.R
Rscript data_analysis.R
```

This keeps the `../data` and `../figure` paths valid and ensures the scripts write the output files to the correct project folders. If you run the scripts from outside `code/`, the relative paths will not resolve properly.
