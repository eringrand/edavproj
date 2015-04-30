#setwd("~/Documents/Repository/edavproj/data/")
require(dplyr)

#==========get directory of high schools and SAT results =============
hs <- read.csv("DOE_High_School_Directory.csv", header=T, stringsAsFactors = F)
hs <- select(hs, -boro, -se_services, -ell_programs,  -school_accessibility_description, -number_programs)
hs$lonlat <- tail(strsplit(hs$Location, '\n')[[1]], n=1)

countClasses <- function(x) {
  xs <- strsplit(x, ",", fixed=TRUE)
  l = length(xs[[1]])
  return(l)
}

hs$advancedplacement_courses <- sapply(hs$advancedplacement_courses, countClasses)
hs$online_ap_courses <- sapply(hs$online_ap_courses, countClasses)
hs$total_students <- as.numeric(hs$total_students)

sat <- read.csv("SAT_Results_2012.csv", header=T, stringsAsFactors = F)
names(sat) <- tolower(names(sat))
sat <- select(sat, -school.name)
colnames(sat) <- c('dbn', 'num_taker', 'critical_avg', 'math_avg', 'writing_avg')
sat$num_taker <- as.numeric(sat$num_taker)
sat$critical_avg <- as.numeric(sat$critical_avg)
sat$math_avg <- as.numeric(sat$math_avg)
sat$writing_avg <- as.numeric(sat$writing_avg)
sat <- na.omit(sat)

#========= get safety report ================
safety <- read.csv("School_Safety_Report.csv", header=T, stringsAsFactors = F)
names(safety) <- tolower(names(safety))
safety <- select(safety, -address, -location.name, -location.code, -borough, -building.name, -engroupa, -schools.in.building, -building.code, -id, -register, -rangea)
# according to http://schools.nyc.gov/OurSchools/SchoolSafetyReport.htm: N/A means 0 crime
safety[safety == 'N/A'] <- 0
safety_wodbn <- select(safety, -dbn)
safety_wodbn <- sapply(safety_wodbn, as.numeric)
safety_wodbn <- data.frame(safety_wodbn)
safety <- cbind(safety$dbn, safety_wodbn)
colnames(safety)[1] = 'dbn'

#========= get class size clean data =============
class_size <- read.csv("2010-2011_Class_Size_School-level_detail.csv", header=T, stringsAsFactors = F)
# construct dbn from CSD and schoolcode
csd1 <- subset(class_size, CSD<10)
csd2 <- subset(class_size, CSD>=10)
csd1$dbn <- paste0('0', csd1$CSD, csd1$SCHOOL.CODE)
csd2$dbn <- paste0(csd2$CSD, csd2$SCHOOL.CODE)
class_size <- rbind(csd1, csd2)

class_size <- select(class_size, dbn, GRADE, NUMBER.OF.STUDENTS...SEATS.FILLED, NUMBER.OF.SECTIONS, AVERAGE.CLASS.SIZE, SIZE.OF.SMALLEST.CLASS, SIZE.OF.LARGEST.CLASS)
colnames(class_size) <- c('dbn', 'grade', 'num_stu', 'num_class', 'avg_size', 'smallest_size', 'largest_size')

require(sqldf)
class <- sqldf("SELECT dbn, sum(num_stu),sum(num_class) FROM class_size WHERE grade='09-12' GROUP BY dbn")
colnames(class) <- c('dbn', 'total_stu', 'total_class')
class$avg_size <- class$total_stu / class$total_class

#========== get gender ratio clean data ===========
gender <- read.csv("Graduation_Outcomes_School_Level_Classes_of_2005-2011_Gender.csv", header=T, stringsAsFactors = F)
gender <- subset(gender, Cohort.Year==2007 & Cohort.Category=='4 Year August')
names(gender) <- tolower(names(gender))
gender <- select(gender, dbn, demographic, total.cohort.num)

female <- subset(gender, demographic=='Female')
male <- subset(gender, demographic=='Male')
female <- select(female, dbn, total.cohort.num)
male <- select(male, dbn, total.cohort.num)
names(female) <- c('dbn', 'female')
names(male) <- c('dbn', 'male')
gender <- merge(female, male, by = "dbn", all = TRUE)
gender[is.na(gender)] <- 0
gender$p_male <- gender$male / (gender$male + gender$female)

#=========== get income data =============
income <- read.csv("zipcode_income.csv", header=T, stringsAsFactors = F)
colnames(income) <- c('zip', 'zip_lonlat', 'zip_pop', 'avg_household')
income$avg_household <- gsub('\\$','',income$avg_household)
income$avg_household <- gsub(',','',income$avg_household)
income$avg_household <- as.numeric(income$avg_household)

#=========== join tables ============
hsSAT <- inner_join(sat, hs, by="dbn")
all <- left_join(hsSAT, safety, by='dbn')
all <- left_join(all, class, by='dbn')
all <- left_join(all, gender, by='dbn')
all <- left_join(all, income, by='zip')

#=========== correlation models ============
normalize <- function(x) {
  mean <- mean(x[is.na(x)==FALSE])
  sd <- sd(x[is.na(x)==FALSE])
  normalized_x <- (x-mean)/sd
  return(normalized_x)
}
all$critical_norm <- normalize(all$critical_avg)
all$math_norm <- normalize(all$math_avg)
all$writing_norm <- normalize(all$writing_avg)
all$avg_household_norm <- normalize(all$avg_household)
all$p_male_norm <- normalize(all$p_male)
all$avg_size_norm <- normalize(all$avg_size)
all$avgofmajor.n_norm <- normalize(all$avgofmajor.n)
all$avgofvio.n_norm <- normalize(all$avgofvio.n)

# simple regression to class size: R^2 low but coefficient significant
fit <- lm(all$math_norm ~ all$avg_size_norm, na.action=na.exclude)
summary(fit)
plot(all$avg_size_norm, all$math_norm)
abline(fit)
# 2nd order regression to class size: R^2 a little higher
fit <- lm(all$math_norm ~ all$avg_size_norm + I(all$avg_size_norm^2), na.action=na.omit)
summary(fit)
plot(all$avg_size_norm, all$math_norm)
lines(sort(na.omit(all$avg_size_norm)), fitted(fit)[order(na.omit(all$avg_size_norm))])

#studentsurvey <- read.csv("2013NYCschoolsurvey/studentscore.csv", header=T, stringsAsFactors = F)

fit <- lm(all$math_norm ~ all$avg_household_norm, na.action=na.exclude)
summary(fit)
plot(all$avg_household_norm, all$math_norm)
abline(fit)

fit <- lm(all$math_norm ~ all$advancedplacement_courses, na.action=na.exclude)
summary(fit)
plot(all$advancedplacement_courses, all$math_norm)
abline(fit)


