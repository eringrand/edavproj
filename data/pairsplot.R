#setwd("~/Documents/Repository/edavproj/data/")
require(dplyr)
require(reshape2)


#=========== correlation models ============
normalize <- function(x) {
  mean = mean(x[is.na(x)==FALSE])
  sd = sd(x[is.na(x)==FALSE])
  normalized_x = (x-mean)/sd
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

all$diff_time <- as.numeric(difftime(as.POSIXct(all$end_time, format="%I:%M %p"), as.POSIXct(all$start_time, format="%I:%M %p")))

#all$start_time <- strftime(all$start_time, format="%I:%M %p")
#all$end_time <- strftime(all$end_time, format="%I:%M %p")
library(ggplot2)

ggplot(all, aes(y=critical_norm, x=start_time)) + geom_point()
ggplot(all, aes(y=critical_norm, x=end_time)) + geom_point()

all$diff_time_norm <- normalize(all$diff_time)

data <- select(all, critical_norm, math_norm, writing_norm, avg_household_norm, p_male_norm, avg_size_norm, avgofmajor.n_norm, avgofvio.n_norm, diff_time_norm) 

theme_set(theme_bw()) # a theme with a white background

data1 <- select(data, -critical_norm, -math_norm)
names(data1)[1] <- c("sat_norm")

df.m1 <- melt(data1,"sat_norm")
df.m1$SATname <- rep("writing", length(df.m1$sat_norm))

data2 <- select(data, -critical_norm, -writing_norm)
names(data2)[1] <- c("sat_norm")
df.m2 <- melt(data2,"sat_norm")
df.m2$SATname <- rep("math", length(df.m2$sat_norm))

data3 <- select(data, -writing_norm, -math_norm)
names(data3)[1] <- c("sat_norm")
df.m3 <- melt(data3,"sat_norm")
df.m3$SATname <- rep("reading", length(df.m3$sat_norm))

df <- rbind(df.m1, df.m2, df.m3)


# same thing but with averages in the the group by

x1 <- data1 %>%
  group_by(sat_norm) %>%
  summarise_each(funs(mean)) %>%
  melt("sat_norm") 
x1$SATname <- rep("writing", length(x1$sat_norm))

x2 <- data2 %>%
  group_by(sat_norm) %>%
  summarise_each(funs(mean)) %>%
  melt("sat_norm")
x2$SATname <- rep("math", length(x2$sat_norm))

x3 <- data3 %>%
  group_by(sat_norm) %>%
  summarise_each(funs(mean)) %>%
  melt("sat_norm")
x3$SATname <- rep("reading", length(x1$sat_norm))

df2 <- rbind(x1, x2, x3)

# Various versions of the same type of plot
ggplot(x1, aes(value, sat_norm, color=SATname)) + geom_point(na.rm = T) +
  facet_wrap(~ variable, ncol = 3)

ggplot(x2, aes(value, sat_norm, color=SATname)) + geom_point(na.rm = T) +
  facet_wrap(~ variable, ncol = 3)

ggplot(x3, aes(value, sat_norm, color=SATname)) + geom_point(na.rm = T) +
  facet_wrap(~ variable, ncol = 3)

ggplot(df2, aes(value, sat_norm, color=SATname)) + geom_point(na.rm = T) +
  facet_wrap(~ variable, ncol = 3)

ggplot(df, aes(value, sat_norm, color=SATname)) + geom_point(na.rm = T) +
  facet_wrap(~ variable, ncol = 3)



## Normalized SAT historgrams ##
grp_cols <- c("sat_norm","SATname")
dots <- lapply(grp_cols, as.symbol)

sathist <- df %>%
  group_by_(.dots=dots) %>%
  summarise(n=n())

ggplot(sathist, aes(x=sat_norm, color=SATname)) +
  geom_histogram(binwidth=.5, aes(fill=SATname))



