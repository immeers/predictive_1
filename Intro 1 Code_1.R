#  Topic 1: R basics 

## These R-notes contain explanatory text, R code examples, 
## and in-class exercises. 
## I highly recommend taking notes by editing this file. Follow 
## along, write down solutions to in-class exercises and take notes
## using comments as you need.

rm(list=ls())

#### Variable names -----------
# ChatGPT Prompt: "Explain the rules for valid variable names in R and give examples of valid and invalid variable names."

## LHS = Variable name you give 
## RHS = the actual data 
## A valid variable name consists of letters, numbers and the dot or underline characters. 
## The variable name starts with a letter or the dot not followed by a number.
## valid: 
## var_name2
## var_name2.
## .var_name
## invalid: 
## var_name%
## 2var_name
## _var_name
## .2var_name

# var_name% = 2


# Five basic data types -------------------------------
# character
# numeric (real or decimal)
# integer
# logical
# complex

### character 
classNumber = "MSSA60220"

className = "Predictive Analytics"

classContent = "R, regression, classification and prediction"

# ChatGPT Prompt: "What does the class() function do in R? What will it return when applied to the variables classNumber and classContent?"
class(classNumber)
class(classContent)

### numeric (real or decimal)
x = 1.2
x = 3.33333
class(x)

### integer
y = 2.0
y = as.integer(y)
class(y)

### logical
z = TRUE 
z = FALSE 

z = T
z = F
class(z)


# Numerical operations ------------------------------------------------------------
1 + 1
2*10 
10/2 
exp(2)
log(10, base = exp(1))
log(x=10, base = 10)

# Vectorized operations --------------------------------------------------------------------
# Vectorized operations are computations applied simultaneously to entire arrays or large blocks of data, 
# rather than iterating over individual elements

#ChatGPT Prompt: "Create two vectors vec_a and vec_b in R with the elements c(1, 2, 3, 4) and c(10, 11, 12, 13), respectively. What do these vectors represent?"
vec_a = c(1, 2, 3, 4)
vec_b = c(10, 11, 12, 13)

# Q: What are the answers for: 
vec_a + vec_b

# Q: What are the answers for: 
vec_a * 10

# Q: What are the answers for: 
vec_a + "60"

# Q: What are the answers for: 
vec_a + 60


# matrix multiplication 
beta_vec_sol = c(0.5, -1.2, 3.3)
beta_vec_sol

x1_vec_sol = c(1, 17, 22)
x1_vec_sol

sum(x1_vec_sol * beta_vec_sol)

as.numeric(x1_vec_sol %*% beta_vec_sol)


# Vectors -------------------------------
# A vector is a collection of elements that are most commonly of mode character, logical, integer or numeric.
# The elements of a vector must be of the same data type.

## check the command
?vector
## Create an empty vector named vec 
vec = vector()

## Specify a mode for the empty vector of length 5 
vec_char = vector(mode = "character", length = 5) 

## check the class 
class(vec_char)

## check the length of that vector 
length(vec)
length(vec_char)


## specific the content of a vector 
vec_num1 = c(1,2,3,4)
vec_num2 = 1:4
vec_num3 = seq(from = 1, to = 4, by = 1)


## extract the third item of the vec_num
vec_num1[3]


## extract all the items EXCEPT the first one 
vec_num1[-1]

## note that this does not change the vector named "vec_num1"
## to make changes, you need to SAVE it 
vec_num1 = vec_num1[-1]


## attach a fifth item, number 10,to vec_num2
vec_num2
# way1 
vec_num2 = c(vec_num2, 10)

# way 2 
vec_num2 = 1:4
vec_num2[length(vec_num2) + 1] = 10 


# Matrices ---------------------
# vectors with dimensions with a number of rows and columns (SHOW PPT)
# The elements of a matrix must be of the same data type.

mat = matrix(nrow = 2, ncol = 2)
mat

## dimension
dim(mat)

mat1 = matrix(nrow = 3, ncol = 2)
dim(mat1)[1] # the number of rows
dim(mat1)[2] # the number of columns 

## class
class(mat)


## fill a matrix by column 
mat_col = matrix(1:6, nrow = 2, ncol = 3, byrow = FALSE)

## fill a matrix by row 
mat_row = matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE)


## extract the first row 
mat_row[1, ]
mat_row[3,] # error 


## extract the first column 
mat_row[ ,1]

## extract the item in the first row and first column 
mat_row[1,1]
mat_row[1,3]


## Add a new row 
mat_row = rbind(mat_row, 7:9)
mat_row = rbind(mat_row, 7:10)


