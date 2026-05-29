make_sensorlog_example = local({
  data = NULL

  function() {
    if (is.null(data)) {
      data = suppressMessages(
        actiread::acti_read_sensorlog(actiread::acti_example_sensorlog_file())
      )
    }
    data
  }
})

make_sensorlogger_location_example = local({
  data = NULL

  function() {
    if (is.null(data)) {
      data = suppressMessages(
        actiread::acti_read_sensorlogger_location(
          actiread::acti_example_sensorlogger_location_file()
        )
      )
    }
    data
  }
})
