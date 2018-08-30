#' Convert plate data to plot and tibble
#'
#' @param x A df output from read_multiplate_biolog_experiment()
#' @param w A wavelength (or vector of wavelengths)
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
    geom_point(size = 2, alpha = 0.8, aes(color = Wavelength)) +
    geom_line(aes(group = Wavelength, color = Wavelength)) +
    facet_wrap(~Substrate, nrow = 12) +
    scale_color_manual(values = c("600" = "#BEAD93", "450" = "#A15767", "750" = "#003388")) +
    geom_point(data = dfWithNeg, aes(x = TIME, y = value, color = Wavelength), size = 1, pch = 3) +
    geom_line(data = dfWithNeg, aes(group = Wavelength, color = Wavelength), linetype = "dashed") +
    ggtitle("Solid line = Substrate, Dashed = Negative Control") +
    theme(strip.text.x = element_text(size = 7))

  tb = df.s %>%
    select(Substrate, Wavelength, TIME, value) %>%
    spread(TIME, value)

  l = list('plot' = p, "table" = tb)
  return(l)
}
