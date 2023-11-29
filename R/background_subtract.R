#' Background subtract plate data
#'
#' @param plate A plate object/tibble
#' @export
#'

background_subtract = function(plate) {
  plate |>
    dplyr::group_by(WELL) |>
    dplyr::mutate(OD = OD - min(OD))
}
