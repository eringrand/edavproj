setwd("~/edavproj/data/")


hs = read.csv("DOE_High_School_Directory_2014-2015.csv", header=T, stringsAsFactors = F)
sat <- read.csv("2014SATWebsite10214.csv", header=T, stringsAsFactors = F)

require(dplyr)

hsSAT <- left_join(hs, sat)
