require(gdata)
require(dplyr)

x <- read.xls ("acs_select_econ_08to12_ntas_edited.xlsx", sheet = 1, header = TRUE, stringsAsFactors = F)
xnew <- data.frame(t(x))
xnew <- mutate(xnew, names=rownames(xnew))
x2 <- xnew
x2 <- filter(xnew, xnew$X1 != "Percent")
x2 <- filter(x2, x2$X1 != "Percent MOE")
xsel <- select(x2, names, X1, X6, X7, X27, X28, X29, X30, X31, X32, X33, X34, X35, X36, X37, X12)
colnames <- c("Neighborhood", "X1", "Employed",   "Unemployed", "Total households",  
              "Less than $10,000", "$10,000 to $14,999",  "$15,000 to $24,999",  
              "$25,000 to $34,999",  "$35,000 to $49,999", "$50,000 to $74,999",  
              "$75,000 to $99,999",  "$100,000 to $149,999",  "$150,000 to $199,999", 
              "$200,000 or more", "Unemployment.Rate")
names(xsel) <- colnames
xsel <- xsel[-1,]

require(reshape2)

writeIDS <- function(longname) {
  names2 <- strsplit(longname, ".", fixed=T)[[1]]
  id <- names2[1]
  name <- names2[2]
  return(id)
}

writenames <- function(longname) {
  names2 <- strsplit(longname, ".", fixed=T)[[1]]
  id <- names2[1]
  name <- names2[-1]
  name <- paste(name, sep=" ", collapse=" ") 
  return(name)
}

  
xsel$ID <- sapply(xsel$Neighborhood, writeIDS)
xsel$ID[2:3] <- "BK72"  

xsel$name <- sapply(xsel$Neighborhood, writenames)
 

### Getting a matching between Neighborhood name and NTA ID
comp <- select(xsel, ID, name)
comp <- distinct(comp, ID)





####
xsel$Unemployed <- as.numeric(xsel$Unemployed)
xsel$Employed <- as.numeric(xsel$Employed)
xsel <- xsel %>% mutate(fracunemployed = Unemployed / Employed)

final <- xsel
#final <- select(xsel, ID, X1, fracunemployed, Unemployment.Rate)

