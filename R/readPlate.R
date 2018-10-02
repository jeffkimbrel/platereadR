#' Read time series in an excel file
#'
#' @param file An excel file with wells as columns, and time points as rows
#' @param columnFormat Either "t" to state that the columns of the matrix are time, or "w" to state that the columns are the wells.
#' @export

readPlate = function(file = "", columnFormat = "t") {

  require("readxl")
  require("tidyverse")
  require("growthcurver")

  # massage data
  df = read_excel(file)
  df2 = gather(df, X, Y, 2:ncol(df))

  if (columnFormat == "t") {
    colnames(df2) = c("WELL", "TIME", "VALUE")
  } else {
    colnames(df2) = c("TIME", "WELL", "VALUE")
  }

  df2$TIME = as.numeric(df2$TIME)
  df3 = spread(df2, WELL, VALUE)

  return(df3)
}


