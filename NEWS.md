# actisensorlog 0.3.0

* The SensorLog/SensorLogger readers and helpers from 'actiread'
  (`acti_read_sensorlog()`, `acti_read_sensorlogger()`, ...) are now true
  re-exports documented in `?reexports`, so their arguments always match
  the installed 'actiread' (which renames `file` to `path`).
* Requires 'actibase' (>= 0.8.0) for `acti_standardize_epoch()`.
* 'purrr' and 'readr' are no longer imported; they were unused.
* `acti_minute_sensorlog(seconds = )` accepts epoch strings such as
  `"1 min"`, and summaries longer than 60 seconds no longer error.
* `acti_process_sensorlog()` and `acti_sensorlog_process_time()` now default
  to `verbose = TRUE`.

# actisensorlog 0.2.0

* Initial CRAN submission.
* Removing `magrittr` dependency.
