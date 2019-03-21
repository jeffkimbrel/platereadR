#' Analyze Well
#'
#' @param plate A plate object/tibble
#' @param well A single well to inspect
#'
#' @export

analyze_well = function(plate, well) {
  WELL_DATA = plate[plate$WELL == well,]
  p = ggplot(WELL_DATA, aes(x = HOURS, y = OD)) +
    jak_theme() +
    geom_point(color = "#BBBBBB")

  gompertz_result = fit_gompertz(WELL_DATA$HOURS, WELL_DATA$OD)
  gompertz = tibble('WELL' = well,
                   'method' = "GOMPERTZ",
                   'y0' = coef(gompertz_result)['y0'],
                   'mumax' = coef(gompertz_result)['mumax'],
                   'K' = coef(gompertz_result)['K'],
                   'r2' = rsquared(gompertz_result))
  p = add_gompertz_plot(p, WELL_DATA, gompertz)

  baranyi_result = fit_baranyi(WELL_DATA$HOURS, WELL_DATA$OD)
  baranyi = tibble('WELL' = well,
                    'method' = "BARANYI",
                    'y0' = coef(baranyi_result)['y0'],
                    'mumax' = coef(baranyi_result)['mumax'],
                    'K' = coef(baranyi_result)['K'],
                    'r2' = rsquared(baranyi_result),
                    'h0' = coef(baranyi_result)['h0'])
  p = add_baranyi_plot(p, WELL_DATA, baranyi)

  logistic_result = fit_logistic(WELL_DATA$HOURS, WELL_DATA$OD)
  logistic = tibble('WELL' = well,
                   'method' = "LOGISTIC",
                   'y0' = coef(logistic_result)['y0'],
                   'mumax' = coef(logistic_result)['mumax'],
                   'K' = coef(logistic_result)['K'],
                   'r2' = rsquared(logistic_result),
                   'h0' = coef(logistic_result)['h0'])
  p = add_logistic_plot(p, WELL_DATA, logistic)

  df = plyr::rbind.fill(gompertz, baranyi, logistic)

  d = list('p' = p, 'df' = df)
  return(d)
}
