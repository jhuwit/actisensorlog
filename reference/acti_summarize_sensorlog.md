# Summarize SensorLog Data

Summarize SensorLog Data

## Usage

``` r
acti_summarize_sensorlog(data)

acti_summarise_sensorlog(data)

acti_minute_sensorlog(data, seconds = 60L)

acti_summarize_distance_sensorlog(data)
```

## Arguments

- data:

  A SensorLog-style `data.frame`, usually output from
  [acti_process_sensorlog](https://jhuwit.github.io/actisensorlog/reference/acti_process_sensorlog.md)

- seconds:

  number of seconds to summarize the data for the "minute" level, or a
  string such as `"1 min"` (see
  [`actibase::acti_standardize_epoch()`](https://jhuwit.github.io/actibase/reference/acti_standardize_epoch.html)).
  Usually 1 minute/60 seconds. For `acti_summarize_distance_sensorlog`,
  summarization is done depending on how the data is grouped.

## Value

The `data.frame` with the summarized data for each date
