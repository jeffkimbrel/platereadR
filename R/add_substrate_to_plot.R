#' Add biolog substrates to a plot object
#'
#' @param p A ggplot base object
#' @param plate A plate object/tibble that has already been run through add_biolog_metadata
#'
#' @export

add_substrate_to_plot <- function(p, plate) {
  p <- p + ggplot2::geom_text(
    data = dplyr::filter(plate, HOURS == 0),
    size = 3,
    mapping = ggplot2::aes(
      hjust = 0,
      vjust = 1.1,
      x = -Inf,
      y = Inf,
      label = SUBSTRATE
    )
  )
  return(p)
}
