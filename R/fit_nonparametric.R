#' Fit a single sample with local non-parametric
#'
#' @param x Time vector
#' @param y Growth vector
#'
#' @export


fit_nonparametric = function(x, y, h = 4) {
  require("cellGrowth")

  fit = fitCellGrowth(x = x, z = y, locfit.h = h)

  return(fit)
}

