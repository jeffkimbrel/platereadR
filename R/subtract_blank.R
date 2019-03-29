#' Subtract Blank
#'
#' @param plate A plate object/tibble
#' @param well A single well to inspect
#'
#' @export

subtract_blank = function(plate, well) {
  BLANK = plate[plate$WELL == well,] %>%
    select(HOURS, OD) %>%
    rename("BLANK" = "OD")

  plateNew = left_join(plate, BLANK, by = "HOURS") %>%
    mutate(OD = OD - (BLANK*0.99))
  return(plateNew)
}
