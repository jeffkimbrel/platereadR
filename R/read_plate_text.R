#' Read time series in a text file
#'
#' @param file An text file with wells as columns, and time points as rows
#'
#' @export

read_plate_text = function(file) {
  readr::read_delim(file, delim = "\t", col_types = readr::cols(.default = "c")) |>
    tidyr::pivot_longer(cols = c(dplyr::everything(), -time), names_to = "WELL", values_to = "OD") |>
    dplyr::mutate(HOURS = as.numeric(lubridate::hms(time) - lubridate::hms("00:00:00")) / 3600) |>
    dplyr::mutate(OD = as.numeric(OD))
}
