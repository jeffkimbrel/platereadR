#' Add Baranyi curves to a plot object
#'
#' @param p A ggplot base object
#' @param plate A plate object/tibble
#' @param gompertz A tibble/df output from fit_baranyi_plate
#'
#' @export

add_baranyi_plot = function(p, plate, baranyi) {

  newPlate = data.frame()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA = plate[plate$WELL==WELL,]
    baranyi_equation = baranyi[baranyi$WELL==WELL,]

    df = grow_baranyi(WELL_DATA$HOURS, baranyi_equation) %>%
      as.data.frame() %>%
      mutate(HOURS = time) %>%
      mutate(BARANYI = y) %>%
      select(HOURS, BARANYI)

    WELL_DATA = left_join(WELL_DATA, df, by = "HOURS")
    newPlate = rbind(newPlate, as.data.frame(WELL_DATA))
  }

  p = p + geom_line(data = newPlate, aes(x = HOURS, y = BARANYI), size = 2, alpha = 0.5, color = "#DC050C")
  return(p)
}
