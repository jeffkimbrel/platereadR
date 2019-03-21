#' Fit a plate with Logistic
#'
#' @param plate A plate object/tibble
#'
#' @export

fit_logistic_plate = function(plate) {
  df = tibble()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA = plate[plate$WELL==WELL,]

    fit = fit_logistic(WELL_DATA$HOURS, WELL_DATA$OD)

    well_df = tibble('WELL' = WELL,
                     'method' = "LOGISTIC",
                     'y0' = coef(fit)['y0'],
                     'mumax' = coef(fit)['mumax'],
                     'K' = coef(fit)['K'],
                     'r2' = rsquared(fit))

    df = rbind(df, well_df)
  }

  return(df)
}
