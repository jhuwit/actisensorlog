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

  \`data.frame\` of the data, output from \[acti_process_sensorlog\]

- seconds:

  integer of the number of seconds to summarize the data for the
  "minute" level. Usually 1 minute/60 seconds. For
  \`acti_summarize_distance_sensorlog\`, summarization is done depending
  on how the data is grouped.

## Value

The \`data.frame\` with the summarized data for each date
