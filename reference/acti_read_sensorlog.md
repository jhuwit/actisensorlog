# Read SensorLog Data

Read SensorLog Data

## Usage

``` r
acti_read_sensorlog(file, verbose = FALSE, robust = FALSE)
```

## Arguments

- file:

  A character vector of SensorLog files, usually from unzipping the file

- verbose:

  print diagnostic messages. Either logical or integer, where higher
  values are higher levels of verbosity.

- robust:

  if \`TRUE\` then \[rewrite_sensorlog_csv\] is run on the data to try
  to fix any shifts with the data.

## Value

A \`data.frame\` of data

## Examples

``` r
library(actiread)
#> 
#> Attaching package: ‘actiread’
#> The following objects are masked from ‘package:actisensorlog’:
#> 
#>     acti_read_sensorlog, acti_read_sensorlogger,
#>     acti_read_sensorlogger_general, acti_read_sensorlogger_location,
#>     acti_rewrite_sensorlog_csv
file = acti_example_sensorlog_file()
df = acti_read_sensorlog(file)
head(df)
#> # A tibble: 6 × 14
#>   file   time  index timestamp   lat   lon altitude speed speed_accuracy accel_X
#>   <chr>  <chr> <dbl>     <dbl> <dbl> <dbl>    <dbl> <dbl>          <dbl>   <dbl>
#> 1 /tmp/… 2025…     1    1.74e9  39.3 -76.6     46.3    -1             -1  0.411 
#> 2 /tmp/… 2025…     2    1.74e9  39.3 -76.6     46.3    -1             -1  0.0908
#> 3 /tmp/… 2025…     3    1.74e9  39.3 -76.6     46.3    -1             -1  0.125 
#> 4 /tmp/… 2025…     4    1.74e9  39.3 -76.6     46.3    -1             -1  0.0636
#> 5 /tmp/… 2025…     5    1.74e9  39.3 -76.6     46.3    -1             -1  0.0993
#> 6 /tmp/… 2025…     6    1.74e9  39.3 -76.6     46.3    -1             -1  0.0702
#> # ℹ 4 more variables: accel_Y <dbl>, accel_Z <dbl>, lat_zero <lgl>,
#> #   lon_zero <lgl>
```
