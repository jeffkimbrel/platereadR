#' Add Logistic curves to a plot object
#'
#' @param p A ggplot base object
#' @param plate A plate object/tibble
#' @param gompertz A tibble/df output from fit_logistic_plate
#'
#' @export

add_logistic_plot = function(p, plate, logistic) {

  newPlate = data.frame()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA = plate[plate$WELL==WELL,]
    logistic_equation = logistic[logistic$WELL==WELL,]

    df = grow_logistic(WELL_DATA$HOURS, logistic_equation) %>%
      as.data.frame() %>%
      mutate(HOURS = time) %>%
      mutate(LOGISTIC = y) %>%
      select(HOURS, LOGISTIC)

    WELL_DATA = left_join(WELL_DATA, df, by = "HOURS")
    newPlate = rbind(newPlate, as.data.frame(WELL_DATA))
  }

  p = p + geom_line(data = newPlate, aes(x = HOURS, y = LOGISTIC), size = 2, alpha = 0.5, color = "#6EBD75")
  return(p)
}
