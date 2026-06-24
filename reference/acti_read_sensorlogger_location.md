# Read SensorLogger Data

Read SensorLogger Data

## Usage

``` r
acti_read_sensorlogger_location(file, ...)
```

## Arguments

- file:

  A character vector of SensorLogger files, usually from unzipping the
  file, or a zip file of SensorLogger files

- ...:

  additional arguments to pass to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  If `verbose = FALSE`, then `progress = FALSE` and
  `show_col_types = FALSE`, unless otherwise overridden

## Value

A `data.frame` of data
