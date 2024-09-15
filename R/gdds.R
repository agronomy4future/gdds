#' Calculation for Growing Degree Days (GDDs, ºC d)
#'
#' This function calculates the cumulative growing degree days (GDDs, ºC d) and the sequential days for a specified date range.
#'
#' @param data A data frame containing the input data.
#' @param date_col The name of the column in the data frame containing date values.
#' @param temp_col The name of the column in the data frame containing temperature values.
#' @param group_col Optional. The name of the column to group by, if desired.
#' @param date A vector of two elements specifying the start and end dates for the calculation (e.g., `c("2023-11-23", "2024-01-23")`).
#' @param BT Base temperature to subtract from each temperature value. Default is 0. If the temperature is less than Base temperature, it is considered as 0.
#'
#' @return A data frame with the filtered data, including new columns for Days and GDDs. When calculating GDDs, if the temperature is below zero, it is considered as 0.
#' @examples
#' # Example usage with start_date and end_date
#' # Calculate cumulative temp from 2023-11-23 to 2024-01-23 when the base temperature is 0
#' cumulative_temp = gdds(df, "date", "temp", date= c("2023-11-23", "2024-01-23"), BT= 0)
#'
#' # Calculate cumulative temp from 2023-11-23 to 2024-01-23 per group when the base temperature is 0
#' cumulative_temp_by_group = gdds(df, "date", "temp", "group", date= c("2023-11-23", "2024-01-23"), BT= 0)
#'
#' @import lubridate
#' @import dplyr
#' @export
gdds= function(data, date_col, temp_col, group_col= NULL, date= c(start_date, end_date), BT= 0) {

  # Ensure the necessary packages are installed and loaded
  if (!requireNamespace("lubridate", quietly = TRUE)) install.packages("lubridate", dependencies = TRUE)
  if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr", dependencies = TRUE)
  library(lubridate)
  library(dplyr)

  # Extract start_date and end_date from the date vector
  start_date= as.Date(date[1])
  end_date= as.Date(date[2])

  # Extract the start and end years
  start_year= year(start_date)
  end_year= year(end_date)

  # Convert the temperature column to numeric
  data[[temp_col]]= as.numeric(data[[temp_col]])

  # Check if the date column includes a year, if not, append the start_year initially
  data$date_range= ifelse(grepl("\\d{4}", data[[date_col]]),
                          as.Date(data[[date_col]], format= "%Y-%m-%d"),  # Direct parsing if year is present
                          as.Date(paste(data[[date_col]], start_year), format= "%d-%b %Y"))  # Append start year

  # Adjust the year for dates that should fall into the next year
  data$date_range= ifelse(data$date_range < start_date,
                          data$date_range + years(1),  # Move dates to the next year if before start_date
                          data$date_range)

  # Ensure that date_range is in Date format
  data$date_range= as.Date(data$date_range, origin = "1970-01-01")

  # Filter data between start_date and end_date
  data_filtered= data %>%
    filter(date_range >= start_date & date_range <= end_date)

  # If group_col is provided, group by that column; otherwise, don't group
  if (!is.null(group_col)) {
    data_filtered= data_filtered %>%
      group_by(.data[[group_col]]) %>%
      arrange(date_range) %>%    # Ensure the data is sorted by date within each group
      mutate(adjusted_temp= ifelse(.data[[temp_col]] - BT > 0, .data[[temp_col]] - BT, 0),  # Set to 0 if less than BT
             Days= row_number(),  # Create an incrementing Days column first
             GDDs= cumsum(adjusted_temp)) %>%  # Calculate GDDs based on adjusted temperature
      ungroup()  # Ungroup to avoid affecting subsequent operations
  } else {
    data_filtered= data_filtered %>%
      arrange(date_range) %>%    # Ensure the data is sorted by date
      mutate(adjusted_temp= ifelse(.data[[temp_col]] - BT > 0, .data[[temp_col]] - BT, 0),  # Set to 0 if less than BT
             Days= row_number(),  # Create an incrementing Days column first
             GDDs= cumsum(adjusted_temp))  # Calculate GDDs based on adjusted temperature
  }

  return(data_filtered)
}
