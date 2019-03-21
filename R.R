library("tidyverse")
library("jakR")

## READ DATA

plate = read_plate_text("~/Dropbox/LLNL/Projects/Microalgae/Isolates/biologResults/kristina/biolog_6CLA_PM2A.txt")
plate = add_biolog_metadata(plate, type = "PM2A")
plate = background_subtract(plate)

# PLOT DATA
p = plot_base_data(plate)
p
p = add_substrate_to_plot(p, plate)

# FIT DATA

gompertz_data = fit_gompertz_plate(plate)
gompertz_data = add_biolog_metadata(gompertz_data)
logistic_data = fit_logistic_plate(plate)
logistic_data = add_biolog_metadata(logistic_data)
baranyi_data = fit_baranyi_plate(plate)
baranyi_data = add_biolog_metadata(baranyi_data)

plot_error(baranyi_data, gompertz_data, logistic_data)

add_gompertz_plot(p, plate, gompertz_data)
add_logistic_plot(p, plate, logistic_data)
add_baranyi_plot(p, plate, baranyi_data)


d = analyze_well(plate, "E1")
d$p
d$df
