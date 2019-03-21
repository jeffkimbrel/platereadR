#' Add Gompertz curves to a plot object
#'
#' @param p A ggplot base object
#' @param plate A plate object/tibble
#' @param gompertz A tibble/df output from fit_gompertz_plate
#'
#' @export

add_gompertz_plot = function(p, plate, gompertz) {

  newPlate = data.frame()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA = plate[plate$WELL==WELL,]

    gompertz_equation = gompertz[gompertz$WELL==WELL,]

    df = grow_gompertz(WELL_DATA$HOURS, gompertz_equation) %>%
      as.data.frame() %>%
      mutate(HOURS = time) %>%
      mutate(GOMPERTZ = y) %>%
      select(HOURS, GOMPERTZ)

    WELL_DATA = left_join(WELL_DATA, df, by = "HOURS")
    newPlate = rbind(newPlate, as.data.frame(WELL_DATA))
  }

  p = p + geom_line(data = newPlate, aes(x = HOURS, y = GOMPERTZ), size = 2, alpha = 0.5, color = "#276DB5")
  return(p)
}
