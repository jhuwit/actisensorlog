# Process SensorLog Daa

Process SensorLog Daa

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

  A \`data.frame\` from \[acti_read_sensorlog\]

- lat:

  Latitude of central point (e.g. home) to calculate distance. Set to
  \`NULL\` if distnace not to be run.

- lon:

  Longitude of central point (e.g. home) to calculate distance Set to
  \`NULL\` if distnace not to be run.

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
library(actiread)
file = acti_example_sensorlog_file()
#> Error in acti_example_sensorlog_file(): could not find function "acti_example_sensorlog_file"
df = acti_read_sensorlog(file)
#> Error in acti_read_sensorlog(file): could not find function "acti_read_sensorlog"
head(df)
#>                                               
#> 1 function (x, df1, df2, ncp, log = FALSE)    
#> 2 {                                           
#> 3     if (missing(ncp))                       
#> 4         .Call(C_df, x, df1, df2, log)       
#> 5     else .Call(C_dnf, x, df1, df2, ncp, log)
#> 6 }                                           
result = acti_process_sensorlog(df, check_data = FALSE, tz = "GMT")
#> Error in UseMethod("mutate"): no applicable method for 'mutate' applied to an object of class "function"
out = acti_minute_sensorlog(result)
#> Error: object 'result' not found
out = acti_summarize_sensorlog(result)
#> Error: object 'result' not found
```
