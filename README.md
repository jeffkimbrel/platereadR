# platereadR

# Install

```
library('devtools')
install_github('jeffkimbrel/platereadR')
```
# Read from file

The time component is expected to be in column 1, and in `hh:mm:ss` format. 

The following code will read the data, add metadata for the biolog plate (currently only supports PM1, PM2A and PM3B), and then background subtracts each well by the minimum OD.

Only the `read_plate_text` is needed, the other two can be skipped if you don't want to modify your data.

```
plate = read_plate_text("path/to/data")
plate = add_biolog_metadata(plate, type = "PM1")
plate = background_subtract(plate)
```

# Fitting Data

```
gompertz_data = fit_gompertz_plate(plate)
logistic_data = fit_logistic_plate(plate)
baranyi_data = fit_baranyi_plate(plate)
```

These can also have the biolog metadata added to them as above.

```
gompertz_data = add_biolog_metadata(gompertz_data)

head(gompertz_data)
# A tibble: 6 x 12
  WELL  method             y0  mumax      K    r2 ID     SUBSTRATE              ROW   COLUMN PLATE POSITION
  <chr> <chr>           <dbl>  <dbl>  <dbl> <dbl> <chr>  <chr>                  <chr>  <dbl> <chr>    <dbl>
1 A1    GOMPERTZ 0.0365       0.387  0.129  0.437 PM1_A1 Negative Control       A          1 PM1          1
2 A2    GOMPERTZ 0.00943      0.122  0.0980 0.672 PM1_A2 L-Arabinose            A          2 PM1          9
3 A3    GOMPERTZ 0.0504       0.131  0.0873 0.705 PM1_A3 N-Acetyl-D-Glucosamine A          3 PM1         17
4 A4    GOMPERTZ 0.0325       0.0889 0.282  0.991 PM1_A4 D-Saccharic Acid       A          4 PM1         25
5 A5    GOMPERTZ 0.0000000104 0.0746 0.733  0.992 PM1_A5 Succinic Acid          A          5 PM1         33
6 A6    GOMPERTZ 0.00821      0.165  0.169  0.689 PM1_A6 D-Galactose            A          6 PM1         41
```


# Plotting

A base plot of the raw data can be made, which further data can be mapped onto.

```
p = plot_base_data(plate, by_substrate = F)
p = add_substrate_to_plot(p, plate)
```

Fitted data can be added similarly. These can be added to the same plot, or to create different plots don't override the `p`, and use a different variable.

```
p = add_gompertz_plot(p, plate, gompertz_data)
p = add_logistic_plot(p, plate, logistic_data)
p = add_baranyi_plot(p, plate, baranyi_data)
```

R-squared boxplots can be visualized as well - just pass in as many fit objects that you have.

```
plot_error(baranyi_data, gompertz_data, logistic_data)
```

And finally, well-specific plots can be viewed. The object returned is a list with `$p` having the plot, and `$df` having the dataframe.

```
d = analyze_well(plate, "A1")
d$p
d$df

  WELL   method          y0     mumax         K        r2        h0
1   A1 GOMPERTZ 0.036455368 0.3869642 0.1294073 0.4365867        NA
2   A1  BARANYI 0.001562857 0.1671545 0.1298782 0.4611270 -5.805613
3   A1 LOGISTIC 0.044114034 0.4391673 0.1293787 0.4269571        NA
```