## Add a new column 
mat_row = cbind(mat_row, 10:13)
mat_row = cbind(mat_row, 10:12)
mat_row



# List -------------------------------

# Lists act as a container 
# Not restricted to a single mode. Can have any mixture of data types: 
# Lists of vectors 
# Lists of data frames 
# Lists of lists

# Prompt: "Generate R code to create a list named aList with elements 1, "MSSA60220", TRUE, and 10. Then, display the list." 
aList = list(1, "MSSA60220", TRUE, 10)
aList

## the length of the list 
length(aList)


## get the second time
aList[2] # gives you a list 
class(aList[2])


aList[[2]] # gives you a list 
class(aList[[2]]) # gives you the specific item 


## add a new item 
aList[[length(aList) + 1]] = "R is great"
aList


## create a list with names for each item 
classAttribute = list(Number = "MSSA60220", Name = "Predictive Analytics", 
                      numStudents = 20)
classAttribute


# Data frame -------------------------------

# Data Frame: 
# VERY IMPORTANT 
# A special type of list 
# Every element of the list has the same length 

# Prompt: "Generate R code to create a data frame named df with three columns: id containing the first 10 letters of the alphabet, x containing the numbers 1 through 10, and y containing the numbers 11 through 20. Then, display the data frame."
df = data.frame(id = letters[1:10], x = 1:10, y = 11:20)
df
dim(df)

## the head of the data frame 
head(df)
head(df, 3)

## the tail of the data frame 
tail(df)
tail(df,3)

## the item in the 3rd row, 2nd column 
df[3,2]

## add a new row
df = rbind(df, c("l", 11, 21))

## add a column named z 
dim(df)
df$z = 30:39 # error
df$z = 30:40
dim(df)

# or: 
# cbind: column bind funciton; rbind: row bind function 
# Prompt: "Generate R code to add a new column h with values from 30 to 40 to the existing data frame df using the cbind() function."
df = cbind(df, h = 30:40)


## merge two data frames based on id number 
df1 = data.frame(id = letters[1:10], GPA = seq(from = 3, to = 3.9, by = 0.1), classYear = rep(c("Sophomore", "Junior"),5))
df2 = data.frame(id = letters[1:10], siblings = rep(c("yes", "no"),5))

ddf = merge(df1, df2, by = "id")


## write to a csv file 
library(WriteXLS)
library(openxlsx)


write.csv(ddf, file = "./A data frame.csv", 
          row.names = FALSE)



## read in a csv file 
## gent current directory 
getwd()
dataframe = read.csv("./A data frame.csv", 
                     header = TRUE, stringsAsFactors = FALSE)


dataframe

# Source vs Console  --------------------------------------------------------------------
rm(list=ls())




# Read in data --------------------------------------------
## Get working directory 
getwd()

## Set working directory
setwd("/Volumes/GoogleDrive/My Drive/Teaching /Data Set")
home_data_mod = read.csv("West_Roxbury_Modified.csv")

## First, we load the home values data set.
## If the below code does not work, remember to set your working
## directory by selecting to 
## Session/Set Working Directory/Choose Directory and 
## choosing the folder directory that .csv file is in.
home_data_mod = read.csv(file = "/Volumes/GoogleDrive/My Drive/Teaching /Data Set/West_Roxbury_Modified.csv", 
                      header = TRUE, as.is = TRUE)



## Take a quick look at the data 
str(home_data_mod)



# Checking/Changing the type of each variable --------------------------------------------------------------
## Quantitative variables must be numerical or integer
## Categorical variables can be text, numerical or logical


## to check the value type each column of a data frame: use the function class()
class(home_data_mod$TOTAL.VALUE)
class(home_data_mod$REMODEL)

logical_vec = c(T, F, F)
logical_vec = c(TRUE, FALSE, FALSE)
class(logical_vec)

## You can use following functions to convert your vector from
## one value type to other 
## as.numeric(): to numeric
## as.character(): to text
## as.logical(): to logical
## Though, not all conversions are meaningful. Consider numeric  
## to logical or character to logical.

## Meaningful Examples:
logical_vec = c(T, F, F)
as.numeric(logical_vec)
as.character(logical_vec)

as.numeric(c('1','42','2'))

as.character(c(1,2,3,4,5))

as.logical(c('T', 'F', 'FALSE', 'T'))

is.numeric(c(1,2,3,4))

## three ways to access tax column of the home values dataset
str(home_data_mod)


head(home_data_mod[ , 2])
head(home_data_mod[ , "TAX"], 10)
head(home_data_mod$TAX)

## Use colnames() to check the names of columns
colnames(home_data_mod)
rownames(home_data_mod)



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











