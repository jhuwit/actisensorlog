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
#> Error: 'acti_read_sensorlog' is not an exported object from 'namespace:actiread'
sensorlog = dplyr::distinct(sensorlog, time, .keep_all = TRUE)
#> Error: object 'sensorlog' not found
result = acti_process_sensorlog(
  sensorlog,
  lat = 39.3,
  lon = -76.6,
  expected_timezone = "America/New_York",
  check_data = FALSE
)
#> Error: object 'sensorlog' not found
head(result)
#> Error: object 'result' not found
minute = acti_minute_sensorlog(result)
#> Error: object 'result' not found
summary = acti_summarize_sensorlog(result)
#> Error: object 'result' not found
```
