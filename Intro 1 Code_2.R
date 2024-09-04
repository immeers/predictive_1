#  Topic 1: R basics cont. 
library(ggmap)
library(ggplot2)
library(dplyr)
library(plyr)
library(MASS)
library(tidyr)

rm(list=ls())
getwd()
## One convenient way of working on R in this class 
#setwd("/Users/jke/Desktop/intro 1") 

# If statement ------------------------------------------------------------
## If statements can be very useful in R. Often, you want to make 
## choices and take action dependent on a certain value.
# Prompt: "Generate R code that uses an if-else statement to assign a value to the variable y. If x is less than 3, assign x to y; otherwise, assign 3 to y. Assume x is initialized with a value of 5."

x = 5
if(x < 3){
  y = x
}else{
  y = 3
}

y


## Version 1: Will not run, just to show you the syntax
if(test_condition){
  ## if test_condition is TRUE, do something
} 
## Continue with rest of code


## Version 2: Will not run, just to show you the syntax
if(test_condition) {
  ## if test_condition is TRUE, do something
}else{
  ## if test_condition is FALSE, do something else
}
## Continue with rest of code


## Version 3: Will not run, just to show you the syntax
if(test_condition_1){
  ## if test_condition_1 is TRUE, do something
  if(test_condition_2_1){
    ## if test_condition_1 is FALSE AND if test_condition_2 is TRUE,
    ## do something different
  }else{
    ## if test_condition_1 is FALSE AND if test_condition_2 is FALSE,
    ## do something different
  }
}else{
  if(test_condition_2_2){
    ## if test_condition_1 is FALSE AND if test_condition_2 is TRUE,
    ## do something different
  }else{
    ## if test_condition_1 is FALSE AND if test_condition_2 is FALSE,
    ## do something different
  }
} 

## IF() ELSE() FUNCTION VS. IF-ELSE STATEMENTS
## Recall that ifelse() function checks the condition given
## in argument test, if test is TRUE, returns the argument yes,
## otherwise returns the argument no.
## ifelse() is a vectorized function, meaning that it is applied
## to all elements of the vector in order.
vector_ex = c(10,20,30,40)
ifelse(test = vector_ex > 15, yes = 1, no = 0)

## If-else statements are a related but different concept. Its 
## test_condition CANNOT be a vector, it has to be a scalar. It is
## used when you want to execute multiple commands based on the 
## result of the condition.


## Example 1:
# You want your code to calculate the price you need to charge
# to each customer based on your hours of worked for the customer
# and your hourly rate. Also, you are giving a discount for big 
# customers (if the hours you worked on the job is more than 100 hours )
hours_worked = 120
base_price = 40
discount_rate = 0.2

if (hours_worked > 100) {
  # Apply discount if customer qualifies
  net_price <- base_price * (1 - discount_rate)
} else {
  # No discount applied
  net_price <- base_price
}

net_price


## Example 2: multiple customers 
customer_df = data.frame(ID = c(1,2,3,4,5), 
                         hours_of_work = c(10, 15, 20, 30, 100), 
                         price_per_hour = 40)


#### Group work  

if(customer_df$hours_of_work >= 100){
 # giving the discount if customer qualifies
 customer_df$net_price = customer_df$hours_of_work * customer_df$price_per_hour * (1 - discount_rate)
}

#  because the if statement in R expects a single logical value (TRUE or FALSE), but customer_df$hours_of_work >= 100 is likely returning a vector of logical values (one for each row in your customer_df data frame).
customer_df$net_price = ifelse(customer_df$hours_of_work >= 100,
                               customer_df$hours_of_work * customer_df$price_per_hour * (1 - discount_rate),
                               customer_df$hours_of_work * customer_df$price_per_hour)



## Example 3:
## Continuing from example 2, your tax rate 
## depends on whether client is public, private, or foreign.
hours_of_work = 200
price_per_hour = 40
client_type = 'abroad' #can be public, private or abroad

#First, calculate net price like in Example 2
net_price = hours_of_work*price_per_hour
if(hours_of_work > 100){
  net_price = net_price * 0.9
}
net_price

# Add tax based on client_type
## prompt: Write an R script that calculates the total price including VAT based on the client type. If the client_type is 'private', apply a 12% VAT to the base_price. If the client_type is 'public', apply a 6% VAT. If the client_type is unknown, set total_price to NA and display a message 'Unknown client type'. Return the total_price at the end.

