# Changelog

## actisensorlog 0.3.0

CRAN release: 2026-10-22

- The SensorLog/SensorLogger readers and helpers from ‘actiread’
  ([`acti_read_sensorlog()`](https://jhuwit.github.io/actiread/reference/acti_read_sensorlog.html),
  [`acti_read_sensorlogger()`](https://jhuwit.github.io/actiread/reference/acti_read_sensorlogger.html),
  …) are now true re-exports documented in `?reexports`, so their
  arguments always match the installed ‘actiread’ (which renames `file`
  to `path`).
- Requires ‘actibase’ (\>= 0.8.0) for `acti_standardize_epoch()`.
- ‘purrr’ and ‘readr’ are no longer imported; they were unused.
- `acti_minute_sensorlog(seconds = )` accepts epoch strings such as
  `"1 min"`, and summaries longer than 60 seconds no longer error.
- [`acti_process_sensorlog()`](https://jhuwit.github.io/actisensorlog/reference/acti_process_sensorlog.md)
  and
  [`acti_sensorlog_process_time()`](https://jhuwit.github.io/actisensorlog/reference/acti_sensorlog_process_time.md)
  now default to `verbose = TRUE`.

## actisensorlog 0.2.0

CRAN release: 2026-09-12

- Initial CRAN submission.
- Removing `magrittr` dependency.
