#' Make a ggplot object which can act as a base for further mappings
#'
#' @param plate A plate object/tibble
#' @param by_substrate Organize the plate by substrate (TRUE) or well (FALSE, default)
#'
#' @export

plot_base_data <- function(plate, by_substrate = F) {
  p <- ggplot2::ggplot(plate, ggplot2::aes(x = HOURS, y = OD)) +
    ggplot2::geom_point(color = "#BBBBBB") +
    ggplot2::geom_smooth(method = 'loess',
                         color = "#037bcf",
                         formula = 'y ~ x')

  if (by_substrate == F) {
    p <- p + ggplot2::facet_grid(as.factor(ROW) ~ as.factor(COLUMN),
      scales = "free_y"
    )
  } else {
    p <- p + ggplot2::facet_wrap(~SUBSTRATE,
      scales = "free_y"
    )
  }
  return(p)
}