if (client_type == "private") {
  total_price <- base_price * 1.12  # 12% VAT
} else if (client_type == "public") {
  total_price <- base_price * 1.06  # 6% VAT
} else {
  total_price <- NA  # what is the type of this client?
  message("Unknown client type")
}

total_price


## here because client_type is abroad, which is neither private nor public, the 
## statements below will not give a value to total_price, thus you will see 
## an error : object 'total_price' not found
rm(list = ls())
hours_of_work = 200
price_per_hour = 40
client_type = 'public' #can be public, private or abroad

#First, calculate net price like in Example 2
net_price = hours_of_work*price_per_hour
if(hours_of_work > 100){
  net_price = net_price * 0.9
}
net_price

if(client_type == 'private'){
  total_price = net_price * 1.12      # 12% VAT
}else{
  if(client_type == 'public'){
    total_price = net_price * 1.06 # 6% VAT
  }
}  

total_price




# Example 2 House Prices ------------
rm(list = ls())

## First, we load the home values data set.
## If the below code does not work, remember to set your working directory by selecting to 
## Session/Set Working Directory/Choose Directory and 
## choosing the folder directory that .csv file is in.

getwd()
dir = "C:/Users/immim/OneDrive/Notre Dame/Predictive/"
home_data = read.csv(file = paste0(dir, "HousePrices.csv"), 
                     header = TRUE, as.is = TRUE)



#### Take a quick look at the data 
str(home_data)


# Checking/Changing the type of each variable --------------------------------
## Quantitative variables must be numerical or integer
## Categorical variables can be text, numerical or logical

## to check the value type each column of a data frame: use the function class()
class(home_data$SalePrice)
class(home_data$BldgType) # Type of dwelling
count(home_data$BldgType) # Type of dwelling
# 1Fam	Single-family Detached; 2FmCon	Two-family Conversion; originally built as one-family dwelling
# Duplx	Duplex; TwnhsE	Townhouse End Unit; TwnhsI	Townhouse Inside Unit

## Two ways to access LotArea column of the home values dataset
str(home_data)

head(home_data[ , "LotArea"], 10)

head(home_data[ , 5])
head(home_data$LotArea)

## Use colnames() to remember the names of columns
colnames(home_data)
rownames(home_data)


# Describe and visualize quantitative variables ------------------------------

## Numerical description ----------------------
# SalePrice

# Mean
mean(home_data$SalePrice)
# Median
median(home_data$SalePrice)
# Max
max(home_data$SalePrice)
# Min
min(home_data$SalePrice)
# Standard deviation
sd(home_data$SalePrice)
# Variance
var(home_data$SalePrice)


summary(home_data$SalePrice)

# exercise: find the mean of YearBuilt 

summary(home_data$YearBuilt)

## remove NA
mean(home_data$YearBuilt, na.rm = TRUE)


## Visualization  ------------------------------


#### HISTOGRAM
## Below code returns the histogram of the total values column
## of our dataset
hist(home_data$SalePrice)

## To get the histogram for other variables, change the column
## name after $ sign. You can use function colnames() to check
## the name of different columns. 
colnames(home_data)

# Use ggplot
install.packages("ggplot2")
library(ggplot2)

# http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization

### prompt: Create a ggplot2 visualization in R that shows a histogram of house sale prices from a dataset called home_data. Label the x-axis as 'House Value ($)' and the y-axis as 'Number of Houses'
ggplot(home_data, aes(x=SalePrice)) + geom_histogram() + 
  xlab("House Value ($)") + 
  ylab("Number of Houses")

# Q: How is this skewed? 


#### BOXPLOT
## Below code returns the box plot of the total values column
## of our dataset
boxplot(home_data$SalePrice) 


## exercise: use ggplot
ggplot(home_data, aes(x=SalePrice)) + geom_boxplot()



# Describe and visualize categorical variables ------------------------------

## Numerical description ----------------------

## table() function returns a table that summarizes the count of
## observations for each category
# Kitchen quality: Ex	Excellent; Gd	Good; TA	Typical/Average; Fa	Fair; Po	Poor
a = table(home_data$KitchenQual)
a[2,3] # error
class(table(home_data$KitchenQual))
## Unfortunately, table() is not subsettable, so you cannot use []

