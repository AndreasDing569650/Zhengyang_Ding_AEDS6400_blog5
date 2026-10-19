# AEDS 6400 Blog Post 5: Housing Affordability in the United States

This project uses data from the Federal Reserve Bank of St. Louis FRED database to examine changes in housing affordability in the United States.
The analysis combines median sales prices of new houses, 30-year fixed mortgage rates, median household income, and the Consumer Price Index (CPI). The data are collected through the FRED API and transformed into comparable measures by adjusting house prices for inflation and constructing a house-price-to-income ratio.
The project uses 3 sets of time-series visualizations to examine long-run changes in housing prices, borrowing costs, and housing affordability.

## Repository Structure

```text
Zhengyang_Ding_AEDS6400_blog5/
│
├── code/
│   ├── data_variable.R
│   ├── data_map.R
│   └── data_analysis.R
│
├── data/
│   ├── raw_data/
│       ├── county_income_2014_2024.csv
│       └── county_shapefile
│
├── figure/
│   ├── income_map_2024.png
│   ├── income_quintile_map_2014.png
│   └── income_quintile_map_2024.png
│
└── README.md
