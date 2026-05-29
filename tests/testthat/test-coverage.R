testthat::skip_if_not_installed("actiread")

test_that("sensorslog processing can skip home-distance calculation", {
  data = make_sensorlog_example()[1:2, ]

  result = actisensorlog::acti_process_sensorlog(
    data,
    lat = NULL,
    lon = NULL,
    expected_timezone = "America/New_York",
    check_data = FALSE
  )

  expect_true(all(is.na(result$distance)))
  expect_true(all(is.na(result$is_within_home)))
  expect_s3_class(result$time, "POSIXct")
})

test_that("duplicate time checking rejects repeated timestamps", {
  data = make_sensorlog_example()[1:2, ]
  data$time[2] = data$time[1]

  expect_error(actisensorlog::acti_check_duplicate_times(data))
})

test_that("time processing handles apply_tz FALSE and timestamp columns", {
  data = make_sensorlog_example()[1, ]
  data$timestamp = data$timestamp + 60

  result = actisensorlog::acti_sensorlog_process_time(
    data,
    expected_timezone = "America/New_York",
    apply_tz = FALSE,
    check_data = TRUE
  )

  expect_s3_class(result$time, "POSIXct")
  expect_s3_class(result$timestamp, "POSIXct")
  expect_equal(result$char_time, data$time)
})

test_that("minute summarization fills missing helper columns", {
  data = dplyr::tibble(
    time = as.POSIXct(
      c(
        "2025-03-11 14:44:11",
        "2025-03-11 14:45:11",
        "2025-03-11 14:47:11"
      ),
      tz = "UTC"
    ),
    lat = c(39.3, 39.3001, 39.3002),
    lon = c(-76.6, -76.6001, -76.6002),
    speed = c(1, 2, 3),
    distance_traveled = c(NA_real_, 2, 4)
  )

  result = suppressWarnings(
    actisensorlog::acti_minute_sensorlog(data, seconds = 60L)
  )

  expect_true(all(c(
    "lat_zero", "lon_zero", "accel_X", "accel_Y", "accel_Z",
    "is_within_home", "in_sensorlog"
  ) %in% names(result)))
  expect_true(any(!result$in_sensorlog))
  expect_true(any(is.na(result$is_within_home)))
  expect_equal(nrow(result), 4L)
})

test_that("distance summarization handles missing distance and all-missing travel", {
  data = dplyr::tibble(
    date = as.Date(c("2025-03-11", "2025-03-11")),
    distance_traveled = c(NA_real_, NA_real_),
    is_within_home = c(NA, NA)
  )

  result = suppressWarnings(
    actisensorlog::acti_summarize_distance_sensorlog(dplyr::group_by(data, date))
  )

  expect_true(is.na(result$sum_distance_traveled))
  expect_true(is.na(result$mean_distance_traveled))
  expect_true(is.na(result$max_distance))
  expect_equal(result$n_minutes_with_distance, 0L)
  expect_equal(result$time_missing_home, 2L)
})

test_that("summarizing without time fails fast", {
  expect_error(
    actisensorlog::acti_summarize_sensorlog(dplyr::tibble(date = as.Date("2025-03-11"))),
    "time column"
  )
})

test_that("distance calculation creates distance and home flag", {
  data = make_sensorlog_example()[1:2, ]

  result = actisensorlog::acti_calculate_distance(
    data,
    lat = data$lat[1],
    lon = data$lon[1],
    distance_cutoff = 180
  )

  expect_true(all(c("distance", "is_within_home") %in% names(result)))
  expect_equal(result$distance[1], 0)
  expect_true(isTRUE(result$is_within_home[1]))
})
