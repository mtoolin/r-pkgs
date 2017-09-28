# Author: Michael Toolin
# Taken from pages 49-50 of O'Neil and Schutt

#require(gdata)
require(plyr) #Added by Monnie McGee
#install the gdata and plyr packages and load in to R.

#setwd("C:/MSDS 6306-FALL2016/404/Live session 06")
setwd ("C:/Users/Mike/Documents/Doing Data Science - MSDS 6306/HW4 Prob 2")
## You need a perl interpreter to do this on Windows.
## It's automatic in Mac
#bk <- read.xls("rollingsales_brooklyn.xls",pattern="BOROUGH")

# So, save the file as a csv and use read.csv instead
#bk <- read.csv('http://www1.nyc.gov/home/search/index.page?search-terms=Rolling+sales+update/rollingsales_brooklyn.csv',skip=4,header=TRUE)
bk <- read.csv('data/rollingsales_brooklyn.csv',skip=4,header=TRUE)

## Check the data
head(bk)
summary(bk)
str(bk) # Very handy function!

## clean/format the data with regular expressions
## More on these later. For now, know that the
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.
bk$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", bk$SALE.PRICE))
count(is.na(bk$SALE.PRICE.N))

names(bk) <- tolower(names(bk)) # make all variable names lower case

## TODO: Get rid of leading digits bk$gross.square.feet as above bk$SALE.PRICE
## Create a new variable that is a 'clean' version of gross.square.feet
bk$gross.square.feet.n <- as.numeric(gsub("[^[:digit:]]","", bk$gross.square.feet))
count(is.na(bk$gross.square.feet.n))

# TODO: Get rid of leading digits of bk$land.sqft as above bk$SALE.PRICE
## Create a new variable that is a 'clean' version of land.sqaure.feet
bk$land.square.feet.n <-  as.numeric(gsub("[^[:digit:]]","", bk$land.square.feet))
count(is.na(bk$land.square.feet.n))
  
bk$year.built <- as.numeric(as.character(bk$year.built))

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
attach(bk)
hist(sale.price.n) 
detach(bk)

## keep only the actual sales
bk.sale <- bk[bk$sale.price.n!=0,]
plot(bk.sale$gross.square.feet.n,bk.sale$sale.price.n)
plot(log10(bk.sale$gross.square.feet.n),log10(bk.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
bk.homes <- bk.sale[which(grepl("FAMILY",bk.sale$building.class.category)),]
dim(bk.homes)

# TODO: complete plot() with log10 of bk.homes$gross.sqft,bk.homes$sale.price.n
#   as above "bk.sale"
plot(bk.homes$gross.square.feet, bk.homes$sale.price.n)
plot(log10(bk.homes$gross.square.feet.n),log10(bk.homes$sale.price.n))


## remove outliers that seem like they weren't actual sales
bk.homes$outliers <- (log10(bk.homes$sale.price.n) <=5) + 0

# TODO: find out homes that meets bk.homes$outliers==0  MT this nees work!!!
bk.homes <- bk.homes[which(bk.homes$outlier==0),]
summary(bk.homes[which(bk.homes$sale.price.n<100000),])
plot(log10(bk.homes$gross.square.feet.n),log10(bk.homes$sale.price.n))
