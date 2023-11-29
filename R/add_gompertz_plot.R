#' Add Gompertz curves to a plot object
#'
#' @param p A ggplot base object
#' @param plate A plate object/tibble
#' @param gompertz A tibble/df output from fit_gompertz_plate
#'
#' @export

add_gompertz_plot <- function(p, plate, gompertz) {
  newPlate <- data.frame()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA <- plate[plate$WELL == WELL, ]

    gompertz_equation <- gompertz[gompertz$WELL == WELL, ]

    df <- growthrates::grow_gompertz(WELL_DATA$HOURS, gompertz_equation) |>
      as.data.frame() |>
      dplyr::mutate(HOURS = time) |>
      dplyr::mutate(GOMPERTZ = y) |>
      dplyr::select(HOURS, GOMPERTZ)

    WELL_DATA <- dplyr::left_join(WELL_DATA, df, by = "HOURS")
    newPlate <- rbind(newPlate, as.data.frame(WELL_DATA))
  }

  p <- p + ggplot2::geom_line(data = newPlate, ggplot2::aes(x = HOURS, y = GOMPERTZ), size = 2, alpha = 0.5, color = "red")
  return(p)
}
