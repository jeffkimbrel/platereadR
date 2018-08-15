#' Read Series of Excel Files in a Directory
#'
#' @export

read_multiplate_experiment = function(path = "") {

  require("tidyverse")
  require("readxl")

  files <- list.files(path)
  files <- files[grepl(plateName, files)]

  # iterate through files

  df = data.frame()

  for (currentFile in files) {

    # get plate sample data
    SAMPLE = strsplit(currentFile, "_")[[1]][1]
    PLATE = strsplit(currentFile, "_")[[1]][2]
    TIME = strsplit(strsplit(currentFile, "_")[[1]][3], "[.]")[[1]][1]
    TIME = gsub("T", "", TIME)
    TIME = as.numeric(TIME)

    # filter master list for plate type
    biologMasterExp = filter(biologMaster, Plate == PLATE)
    biologMasterExp$Well = as.character(biologMasterExp$Well)

    filePath = paste0(path, "/" , currentFile)
    plateData = read_excel(filePath)

    plateData$Results = NULL
    plateData = na.omit(plateData)
    colnames(plateData) = plateData[1,]
    plateData = filter(plateData, Well != "Well")

    plateData.melt = gather(plateData, "variable", "value", 2:ncol(plateData))

    # combine everything
    allData = left_join(plateData.melt, biologMasterExp, by = "Well")
    allData$SAMPLE = SAMPLE
    allData$TIME = TIME

    df = rbind(df, allData)
  }

  return(df)

}
