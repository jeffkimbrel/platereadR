#' Fit a single sample with gompertz
#'
#' @param x Time vector
#' @param y Growth vector
#'
#' @export


fit_gompertz = function(x, y) {
  require("growthrates")

  lower = c(y0 = -1, mumax = 0, K = 0)
  upper = c(y0 = 1,  mumax = 10, K = 10)
  p <- c(y0 = min(y), mumax = 0.02, K = max(y))

  d = fit_growthmodel(FUN = grow_gompertz, p = p, time = x, y = y, lower = lower, upper = upper)
  return(d)
}
