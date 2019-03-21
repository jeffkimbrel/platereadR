#' Convert plate data to plot and tibble
#'
#' @param x A df output from read_multiplate_biolog_experiment()
#' @param w A wavelength (or vector of wavelengths)
#'
#' Wavelength to RGB mappings come from https://academo.org/demos/wavelength-to-colour-relationship/
#'
#' @export

biolog_plot_and_table = function(x, w = '600') {
  df.s = x %>%
    filter(Wavelength %in% w)

  dfNegative = df.s %>%
    filter(Substrate == "Negative Control") %>%
    select(Wavelength, value, TIME)

  colnames(dfNegative) = c("Wavelength", "negative", "TIME")
  df.s$Wavelength = as.character(df.s$Wavelength)
  dfWithNeg = left_join(df.s, dfNegative, by = c("Wavelength", "TIME"))
  dfWithNeg$value = dfWithNeg$negative

  # plot

  p = ggplot(df.s, aes(x = TIME, y = value)) +
    jak_theme() +
    geom_line(aes(group = Wavelength, color = Wavelength)) +
    geom_point(size = 3, alpha = 0.9, pch = 21, aes(fill = Wavelength)) +
    facet_grid(Row~Column) +
    scale_fill_manual(values = c(`600` = "#ffbe00", `450` = "#0046ff", `750` = "#a10000")) +
    scale_color_manual(values = c(`600` = "#ffbe00", `450` = "#0046ff", `750` = "#a10000")) +
    geom_point(data = dfWithNeg, aes(x = TIME, y = value, color = Wavelength), size = 1, pch = 3) +
    geom_line(data = dfWithNeg, aes(group = Wavelength, color = Wavelength), linetype = "dashed") +
    ggtitle("Solid line = Substrate, Dashed = Negative Control")

  tb = df.s %>%
    select(Substrate, Wavelength, TIME, value) %>%
    spread(TIME, value)

  l = list('plot' = p, "table" = tb)
  return(l)
}
