#' Right Trim
#'
#' @param plate A plate object/tibble
#' @param timepoint Trim time points after this
#' @export
#'

right_trim = function(plate, timepoint) {
  plate = plate %>%
    filter(HOURS < timepoint)

  return(plate)
}
