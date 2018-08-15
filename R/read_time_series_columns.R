#' Read time series in a single excel file
#'
#' @param file An excel file with wells as columns, and time points as rows
#' @param repColumns Columns for a replicate.
#' @param rowReplace Takes a mapping df with rows A-H, and assigns names to a new column
#'
#' @export

read_time_series_columns = function(file = "", repColumns = c(1,2,3), rowReplace = FALSE) {

  require("tidyverse")
  require("readxl")
  require("jakR")

  raw = read_xlsx(file)

  raw$`T° 600` = NULL

  raw.g = gather(raw, "WELL", "OD600", 2:97)

  raw.g = separate(raw.g, WELL, into = c("ROW", "COLUMN"), sep = 1)

  startTime = raw.g$Time[1]
  raw.g$Time = as.numeric(difftime(raw.g$Time, startTime, units = "hours"))

  df.raw = raw.g %>%
    filter(COLUMN %in% repColumns)

  df.s = summarySE(df.raw, measurevar = "OD600", groupvars = c("Time", "ROW"))

  if (rowReplace != FALSE) {
    df.s = left_join(df.s, rowReplace, by = "ROW")
  }

  return(df.s)
}
