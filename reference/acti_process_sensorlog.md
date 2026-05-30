# Process SensorLog Data

Process SensorLog Data

## Usage

``` r
acti_process_sensorlog(
  data,
  lat = NULL,
  lon = NULL,
  dist_fun = geosphere::distVincentyEllipsoid,
  expected_timezone = NULL,
  check_data = TRUE,
  remove_cols = c("file", "index"),
  verbose = FALSE,
  ...,
  distance_cutoff = 180
)

acti_check_duplicate_times(data, remove_cols = c("file", "index"))

acti_calculate_distance(
  data,
  lat,
  lon,
  distance_cutoff = 180,
  dist_fun = geosphere::distVincentyEllipsoid
)
```

## Arguments

- data:

  A SensorLog-style \`data.frame\`

- lat:

  Latitude of central point (e.g. home) to calculate distance. Set to
  \`NULL\` if distance should not be calculated.

- lon:

  Longitude of central point (e.g. home) to calculate distance Set to
  \`NULL\` if distance should not be calculated.

- dist_fun:

  Distance function to pass to \[geosphere::distm\]

- expected_timezone:

  Expected Timezone based on the latitude/longitude of the data based on
  the lat/lon values from SensorLog ( e.g. \`"America/New_York"\`). Set
  to \`NULL\` if not to be checked.

- check_data:

  should \[acti_check_duplicate_times\] be run?

- remove_cols:

  columns to remove from duplicate checking in
  \[acti_check_duplicate_times\]. Default is \`c("file", "index")\`

- verbose:

  print diagnostic messages. Either logical or integer, where higher
  values are higher levels of verbosity.

- ...:

  additional arguments to pass to \[acti_sensorlog_process_time\],
  including \`apply_tz\` and \`tz\`

- distance_cutoff:

  Distance in meters to consider within home, in meters

## Value

A \`data.frame\` of transformed data

## Note

This calls \[acti_check_duplicate_times\], \[acti_calculate_distance\],
and \[acti_sensorlog_process_time\]

## Examples

``` r
sensorlog = suppressMessages(
  actiread::acti_read_sensorlog(actiread::acti_example_sensorlog_file())
)
sensorlog = dplyr::distinct(sensorlog, time, .keep_all = TRUE)
result = acti_process_sensorlog(
  sensorlog,
  lat = 39.3,
  lon = -76.6,
  expected_timezone = "America/New_York",
  check_data = FALSE
)
head(result)
#> # A tibble: 6 × 19
#>   file  time                index timestamp             lat   lon altitude speed
#>   <chr> <dttm>              <dbl> <dttm>              <dbl> <dbl>    <dbl> <dbl>
#> 1 /tmp… 2025-03-11 18:44:11     1 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 2 /tmp… 2025-03-11 18:44:11     2 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 3 /tmp… 2025-03-11 18:44:11     3 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 4 /tmp… 2025-03-11 18:44:12     4 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 5 /tmp… 2025-03-11 18:44:12     5 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> 6 /tmp… 2025-03-11 18:44:12     6 2025-03-11 18:44:07  39.3 -76.6     46.3    -1
#> # ℹ 11 more variables: speed_accuracy <dbl>, accel_X <dbl>, accel_Y <dbl>,
#> #   accel_Z <dbl>, lat_zero <lgl>, lon_zero <lgl>, distance <dbl>,
#> #   is_within_home <lgl>, distance_traveled <dbl>, timezone_estimated <chr>,
#> #   char_time <chr>
minute = acti_minute_sensorlog(result)
summary = acti_summarize_sensorlog(result)
```
