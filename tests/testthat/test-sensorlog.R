testthat::skip_if_not_installed("actiread")

test_that("actiread sensorlog helpers are re-exported", {
  exported = c(
    "acti_convert_sensorlogger_time",
    "acti_example_sensorlog_file",
    "acti_example_sensorlogger_file",
    "acti_example_sensorlogger_location_file",
    "acti_read_sensorlog",
    "acti_read_sensorlogger",
    "acti_read_sensorlogger_general",
    "acti_read_sensorlogger_location",
    "acti_rewrite_sensorlog_csv",
    "acti_sensorlog_csv_colnames_mapping",
    "acti_sensorlog_csv_spec",
    "acti_sensorlogger_location_colnames_mapping",
    "acti_sensorlogger_location_spec"
  )

  expect_true(all(exported %in% getNamespaceExports("actisensorlog")))
  expect_true(is.function(acti_read_sensorlog))
  expect_true(is.function(acti_read_sensorlogger_location))
})

test_that("sensorlog example data can be processed", {
  data = make_sensorlog_example()

  result = acti_process_sensorlog(
    data,
    lat = 39.3,
    lon = -76.6,
    expected_timezone = "America/New_York",
    check_data = FALSE
  )

  expect_s3_class(result$time, "POSIXct")
  expect_true(all(c("distance", "is_within_home", "distance_traveled", "char_time") %in% names(result)))
  expect_false(any(result$is_within_home, na.rm = TRUE))
  expect_equal(unique(result$timezone_estimated), "America/New_York")
})

test_that("sensorlog example data summarizes to daily output", {
  data = make_sensorlog_example()

  processed = acti_process_sensorlog(
    data,
    lat = 39.3,
    lon = -76.6,
    expected_timezone = "America/New_York",
    check_data = FALSE
  )
  minute = acti_minute_sensorlog(processed)
  summary = acti_summarize_sensorlog(processed)

  expect_equal(nrow(minute), 12L)
  expect_true(all(c("time", "in_sensorlog") %in% names(minute)))
  expect_equal(nrow(summary), 1L)
  expect_equal(summary$time_missing_home[1], 0L)
  expect_equal(summary$time_within_home[1], 0L)
  expect_equal(summary$time_outside_home[1], nrow(minute))
})

test_that("sensorlogger location example can be processed", {
  data = make_sensorlogger_location_example()

  result = acti_process_sensorlog(
    data,
    lat = 39.3,
    lon = -76.6,
    expected_timezone = "America/New_York"
  )

  expect_s3_class(result$time, "POSIXct")
  expect_true(all(c("distance", "is_within_home", "distance_traveled", "timezone_estimated") %in% names(result)))
  expect_false(any(result$is_within_home, na.rm = TRUE))
  expect_false(any(is.na(result$is_within_home)))
})

test_that("sensorlogger location example summarizes to daily output", {
  data = make_sensorlogger_location_example()

  processed = acti_process_sensorlog(
    data,
    lat = 39.3,
    lon = -76.6,
    expected_timezone = "America/New_York"
  )
  minute = acti_minute_sensorlog(processed)
  summary = acti_summarize_sensorlog(processed)

  expect_equal(nrow(minute), 73L)
  expect_true(all(c("time", "in_sensorlog") %in% names(minute)))
  expect_equal(nrow(summary), 1L)
  expect_equal(summary$time_within_home[1], 0L)
  expect_equal(summary$time_outside_home[1], 71L)
  expect_equal(summary$time_missing_home[1], 2L)
  expect_equal(summary$time_within_home[1] + summary$time_outside_home[1] + summary$time_missing_home[1], nrow(minute))
})
