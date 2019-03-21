#' Fit a plate with Baranyi
#'
#' @param plate A plate object/tibble
#'
#' @export

fit_baranyi_plate = function(plate) {
  df = tibble()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA = plate[plate$WELL==WELL,]

    fit = fit_baranyi(WELL_DATA$HOURS, WELL_DATA$OD)

    well_df = tibble('WELL' = WELL,
                     'method' = "BARANYI",
                     'y0' = coef(fit)['y0'],
                     'mumax' = coef(fit)['mumax'],
                     'K' = coef(fit)['K'],
                     'h0' = coef(fit)['h0'],
                     'r2' = rsquared(fit))

    df = rbind(df, well_df)
  }

  return(df)
}
