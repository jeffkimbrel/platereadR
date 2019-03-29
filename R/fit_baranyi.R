#' Fit a single sample with Baranyi
#'
#' @param x Time vector
#' @param y Growth vector
#'
#' @export

fit_baranyi = function(x, y) {
  require("growthrates")
  lower = c(y0 = -1, mumax = 0, K = 0, h0 = -1)
  upper = c(y0 = 1,  mumax = 10, K = 10, h0 = 10)
  p = c(y0 = min(y), mumax = 0.1, K = max(y), h0 = 0)

  d = suppressWarnings(fit_growthmodel(FUN = grow_baranyi, p = p, time = x, y = y, upper = upper, lower = lower))
  return(d)
}
