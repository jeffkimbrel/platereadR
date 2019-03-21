#' Background subtract plate data
#'
#' @param plate A plate object/tibble
#' @export
#'

background_subtract = function(plate) {
  plate = plate %>%
    group_by(WELL) %>%
    mutate(OD = OD - min(OD))
  return(plate)
}
