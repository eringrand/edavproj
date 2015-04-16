setwd("~/edavproj/data/")


hs <- read.csv("DOE_High_School_Directory_2014-2015.csv", header=T, stringsAsFactors = F)
sat <- read.csv("2014SATWebsite10214.csv", header=T, stringsAsFactors = F)

require(dplyr)

hsSAT <- left_join(hs, sat, by="dbn")

hsSAT <- select(hsSAT, -boro, -High.School, -se_services, -ell_programs, -school_accessibility_description, -number_programs)

write.csv(hsSAT, file = "data.csv", row.names=FALSE, quote=FALSE)
