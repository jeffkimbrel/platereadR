#' Calculate growth metrics from a df
#'
#' @param x A df from functions such as read_time_series_columns.R
#' @param wellRow Row to calculate growth metrics for
#' @param t_min An beginning timepoint in case the lag phase is weird
#' @param t_max An endpoint time in case the fit isn't optimal due to wonky late stationary phase death
#'
#' @export

growthMetrics = function(x, wellRow = "A", t_min = 5, t_max = 100) {

  require("tidyverse")
  require("growthcurver")

  df.A = filter(x, ROW == wellRow)

  df = data.frame()

  for (i in t_min:t_max ) {
    fit = SummarizeGrowth(df.A$Time, df.A$mean, t_trim = i, bg_correct = "min")
    d = data.frame("Time" = i, "r_p" = fit$vals$r_p)
    df = rbind(df, d)
  }

  # if (t_max == FALSE) {
  #
  #   for (i in t_min:100 ) {
  #     fit = SummarizeGrowth(df.A$Time, df.A$mean, t_trim = i, bg_correct = "min")
  #     d = data.frame("Time" = i, "r_p" = fit$vals$r_p)
  #     df = rbind(df, d)
  #   }
  # } else {
  #   fit = SummarizeGrowth(df.A$Time, df.A$mean, t_trim = t_max, bg_correct = "min")
  #   d = data.frame("Time" = t_max, "r_p" = fit$vals$r_p)
  #   df = rbind(df, d)
  # }

  optimalTime = df$Time[which.min(df$r_p)]

  fit = SummarizeGrowth(df.A$Time, df.A$mean, t_trim = optimalTime, bg_correct = "min")

  d = data.frame("k" = fit$vals$k,
                 "r" = fit$vals$r,
                 "t_mid" = fit$vals$t_mid,
                 "optimalTime" = optimalTime,
                 "ROW" = wellRow,
                 "n0" = fit$vals$n0,
                 "sigma" = fit$vals$sigma
  )

  fun = function(x) fit$vals$k/(1 + ((fit$vals$k - fit$vals$n0)/fit$vals$n0) * exp(-fit$vals$r * x))

  p = ggplot(df.A, aes(x = Time, y = mean - min(mean))) +
    jak_theme() +
    geom_point(color = "#000000", size = 1) +
    stat_function(fun = fun, color = "#ff0000", size = 2) +
    xlab("Time") +
    ylab("OD600") +
    geom_vline(xintercept = optimalTime, linetype = 2, color = "red") +
    ggtitle(wellRow, paste0("sigma=", fit$vals$sigma))

  l = list("df" = d, "p" = p, "fun" = fun)

  return(l)
}
