library("tidyverse")
library("jakR")

## READ DATA

plate = read_plate_text("~/Dropbox/LLNL/Projects/Microalgae/Isolates/biologResults/kristina/biolog_ARW1R1_PM1.txt")
plate = right_trim(plate, timepoint = 40)
plate = add_biolog_metadata(plate, type = "PM1")
plate = subtract_blank(plate, "A1")
plate = background_subtract(plate)

# PLOT DATA
p = plot_base_data(plate)
p = add_substrate_to_plot(p, plate)
p

# FIT DATA

gompertz_data = fit_gompertz_plate(plate)
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
