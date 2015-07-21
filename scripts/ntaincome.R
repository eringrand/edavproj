 setwd('~/edavproj/data/income/')
 
 # Comment 

library(XML)
library(xlsx)
library(dplyr)
library(sp)
library(stringr)

stripLeadingZeros <- function(numericString) {
  gsub("(?<![0-9])0+", "", numericString, perl = TRUE)
}

##################################
## Download Source Data
##################################
download.file("http://catalog.opendata.city/dataset/dd98ccda-d996-4080-87aa-ef8e4fd1f167/resource/9dd0cf1e-1513-43bc-aeda-00ceef520f2f/download/CSVMedianHouseholdIncomeCensusTract.CSV",
              "~/CSVMedianHouseholdIncomeCensusTract.CSV")
download.file("http://www.nyc.gov/html/dcp/download/census/nyc2010census_tabulation_equiv.xlsx",
              "~/nyc2010census_tabulation_equiv.xlsx", mode="wb")
download.file("http://www.nyc.gov/html/dcp/download/census/census2010/t_sf1_p2_nta.xlsx",
              "data/t_sf1_p2_nta.xlsx")
download.file("http://www.nyc.gov/html/dcp/download/bytes/nynta_14d.zip",
              "data/nynta_14d.zip")
unzip("data/nynta_14d.zip", exdir="data")

##################################
## Median Household Income by NTA
##################################
census <- read.csv("CSVMedianHouseholdIncomeCensusTract.CSV", stringsAsFactors=FALSE)
options(java.parameters = "-Xmx1000m")
censusToNTA <- read.xlsx("nyc2010census_tabulation_equiv.xlsx",
                         sheetIndex=1, startRow=6, header=FALSE)
names(censusToNTA) <- c("borough", "COUNTYFP10", "boroughCode", "TRACTCE10", "puma", "NTACode", "name")
## strip leading zeros to prep keys for merging
censusToNTA$COUNTYFP10 <- stripLeadingZeros(censusToNTA$COUNTYFP10)
censusToNTA$TRACTCE10 <- stripLeadingZeros(censusToNTA$TRACTCE10)
## get median household income by nta
ntaMHI <- merge(census, censusToNTA, by=c("COUNTYFP10", "TRACTCE10")) %>%
  group_by(NTACode) %>%
  summarize(ntaMHI = mean(MHI))
write.csv(file="ntaMHI.csv", x=ntaMHI)
