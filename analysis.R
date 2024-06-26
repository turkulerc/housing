# This script analyses housing data for Luxembourg
library(dplyr)
library(ggplot2)
library(tidyr)

#Let’s load the datasets:

commune_level_data <- read.csv("datasets/commune_level_data.csv")
country_level_data <- read.csv("datasets/country_level_data.csv")

#Let’s compute the Laspeyeres index for each commune:

commune_level_data <- commune_level_data |>
  group_by(locality) |>
  mutate(p0 = ifelse(year == "2010", average_price_nominal_euros, NA)) |>
  fill(p0, .direction = "down") |>
  mutate(p0_m2 = ifelse(year == "2010", average_price_m2_nominal_euros, NA)) |>
  fill(p0_m2, .direction = "down") |>
  ungroup() |>
  mutate(pl = average_price_nominal_euros/p0*100,
         pl_m2 = average_price_m2_nominal_euros/p0_m2*100)


#Let’s also compute it for the whole country:

country_level_data <- country_level_data |>
  mutate(p0 = ifelse(year == "2010", average_price_nominal_euros, NA)) |>
  fill(p0, .direction = "down") |>
  mutate(p0_m2 = ifelse(year == "2010", average_price_m2_nominal_euros, NA)) |>
  fill(p0_m2, .direction = "down") |>
  mutate(pl = average_price_nominal_euros/p0*100,
         pl_m2 = average_price_m2_nominal_euros/p0_m2*100)


#We are going to create a plot for 5 communes and compare the price evolution in the communes
#to the national price evolution. Let’s first list the communes:

communes <- c("Luxembourg",
              "Esch-sur-Alzette",
              "Mamer",
              "Schengen",
              "Wincrange")

make_plot <- function(country_level_data,
                      commune_level_data,
                      commune){
  
  filtered_data <- commune_level_data %>%
    filter(locality == commune)
  
  data_to_plot <- bind_rows(
    country_level_data,
    filtered_data
  )
  
  ggplot(data_to_plot) +
    geom_line(aes(y = pl_m2,
                  x = year,
                  group = locality,
                  colour = locality))
}

# Luxembourg

lux_plot <- make_plot(country_level_data,
                      commune_level_data,
                      communes[1])
# Esch sur Alzette

esch_plot <- make_plot(country_level_data,
                       commune_level_data,
                       communes[2])

# Mamer

mamer_plot <-  make_plot(country_level_data,
                         commune_level_data,
                         communes[3])

# Schengen

schengen_plot <- make_plot(country_level_data,
                           commune_level_data,
                           communes[4])

# Wincrange

wincrange_plot <- make_plot(country_level_data,
                            commune_level_data,
                            communes[5])

# Let’s save the plots
ggsave("plots/lux_plot.pdf", lux_plot)
ggsave("plots/esch_plot.pdf", esch_plot)
ggsave("plots/mamer_plot.pdf", mamer_plot)
ggsave("plots/schengen_plot.pdf", schenger_plot)
ggsave("plots/wincrange_plot.pdf", wincrange_plot)
