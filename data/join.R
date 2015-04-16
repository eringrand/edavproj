setwd("~/edavproj/data/")
require(dplyr)

hs <- read.csv("DOE_High_School_Directory_2014-2015.csv", header=T, stringsAsFactors = F)
hs <- select(hs, -boro, -se_services, -ell_programs,  -school_accessibility_description, -number_programs)

sat <- read.csv("2014SATWebsite10214.csv", header=T, stringsAsFactors = F)
sat <- select(sat, -High.School)

safety <- read.csv("School_Safety_Report.csv", header=T, stringsAsFactors = F)
names(safety) <- tolower(names(safety))
safety <- select(safety, -address, -borough, -building.name, -schools.in.building, -building.code, -id)

hsSAT <- left_join(sat, hs, by="dbn")
join <- left_join(sat, safety, by=c("dbn"))


