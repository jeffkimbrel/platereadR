#' Add biolog metadata
#'
#' @param plate A plate object/tibble
#' @param type The biolog plate type (PM1, PM2A, etc)
#' @export
#'

add_biolog_metadata = function(plate, type = "PM1") {
  require('readxl')
  require("tidyverse")

  biolog = readRDS(file = "R/biolog.rds") %>%
    filter(PLATE == type)

  plate = left_join(plate, biolog, by = "WELL")

  return(plate)
}
