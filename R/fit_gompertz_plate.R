#' Fit a plate with Gompertz
#'
#' @param plate A plate object/tibble
#'
#' @export

fit_gompertz_plate = function(plate) {
  df = tibble::tibble()

  for (WELL in unique(plate$WELL)) {
    WELL_DATA = plate[plate$WELL==WELL,]

    fit = fit_gompertz(WELL_DATA$HOURS, WELL_DATA$OD)

    well_df = tibble::tibble('WELL' = WELL,
                     'method' = "GOMPERTZ",
                     'y0' = growthrates::coef(fit)['y0'],
                     'mumax' = growthrates::coef(fit)['mumax'],
                     'K' = growthrates::coef(fit)['K'],
                     'r2' = growthrates::rsquared(fit))

    df = rbind(df, well_df)
  }

  return(df)
}
