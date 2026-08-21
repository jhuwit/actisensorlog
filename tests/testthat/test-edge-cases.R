test_that("distance calculation supports both algorithms and custom distances", {
  data = dplyr::tibble(
    lon = c(-76.6000, -76.6000, -76.6005),
    lat = c(39.3000, 39.3000, 39.3005)
  )
  custom_dist = function(p1, p2) geosphere::distCosine(p1, p2)

  fast = actisensorlog::acti_calculate_distance(
    data, lat = 39.3, lon = -76.6, dist_fun = custom_dist, fast = TRUE
  )
  full = actisensorlog::acti_calculate_distance(
    data, lat = 39.3, lon = -76.6, dist_fun = custom_dist, fast = FALSE
  )

  expect_equal(fast$distance, full$distance, tolerance = 1e-8)
  expect_equal(fast$distance[1], 0, tolerance = 1e-8)
  expect_equal(fast$distance[2], 0, tolerance = 1e-8)
  expect_gt(fast$distance[3], 0)
})

test_that("distance inputs are validated", {
  data = dplyr::tibble(lon = -76.6, lat = 39.3)

  expect_error(
    actisensorlog::acti_calculate_distance(data, lat = 39.3, lon = -76.6,
                                            distance_cutoff = "180")
  )
  expect_error(
    actisensorlog::acti_calculate_distance(data, lat = 39.3, lon = -76.6,
                                            distance_cutoff = NA_real_)
  )
  expect_error(
    actisensorlog::acti_process_sensorlog(data, lat = 39.3, lon = NULL),
    "both be supplied"
  )
  expect_error(
    actisensorlog::acti_process_sensorlog(data, lat = NULL, lon = -76.6),
    "both be supplied"
  )
})

test_that("minute summary validates seconds and supports empty input", {
  data = dplyr::tibble(
    time = as.POSIXct("2025-03-11 14:44:11", tz = "UTC"),
    lat = 0, lon = 0, speed = 1, distance_traveled = NA_real_
  )
  for (seconds in list(0, -1, 1.5, NA_real_, Inf)) {
    expect_error(actisensorlog::acti_minute_sensorlog(data, seconds = seconds))
  }

  empty = data[0, ]
  result = actisensorlog::acti_minute_sensorlog(empty)
  expect_equal(nrow(result), 0L)
  expect_true("in_sensorlog" %in% names(result))
})

test_that("minute summary handles missing measurements and midnight gaps", {
  data = dplyr::tibble(
    time = as.POSIXct(c("2025-03-11 23:59:10", "2025-03-12 00:01:10"), tz = "UTC"),
    lat = c(0, 0),
    lon = c(0, 0),
    distance_traveled = c(NA_real_, 2)
  )

  result = actisensorlog::acti_minute_sensorlog(data)
  expect_equal(nrow(result), 3L)
  expect_equal(result$time, as.POSIXct(c(
    "2025-03-11 23:59:00", "2025-03-12 00:00:00", "2025-03-12 00:01:00"
  ), tz = "UTC"))
  expect_true(all(result$lat_zero[result$in_sensorlog]))
  expect_true(all(result$lon_zero[result$in_sensorlog]))
  expect_true(all(is.na(result$max_speed)))
  expect_true(all(is.na(result$vm[result$in_sensorlog])))
  expect_true(all(is.na(result$enmo[result$in_sensorlog])))
})

test_that("minute summary tolerates missing accelerometer and speed values", {
  data = dplyr::tibble(
    time = as.POSIXct(c("2025-03-11 14:44:11", "2025-03-11 14:44:30"), tz = "UTC"),
    lat = c(39.3, 39.3), lon = c(-76.6, -76.6),
    speed = c(NA_real_, 2),
    accel_X = c(NA_real_, 1), accel_Y = c(NA_real_, 0), accel_Z = c(NA_real_, 0),
    distance_traveled = c(NA_real_, 1)
  )

  result = actisensorlog::acti_minute_sensorlog(data)
  expect_equal(result$max_speed, 2)
  expect_true(is.na(result$vm))
})
