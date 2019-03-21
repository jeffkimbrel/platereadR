#' Read time series in a text file
#'
#' @param file An text file with wells as columns, and time points as rows
#' @export

read_plate_text = function(file = "") {
  require("tidyverse")
  require("lubridate")

  df = read_delim(file, delim = "\t", col_types = cols(.default = "c"))
  df2 = gather(df, WELL, OD, 2:ncol(df)) %>%
    mutate(HOURS = as.numeric(hms(time) - hms("00:00:00")) / 3600) %>%
    mutate(OD = as.numeric(OD))
  return(df2)
}
