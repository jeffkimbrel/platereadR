#library("tidyverse")
#library("jakR")

## READ DATA

file = "/Users/kimbrel1/Library/CloudStorage/OneDrive-LLNL/Documents/Biofuels_SFA/Isolates/biologResults/kristina/biolog_ARW1R1_PM1.txt"

plate = read_plate_text(file) |>
  right_trim(timepoint = 40) |>
  add_biolog_metadata(type = "PM1") #|>
  #subtract_blank("A1") |>
  # background_subtract()


# PLOT DATA
p = plot_base_data(plate, by_substrate = F) |>
  add_substrate_to_plot(plate)
p

# FIT DATA

j = plate |>
  dplyr::filter(WELL == "B2")

j_g = fit_gompertz(x =j$HOURS, y = j$OD)
growthrates::coef(j_g)
growthrates::summary(j_g)
growthrates::plot(j_g)


# plate wise
gompertz_data = fit_gompertz_plate(plate)
plot_error(gompertz_data)
add_gompertz_plot(p, plate, gompertz_data)

gompertz_data |>
  tidyr::pivot_longer(cols = c(y0, K, mumax, r2), names_to = "parameter", values_to = "value") |>
  ggplot2::ggplot(ggplot2::aes(x = WELL, y =value, fill = parameter)) +
  ggplot2::geom_col()+
  ggplot2::facet_wrap(~parameter, ncol = 1, scales = "free_y") +
  jakR::jak_theme()



#
p   <- c(y0 = 0.03, mumax = .1, K = 0.1, h0 = 1)
lower   <- c(y0 = 0.001, mumax = 1e-2, K = 0.005, h0 = 0)
upper   <- c(y0 = 0.1,   mumax = 1,    K = 5,   h0 = 10)

many_baranyi2 <-growthrates::all_growthmodels(
  OD ~ growthrates::grow_baranyi(time, parms) | SUBSTRATE,
  data = plate,
  p = p, lower = lower, upper = upper,
  which = c("y0", "mumax", "K"), transform = "log", ncores = 2)




#


logistic_data = fit_logistic_plate(plate)
baranyi_data  = fit_baranyi_plate(plate)

plot_error(baranyi_data, gompertz_data, logistic_data)

add_gompertz_plot(p, plate, gompertz_data)
add_logistic_plot(p, plate, logistic_data)
add_baranyi_plot(p, plate, baranyi_data)

d = analyze_well(plate, "A5")
d$p
d$df

df = plyr::rbind.fill(gompertz_data, logistic_data, baranyi_data)
df = add_biolog_metadata(df)

ggplot(df, aes(x = reorder(paste0(SUBSTRATE,"_",WELL), K), y = K)) +
  jak_theme() +
  geom_col() +
  facet_wrap(~method, ncol = 1)

ggplot(df, aes(x = reorder(paste0(SUBSTRATE,"_",WELL), mumax), y = mumax)) +
  jak_theme() +
  geom_col() +
  facet_wrap(~method, ncol = 1) +
  scale_y_log10()
