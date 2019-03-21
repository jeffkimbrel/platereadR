#' Make a ggplot object which can act as a base for further mappings
#'
#' @param plate A plate object/tibble
#' @param by_substrate Organize the plate by substrate (TRUE) or well (FALSE, default)
#'#'
#' @export

plot_base_data = function(plate, by_substrate = F) {
  require('tidyverse')
  require("jakR")

  p = ggplot(plate, aes(x = HOURS, y = OD)) +
    jak_theme() +
    #geom_smooth(method = 'loess', color = "#4477AA") +
    geom_point(color = "#BBBBBB")
  if (by_substrate == F) {
    p = p + facet_grid(as.factor(ROW) ~ as.factor(COLUMN), scales = "free_y")
  } else {
    p = p + facet_wrap(~ SUBSTRATE, scales = "free_y")
  }
  return(p)
}
