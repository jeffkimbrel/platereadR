#' Subtract Blank
#'
#' @param plate A plate object/tibble
#' @param well A single well to inspect
#'
#' @export

subtract_blank = function(plate, well) {

  BLANK = plate |>
    dplyr::filter(WELL == well) |>
    dplyr::select(HOURS, OD) |>
    dplyr::rename("BLANK" = "OD")

  plateNew = dplyr::left_join(plate, BLANK, by = "HOURS") |>
    dplyr::mutate(OD = OD - (BLANK*0.99))

  return(plateNew)
}
