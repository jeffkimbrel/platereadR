#' Fit a single sample with Baranyi
#'
#' @param x Time vector
#' @param y Growth vector
#'
#' @export

fit_baranyi = function(x, y) {
  require("growthrates")
  p = c(y0 = min(y), mumax = 0.1, K = max(y), h0 = 0)

  d = suppressWarnings(fit_growthmodel(FUN = grow_baranyi, p = p, time = x, y = y))
  return(d)
}
