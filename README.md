<!-- README.md is generated from README.Rmd. Please edit that file -->

# gdds

<!-- badges: start -->
<!-- badges: end -->

The goal of gdds package is to calculate Growing Degree Days (GDDs, ºCd)

□ Code summary: https://github.com/agronomy4future/r_code/blob/main/Calculation_for_Growing_Degree_Days_(GDDs_%C2%BACd).ipynb

□ Code explained: https://agronomy4future.org/archives/23118

## Installation

You can install the development version of fwrmodel like so:

Before installing, please download Rtools (https://cran.r-project.org/bin/windows/Rtools)

``` r
if(!require(remotes)) install.packages("remotes")
if (!requireNamespace("gdds", quietly = TRUE)) {
  remotes::install_github("agronomy4future/gdds")
}
library(remotes)
library(gdds)
```

## Example

This is a basic code to calculate Growing Degree Days (GDDs, ºCd):

``` r
# Calculate cumulative temp from 2023-11-23 to 2024-01-23 when the base temperature is 0
cumulative_temp = gdds(df, "date", "temp", date= c("2023-11-23", "2024-01-23"), BT= 0)

# Calculate cumulative temp from 2023-11-23 to 2024-01-23 per group when the base temperature is 0
cumulative_temp_by_group = gdds(df, "date", "temp", "group", date= c("2023-11-23", "2024-01-23"), BT= 0)
```

## Let’s practice with actual dataset

``` r
# to uplaod data
if(!require(readr)) install.packages("readr")
library(readr)

github="https://raw.githubusercontent.com/agronomy4future/raw_data_practice/main/Apr_15_to_Sep_12.csv"
df= data.frame(read_csv(url(github), show_col_types=FALSE))

head(df,5)
  Year  Date Day  Max   Min   Avg
1 2024 1-Jan   1 3.35 -5.13 -1.72
2 2024 2-Jan   2 2.61 -5.37 -2.12
3 2024 3-Jan   3 3.13 -3.90 -1.13
4 2024 4-Jan   4 3.94 -4.01 -0.91
5 2024 5-Jan   5 3.08 -4.11 -1.13
.
.
.

# to calculate Growing Degree Days (GDDs, ºCd) for corn
corn_gdds= gdds(df, "Date", "Avg", date= c("2024-05-20", "2024-08-30"), BT= 10)

head(corn_gdds,5)
  Year   Date Day   Max   Min   Avg date_range adjusted_temp Days  GDDs
1 2024 20-May 141 29.02 17.80 23.45 2024-05-20         13.45    1 13.45
2 2024 21-May 142 29.56 19.31 24.58 2024-05-21         14.58    2 28.03
3 2024 22-May 143 24.74 15.28 20.09 2024-05-22         10.09    3 38.12
4 2024 23-May 144 26.77 12.47 20.44 2024-05-23         10.44    4 48.56
5 2024 24-May 145 26.78 17.51 21.96 2024-05-24         11.96    5 60.52
.
.
.

# to calculate GDDs using gdds() with grouping
if(!require(readr)) install.packages("readr")
library(readr)
github="https://raw.githubusercontent.com/agronomy4future/raw_data_practice/main/Apr_15_to_Sep_12_grouping.csv"
df = data.frame(read_csv(url(github), show_col_types=FALSE))

set.seed(100)
df[sample(nrow(df),7),]
    Year   Date planting_date   Max   Min   Avg
454 2024 21-Jul        May_19 26.05 16.46 21.83
4   2024  4-Jan          <NA>  3.94 -4.01 -0.91
311 2024 25-Jun         May_2 30.42 21.37 25.23
326 2024 10-Jul         May_2 27.72 14.39 21.90
98  2024  7-Apr          <NA> 15.69  3.69 10.31
391 2024 19-May        May_19 29.95 16.76 24.07
7   2024  7-Jan          <NA>  3.24 -3.87 -0.70
.
.
.

hemp_gdds= gdds(df, "Date", "Avg", "planting_date", date= c("2024-04-15", "2024-08-30"), BT= 1)

head(hemp_gdds,5)
  Year   Date planting_date   Max   Min   Avg date_range adjusted_temp Days  GDDs
1 2024 15-Apr        Apr_15 26.69 13.02 19.13 2024-04-15         18.13    1 18.13
2 2024 16-Apr        Apr_15 27.23 13.94 20.52 2024-04-16         19.52    2 37.65
3 2024 17-Apr        Apr_15 21.12 10.69 17.74 2024-04-17         16.74    3 54.39
4 2024 18-Apr        Apr_15 22.43  8.15 16.17 2024-04-18         15.17    4 69.56
5 2024 19-Apr        Apr_15 14.05  5.72  9.82 2024-04-19          8.82    5 78.38
.
.
.
```
