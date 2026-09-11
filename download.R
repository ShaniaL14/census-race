library(tidyverse)
library(tidycensus)
library(sf)

# 2020 Decennial variables (PL 94-171)
race_vars_2020 <- c(
  hispanic = "P2_002N",
  white    = "P2_005N",
  black    = "P2_006N",
  asian    = "P2_008N"
)

# 2010 Decennial variables (SF1)
race_vars_2010 <- c(
  hispanic = "P004003",
  white    = "P005003",
  black    = "P005004",
  asian    = "P005006"
)

# 2000 Decennial variables (SF1)
race_vars_2000 <- c(
  hispanic = "P004002",
  white    = "P004005",
  black    = "P004006",
  asian    = "P004008"
)

# Download 2020 census tract data with geometries
fl_2020 <- get_decennial(
  geography = "tract",
  variables = race_vars_2020,
  summary_var = "P2_001N",
  state = "FL",
  year = 2020,
  geometry = TRUE
) |> 
  mutate(year = 2020)

# Download 2010 county data
fl_2010 <- get_decennial(
  geography = "county",
  variables = race_vars_2010,
  summary_var = "P005001",
  state = "FL",
  year = 2010
) |> 
  mutate(year = 2010)

# Download 2000 county data
fl_2000 <- get_decennial(
  geography = "county",
  variables = race_vars_2000,
  summary_var = "P004001",
  state = "FL",
  year = 2000
) |> 
  mutate(year = 2000)

# Save county geometries for mapping
fl_geo <- fl_2020 |> 
  filter(variable == "hispanic") |> 
  select(GEOID, NAME)

write_rds(fl_geo, "data/fl_geo.rds")

# Combine 2000, 2010, and 2020 census data
fl_race_all <- bind_rows(
  fl_2000,
  fl_2010,
  st_drop_geometry(fl_2020)
)

write_rds(fl_race_all, "data/fl_race_2000_2020.rds")