df = as.data.frame(table(home_data$KitchenQual))
df[3,2] 

## Unfortunately, table() is not subsettable, so you cannot use []



## visualization ---------------------------------------------
## barplot() function takes the table() function of your variable
## as its input and creates a bar chart
barplot(table(home_data$KitchenQual))

# use ggplot
## prompt: Create a bar plot in R using ggplot2 to visualize the distribution of kitchen quality ratings from a dataset called home_data. The KitchenQual column should be used on the x-axis, and the plot should show the count of each kitchen quality category.
ggplot(home_data, aes(x=KitchenQual)) + geom_bar()

# the levels' sequence are based on alphabetical order
# reorder: 
home_data$KitchenQual  = factor(home_data$KitchenQual,levels = c("Ex", "Gd", "TA", "Fa", "Po"))

ggplot(home_data, aes(x=KitchenQual)) + geom_bar()



# Describe and visualize relationship between two variables -------------------------

## Quantitative vs. Quantitative ----------------------

## cor() function takes the variables you want to compare as input
## and returns the correlation coefficient 
# GrLivArea = Above grade (ground) living area square feet
cor(home_data$SalePrice, home_data$GrLivArea)
cor(home_data$SalePrice, home_data$YearBuilt)

# remove missing values: 
## In the cor() function in R, the use = "complete.obs" argument specifies how missing values (i.e., NAs) should be handled when calculating the correlation.
cor(home_data$SalePrice, home_data$GrLivArea, use = "complete.obs")
cor(home_data$SalePrice, home_data$YearBuilt, use = "complete.obs")

## You can also input multiple variables to get a matrix of correlation coefficients
cor(home_data[ , c("SalePrice", "GrLivArea", "YearBuilt")], use="complete.obs")


## plot() function takes two quantitative variables you want to 
## plot against as input and creates a scatter plot
## Variable you want on the y-axis ~ Variable you want on the 
## x-axis
plot(home_data$SalePrice ~ home_data$GrLivArea)

## Create a scatter plot using ggplot2 in R to visualize the relationship between GrLivArea and SalePrice from the home_data dataset. Add a linear regression line to the plot using geom_smooth() with the method set to lm.
ggplot(home_data, aes(x = GrLivArea, y = SalePrice)) + 
  geom_point() + 
  geom_smooth(method = lm)


## Categorical vs. categorical ------------------------------------------------------------
## table() function can summarize two categorical variables
## simultaneously
table(home_data$KitchenQual, home_data$OverallQual)




## Quantitative vs. categorical ------------------------------------------------------------
## boxplot() function can be used to create side by side bar plots
boxplot(home_data$SalePrice ~ home_data$KitchenQual)


boxplot(home_data$SalePrice ~ home_data$KitchenQual, 
        main = "Box Plot of Sales Values of Homes with Different Kitchen Quality",
        xlab = "Kitchen Quality",
        ylab = "Total Value",
        border = c("royalblue", "red2", "green1", "grey"))



# Order function ------------------------------------------------------------------------------
# - Room number of five homes with highest room numbers
order(home_data$Bedroom, decreasing = TRUE)
sort(home_data$Bedroom, decreasing = TRUE)

home_data$Bedroom[order(home_data$Bedroom, decreasing = TRUE)[1:5]]


# In-Class Exercises Session 1 ---------------------------------------------------------------------
#1: Calculate the median of number of FullBath

#2: Number of FullBath for observations with indices 100, 200 and 34


#3: Bedroom number of five homes with lowest GrLivArea


median(home_data$FullBath, na.rm = TRUE)
home_data$FullBath[c(100, 200, 34)]
home_data$Bedroom[order(home_data$GrLivArea)[1:5]]



## Dealing with missing data ------------------------------------------------------------------------------
### Detect ------------------------------------------------------------------------------
home_data = read.csv(file = paste0(dir, "Data Sets/HousePrices.csv"), 
                     header = TRUE, as.is = TRUE)

## summary() function tells you which variables have a missing 
## value in them
summary(home_data)

## is.na() is a vectorized function that returns a logical vector
## that tells you whether each element in a vector is NA or not.
na_example = c(1, 2, 4, NA, 5)
is.na(na_example)


