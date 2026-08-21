#' Process SensorLog Data
#'
#' @param data A SensorLog-style `data.frame`
#' @param lat Latitude of central point (e.g. home) to calculate distance.
#' Set to `NULL` if distance should not be calculated.
#' @param lon Longitude of central point (e.g. home) to calculate distance
#' Set to `NULL` if distance should not be calculated.
#' @param dist_fun Distance function to pass to [geosphere::distm]
#' @param expected_timezone Expected Timezone based on the latitude/longitude
#' of the data based on the lat/lon values from SensorLog (
#' e.g. `"America/New_York"`).  Set to
#' `NULL` if not to be checked.
#' @param check_data should [acti_check_duplicate_times] be run?
#' @param remove_cols columns to remove from duplicate checking in
#' [acti_check_duplicate_times].  Default is `c("file", "index")`
#'
#' @return A `data.frame` of transformed data
#' @note This calls [acti_check_duplicate_times], [acti_calculate_distance], and
#' [acti_sensorlog_process_time]
#' @param verbose print diagnostic messages.  Either logical or integer, where
#' higher values are higher levels of verbosity.
#' @param ... additional arguments to pass to [acti_sensorlog_process_time],
#' including `apply_tz` and `tz`
#' @export
#' @examples
#' sensorlog = suppressMessages(
#'   actiread::acti_read_sensorlog(actiread::acti_example_sensorlog_file())
#' )
#' sensorlog = dplyr::distinct(sensorlog, time, .keep_all = TRUE)
#' result = acti_process_sensorlog(
#'   sensorlog,
#'   lat = 39.3,
#'   lon = -76.6,
#'   expected_timezone = "America/New_York",
#'   check_data = FALSE
#' )
#' head(result)
#' minute = acti_minute_sensorlog(result)
#' summary = acti_summarize_sensorlog(result)
#'
acti_process_sensorlog = function(
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
) {
  if (xor(is.null(lat), is.null(lon))) {
    stop("lat and lon must either both be supplied or both be NULL")
  }
  if (check_data) {
    data = acti_check_duplicate_times(data, remove_cols = remove_cols)
  }
  if (!is.null(lat) & !is.null(lon)) {
    data = acti_calculate_distance(data,
                                   lat = lat,
                                   lon = lon,
                                   dist_fun = dist_fun,
                                   distance_cutoff = distance_cutoff)
  } else {
    data = data |>
      dplyr::mutate(distance = NA_real_,
                    is_within_home = NA)
  }
  data = data |>
    # define within home as 180 meters or whatever cutoff
    dplyr::mutate(
      # calculate distance traveled
      distance_traveled = c(NA_real_, dist_fun(cbind(lon, lat))),
    )
  data = acti_sensorlog_process_time(data,
                                     expected_timezone = expected_timezone,
                                     check_data = check_data,
                                     verbose = verbose > 0,
                                     ...)
  data
}

#' @rdname acti_process_sensorlog
#' @export
acti_check_duplicate_times = function(data,
                                      remove_cols = c("file", "index")) {
  file = index = NULL
  rm(list = c("file", "index"))
  # make sure there are no duplicated times
  dupes = janitor::get_dupes(data, -dplyr::any_of(remove_cols))
  stopifnot(anyDuplicated(data$time) == 0)
  data
}



#' @rdname acti_process_sensorlog
#' @param distance_cutoff Distance in meters to consider within home,
#' in meters
#' @param fast Calculate distance on the distinct latitude/longitude, not the
#' full data.  Should be used unless some precision looks wrong.
#' @export
acti_calculate_distance = function(
    data,
    lat,
    lon,
    distance_cutoff = 180,
    dist_fun = geosphere::distVincentyEllipsoid,
    fast = TRUE) {
  stopifnot(!is.null(lat), !is.null(lon))
  assertthat::assert_that(
    is.numeric(distance_cutoff),
    length(distance_cutoff) == 1L,
    !is.na(distance_cutoff),
    is.finite(distance_cutoff)
  )
  if (fast) {
    udata = data |>
      dplyr::distinct(lon, lat)
    distance = geosphere::distm(
      as.matrix(udata),
      c(lon, lat),
      fun = dist_fun
    )

    stopifnot(is.matrix(distance) && ncol(distance) == 1)
    udata$distance = distance[,1]
    data = data |>
      dplyr::left_join(udata, by = c("lon", "lat"))
  } else {
    distance = geosphere::distm(
      as.matrix(data[, c("lon", "lat")]),
      c(lon, lat),
      fun = dist_fun
    )

    stopifnot(is.matrix(distance) && ncol(distance) == 1)
    data$distance = distance[, 1]
  }
  # just being overly cautious in case lat/lon passed in
  # gets confused in mutate
  lat = long = NULL
  rm(list = c("lat", "lon"))
  data = data |>
    # define within home as 180 meters or whatever cutoff
    dplyr::mutate(
      is_within_home = distance <= distance_cutoff
    )
  data
}
