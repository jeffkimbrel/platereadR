#' Plot Error
#'
#' @param ... As many fit plate result objects that you want to plot
#'
#' @export

plot_error = function(...) {
  require("ggbeeswarm")
  d = tibble()

  x <- list(...)

  for (i in x){
    j = i %>% select(method, r2)

    d = rbind(d, j)
  }

  ggplot(d, aes(x = method, y = r2, fill = method)) +
    jak_theme() +
    geom_boxplot(outlier.size = .1) +
    geom_beeswarm(pch = 21, size = 3, cex = 1.2) +
    scale_fill_manual(values = tol$rainbow(length(unique(d$method))))
}