## With a large data frame with many observations, getting a huge
## logical vector back is not helpful. So, a better alternative 
## is the following. Following command works because R treats
## logical as numeric when it is in numeric functions. So,
## each TRUE = 1, each FALSE = 0, and sum gives you the
## total number of missing values in a column.
sum(is.na(home_data$HalfBath)) # Four missing values
sum(is.na(home_data$Bedroom)) # Four missing values


## If you just want to know the locations of the missing values: which() function
## returns the locations of TRUEs in a logical vector.
which(c(T,T,F,F,T))
## Above code returns a vector with elements 1,2 and 5

which(is.na(home_data$HalfBath))
which(is.na(home_data$FullBath))
which(is.na(home_data$YearBuilt))
which(is.na(home_data$Fireplaces))


### Delete ------------------------------------------------------------------------------
#### Delete rows, i.e., some specific observation from a data frame: Negative indexing
index_to_delete = which(is.na(home_data$HalfBath))
home_data = home_data[-index_to_delete, ] 

#### Pairwise deletion

#### Delete columns

home_data$HalfBath = NULL
summary(home_data)
# or:
home_data = home_data[ , colnames(home_data) != "HalfBath"]


## removes all data for an observation that has one or more missing values
newdata = na.omit(home_data)
summary(newdata)



### Imputation ------------------------------------------------------------------------------

## If you decided that you can replace missing values with zero,
## here is how you find the locations of missing values
## Below code works because you can use logicals for indexing.
## R is going to replace the value for any index that returns zero
## from is.na().
index_to_replace = which(is.na(home_data$HalfBath))
home_data$HalfBath[index_to_replace] = 0
sum(is.na(home_data$HalfBath)) #NAs are gone


## Replacing the value of an observation with mean
index_to_replace = which(is.na(home_data$YearBuilt))
home_data$YearBuilt[index_to_replace] = 
  mean(home_data$YearBuilt, na.rm = TRUE) 

sum(is.na(home_data$YearBuilt)) #NAs are gone

## Dealing with outlier  ------------------------------------------------------------------------------
### Detect -------------------------
## Couple useful techniques to detect outliers:
## 1) Generate the box plot, look for distant points
boxplot(home_data$SalePrice)
## 2) Generate scatter plots with other columns, look for distant points
plot(home_data$SalePrice ~ home_data$GrLivArea)
## 3) Look for maximum and minimums, do they make sense?
max(home_data$SalePrice)
min(home_data$SalePrice)

# examine the house with the lowest SalePrice


## 4) Sort the column and look for top ten
values_I_want = 1:10 
indices_of_top = order(home_data$SalePrice, 
                       decreasing = TRUE)[values_I_want]
home_data$SalePrice[indices_of_top]


## 5) Sort the column and look for lowest ten
values_I_want = 1:10
indices_of_low = order(home_data$SalePrice, 
                       decreasing = FALSE)[values_I_want]
home_data$SalePrice[indices_of_low]


### Delete and impute --------------------
## First find the exact index of the outlier
which(home_data$SalePrice == 349) # 69th observation

## Replacing the value of an observation with median
outlier = which(home_data$SalePrice == 34900)

home_data[outlier, "SalePrice"] = 
  median(home_data$SalePrice, na.rm = TRUE) 


## Deleting an observation from a data frame: Negative indexing
home_data = home_data[-outlier, ] 
boxplot(home_data$SalePrice)


## Data transformations ----------------------------------------------------------------------
#### DATA TRANSFORMATION
hist(home_data$SalePrice)
## I am creating a new column with transformed SalePrice
home_data$SQRT.SalePrice = sqrt(home_data$SalePrice)
## Look at the new histogram
hist(home_data$SQRT.SalePrice)

## replace sqrt() with log10() for log transformation


## In-Class Exercises ---------------------------------------------------------------------
# - Find the observation numbers whose SalePrice is larger 
#   than 600,000 (HINT: We learned a function that does this)

# - How many observations have a total value higher than
#   600,000? (HINT: You can sum logical values, TRUE is 1, FALSE is 0)

# - Calculate the SalePrice value of each home that has
#   a fireplace and save this information to a vector named
#   values_w_fire


# - Create a new column in home_data dataset with name
#   NEW.Bedroom which has exact same values as the column
#   Bedroom


which(home_data$SalePrice > 600,000)
sum(home_data$SalePrice > 600000)
values_w_fire = home_data$SalePrice[home_data$Fireplaces > 0]
home_data$NEW.Bedroom <- home_data$Bedroom




















