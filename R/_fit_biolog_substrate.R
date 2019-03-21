#' Return fit of a substrate
#'
#' @param x A raw biolog dataframe from read_multiplate_biolog_experiment()
#' @param s Substrate
#' @param w Measured wavelength
#'
#' @export

fit_biolog_substrate = function(x, s = "Glucose", w = '600') {
  df = ARW1R1.raw %>%
    filter(Wavelength == w) %>%
    filter(Substrate == s) %>%
    arrange(TIME)

  fit = SummarizeGrowth(df$TIME, df$value)

  d = data.frame("k" = fit$vals$k,
                 "r" = fit$vals$r,
                 "t_mid" = fit$vals$t_mid,
                 "n0" = fit$vals$n0,
                 "sigma" = fit$vals$sigma
  )

  fun = function(x) fit$vals$k/(1 + ((fit$vals$k - fit$vals$n0)/fit$vals$n0) * exp(-fit$vals$r * x))

  p = ggplot(df, aes(x = TIME, y = value - min(value))) +
    jak_theme() +
    stat_function(fun = fun, color = "#ff0000", size = 2) +
    geom_point(color = "#333333", size = 3) +
    xlab("Time") +
    ylab(paste0("OD", w)) +
    ggtitle(s, paste0("sigma=", fit$vals$sigma))

  l = list("plot" = p, "fit" = fit, "df" = d)

  return(l)
}
