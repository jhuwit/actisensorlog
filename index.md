# actisensorlog

`actisensorlog` processes [SensorLog](http://sensorlog.berndthomas.net/)
and [SensorLogger](https://www.tszheichoi.com/sensorlogger) exports. The
package focuses on timestamp normalization, distance calculations,
duplicate-time checks, and daily summaries.

Core entry points:

- [`acti_process_sensorlog()`](https://jhuwit.github.io/actisensorlog/reference/acti_process_sensorlog.md)
  for duplicate checking, home-distance calculations, and timezone
  handling
- [`acti_sensorlog_process_time()`](https://jhuwit.github.io/actisensorlog/reference/acti_sensorlog_process_time.md)
  for parsing SensorLog timestamps
- [`acti_minute_sensorlog()`](https://jhuwit.github.io/actisensorlog/reference/acti_summarize_sensorlog.md)
  and
  [`acti_summarize_sensorlog()`](https://jhuwit.github.io/actisensorlog/reference/acti_summarize_sensorlog.md)
  for minute and daily summaries

## Installation

You can install `actisensorlog` from GitHub with:

``` r

# install.packages("remotes")
remotes::install_github("jhuwit/actisensorlog")
```

## Quick Start

``` r

library(actisensorlog)

sensorlog <- suppressMessages(
  actiread::acti_read_sensorlog(actiread::acti_example_sensorlog_file())
)

processed_sensorlog <- acti_process_sensorlog(
  sensorlog,
  lat = 39.3,
  lon = -76.6,
  expected_timezone = "America/New_York",
  check_data = FALSE
)

minute_sensorlog <- acti_minute_sensorlog(processed_sensorlog)
summary_sensorlog <- acti_summarize_sensorlog(processed_sensorlog)
```

The SensorLog example gains `distance`, `distance_traveled`, and
`is_within_home` fields:

``` r

head(processed_sensorlog)
#> # A tibble: 6 × 19
#>   file  time                index timestamp             lat   lon altitude speed
#>   <chr> <dttm>              <dbl> <dttm>              <dbl> <dbl>    <dbl> <dbl>
#> 1 /var… 2025-03-11 18:44:11     1 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 2 /var… 2025-03-11 18:44:11     2 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 3 /var… 2025-03-11 18:44:11     3 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 4 /var… 2025-03-11 18:44:12     4 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 5 /var… 2025-03-11 18:44:12     5 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 6 /var… 2025-03-11 18:44:12     6 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> # ℹ 11 more variables: speed_accuracy <dbl>, accel_X <dbl>, accel_Y <dbl>,
#> #   accel_Z <dbl>, lat_zero <lgl>, lon_zero <lgl>, distance <dbl>,
#> #   is_within_home <lgl>, distance_traveled <dbl>, timezone_estimated <chr>,
#> #   char_time <chr>
```

The minute-level view fills missing minutes between observations:

``` r

head(minute_sensorlog)
#> # A tibble: 6 × 16
#>   time                max_speed   lat   lon speed accel_X accel_Y accel_Z
#>   <dttm>                  <dbl> <dbl> <dbl> <dbl>   <dbl>   <dbl>   <dbl>
#> 1 2025-03-11 18:44:00        -1  39.3 -76.6    -1 -0.0178   0.964  0.0182
#> 2 2025-03-11 18:45:00        -1  39.3 -76.6    -1 -0.0665   1.01   0.0577
#> 3 2025-03-11 18:46:00        -1  39.3 -76.6    -1 -0.0547   1.00   0.0250
#> 4 2025-03-11 18:47:00        -1  39.3 -76.6    -1 -0.0843   1.01   0.0450
#> 5 2025-03-11 18:48:00        -1  39.3 -76.6    -1 -0.0808   1.01   0.0468
#> 6 2025-03-11 18:49:00        -1  39.3 -76.6    -1 -0.0901   1.01   0.0411
#> # ℹ 8 more variables: distance <dbl>, is_within_home <lgl>,
#> #   distance_traveled <dbl>, vm <dbl>, enmo <dbl>, lat_zero <lgl>,
#> #   lon_zero <lgl>, in_sensorlog <lgl>
```

The daily summary collapses the data to a single row per date:

``` r

summary_sensorlog
#> # A tibble: 1 × 11
#>   date       n_minutes_with_distance sum_distance max_distance
#>   <date>                       <int>        <dbl>        <dbl>
#> 1 2025-03-11                      12       10960.         913.
#> # ℹ 7 more variables: n_minutes_with_distance_traveled <int>,
#> #   sum_distance_traveled <dbl>, mean_distance_traveled <dbl>,
#> #   n_distance_traveled <int>, time_within_home <int>, time_outside_home <int>,
#> #   time_missing_home <int>
```

``` r

sensorlogger <- suppressMessages(
  actiread::acti_read_sensorlogger_location(
    actiread::acti_example_sensorlogger_location_file()
  )
)

processed_sensorlogger <- acti_process_sensorlog(
  sensorlogger,
  lat = 39.3,
  lon = -76.6,
  expected_timezone = "America/New_York"
)
#> No duplicate combinations found of: time, seconds_elapsed, altitude, speed_accuracy, bearing_accuracy, lat, altitude_above_mean_sea_level, bearing, horizontal_accuracy, ... and 6 other variables

minute_sensorlogger <- acti_minute_sensorlog(processed_sensorlogger)
summary_sensorlogger <- acti_summarize_sensorlog(processed_sensorlogger)
```

The packaged SensorLogger location example follows the same flow:

``` r

head(processed_sensorlogger)
#> # A tibble: 6 × 21
#>   time                seconds_elapsed altitude speed_accuracy bearing_accuracy
#>   <dttm>                        <dbl>    <dbl>          <dbl>            <dbl>
#> 1 2025-03-11 17:44:51         -6.71       7.37             -1               -1
#> 2 2025-03-11 17:44:58          0.0255     7.37             -1               -1
#> 3 2025-03-11 17:44:58          0.0322     7.37             -1               -1
#> 4 2025-03-11 17:44:58          0.0660     7.37             -1               -1
#> 5 2025-03-11 17:45:03          5.36       7.37             -1               -1
#> 6 2025-03-11 17:45:04          6.05       7.37             -1               -1
#> # ℹ 16 more variables: lat <dbl>, altitude_above_mean_sea_level <dbl>,
#> #   bearing <dbl>, horizontal_accuracy <dbl>, vertical_accuracy <dbl>,
#> #   lon <dbl>, speed <dbl>, lat_zero <lgl>, lon_zero <lgl>, file <chr>,
#> #   cat_type_sensor <chr>, distance <dbl>, is_within_home <lgl>,
#> #   distance_traveled <dbl>, timezone_estimated <chr>, char_time <chr>
```

``` r

head(minute_sensorlogger)
#> # A tibble: 6 × 16
#>   time                max_speed   lat   lon  speed accel_X accel_Y accel_Z
#>   <dttm>                  <dbl> <dbl> <dbl>  <dbl>   <dbl>   <dbl>   <dbl>
#> 1 2025-03-11 17:44:00     -1     39.3 -76.6 -1          NA      NA      NA
#> 2 2025-03-11 17:45:00      3.04  39.3 -76.6  0.265      NA      NA      NA
#> 3 2025-03-11 17:46:00     -1     39.3 -76.6 -1          NA      NA      NA
#> 4 2025-03-11 17:47:00     NA     NA    NA   NA          NA      NA      NA
#> 5 2025-03-11 17:48:00     -1     39.3 -76.6 -1          NA      NA      NA
#> 6 2025-03-11 17:49:00     -1     39.3 -76.6 -1          NA      NA      NA
#> # ℹ 8 more variables: distance <dbl>, is_within_home <lgl>,
#> #   distance_traveled <dbl>, vm <dbl>, enmo <dbl>, lat_zero <lgl>,
#> #   lon_zero <lgl>, in_sensorlog <lgl>
```

``` r

summary_sensorlogger
#> # A tibble: 1 × 11
#>   date       n_minutes_with_distance sum_distance max_distance
#>   <date>                       <int>        <dbl>        <dbl>
#> 1 2025-03-11                      71       64169.         924.
#> # ℹ 7 more variables: n_minutes_with_distance_traveled <int>,
#> #   sum_distance_traveled <dbl>, mean_distance_traveled <dbl>,
#> #   n_distance_traveled <int>, time_within_home <int>, time_outside_home <int>,
#> #   time_missing_home <int>
```
