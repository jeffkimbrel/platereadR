#' Plot Error
#'
#' @param ... As many fit plate result objects that you want to plot
#'
#' @export

plot_error = function(...) {
  d = tibble::tibble()

  x <- list(...)

  for (i in x){
    j = i |> dplyr::select(method, r2)

    d = rbind(d, j)
  }

  ggplot2::ggplot(d, ggplot2::aes(x = method, y = r2, fill = method)) +
    ggplot2::geom_boxplot(outlier.size = .1) +
    ggbeeswarm::geom_beeswarm(pch = 21, size = 3, cex = 1.2)
}
