setwd("~/Documents/Repository/edavproj/data/")
require(dplyr)

#==========get directory of high schools and SAT results =============
hs <- read.csv("DOE_High_School_Directory.csv", header=T, stringsAsFactors = F)
hs <- select(hs, -boro, -se_services, -ell_programs,  -school_accessibility_description, -number_programs)
hs$lonlat <- tail(strsplit(hs$Location, '\n')[[1]], n=1)

sat <- read.csv("SAT_Results_2012.csv", header=T, stringsAsFactors = F)
names(sat) <- tolower(names(sat))
sat <- select(sat, -school.name)

#========= get safety report ================
safety <- read.csv("School_Safety_Report.csv", header=T, stringsAsFactors = F)
names(safety) <- tolower(names(safety))
safety <- select(safety, -address, -location.name, -location.code, -borough, -building.name, -schools.in.building, -building.code, -id, -register, -rangea)
# according to http://schools.nyc.gov/OurSchools/SchoolSafetyReport.htm: N/A means 0 crime
safety[safety == 'N/A'] <- 0

#========= get class size clean data =============
class_size <- read.csv("2010-2011_Class_Size_School-level_detail.csv", header=T, stringsAsFactors = F)
# construct dbn from CSD and schoolcode
csd1 = subset(class_size, CSD<10)
csd2 = subset(class_size, CSD>=10)
csd1$dbn = paste0('0', csd1$CSD, csd1$SCHOOL.CODE)
csd2$dbn = paste0(csd2$CSD, csd2$SCHOOL.CODE)
class_size = rbind(csd1, csd2)

class_size <- select(class_size, dbn, GRADE, NUMBER.OF.STUDENTS...SEATS.FILLED, NUMBER.OF.SECTIONS, AVERAGE.CLASS.SIZE, SIZE.OF.SMALLEST.CLASS, SIZE.OF.LARGEST.CLASS)
colnames(class_size) <- c('dbn', 'grade', 'num_stu', 'num_class', 'avg_size', 'smallest_size', 'largest_size')

require(sqldf)
class = sqldf("SELECT dbn, sum(num_stu),sum(num_class) FROM class_size WHERE grade='09-12' GROUP BY dbn")
colnames(class) <- c('dbn', 'total_stu', 'total_class')
class$avg_size = class$total_stu / class$total_class

#========== get gender ratio clean data ===========
gender <- read.csv("Graduation_Outcomes_School_Level_Classes_of_2005-2011_Gender.csv", header=T, stringsAsFactors = F)
gender = subset(gender, Cohort.Year==2007 & Cohort.Category=='4 Year August')
names(gender) <- tolower(names(gender))
gender <- select(gender, dbn, demographic, total.cohort.num)

female <- subset(gender, demographic=='Female')
male <- subset(gender, demographic=='Male')
female <- select(female, dbn, total.cohort.num)
male <- select(male, dbn, total.cohort.num)
names(female) = c('dbn', 'female')
names(male) = c('dbn', 'male')
gender <- merge(female, male, by = "dbn", all = TRUE)
gender[is.na(gender)] <- 0
gender$p_male = gender$male / (gender$male + gender$female)

#=========== get income data =============
income <- read.csv("zipcode_income.csv", header=T, stringsAsFactors = F)
colnames(income) = c('zip', 'zip_lonlat', 'zip_pop', 'avg_household')


#=========== join tables ============
hsSAT <- inner_join(sat, hs, by="dbn")
all_joined <- left_join(hsSAT, safety, by='dbn')
all_joined <- left_join(all_joined, class, by='dbn')
all_joined <- left_join(all_joined, gender, by='dbn')
all_joined <- left_join(all_joined, income, by='zip')

countClasses <- function(x) {
  xs <- strsplit(x, ";", fixed=TRUE)
  l = length(xs[[1]])
  return(l)
}

apclass <- sapply(join$advancedplacement_courses, countClasses)
apclassOnline <- sapply(join$online_ap_courses, countClasses)

join$numAPclasses<- data.frame(apclass + apclassOnline, stringsAsFactors = F)



