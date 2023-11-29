#' Add biolog metadata
#'
#' @param plate A plate object/tibble
#' @param type The biolog plate type (PM1, PM2A, etc)
#' @export
#'

add_biolog_metadata = function(plate, type = "PM1") {

  biolog_temp = biolog |>
    dplyr::filter(PLATE == type)

  plate = dplyr::left_join(plate, biolog_temp, by = "WELL")

  return(plate)
}
