rm(list = ls())
library(ggmap)
library(ggplot2)
library(dplyr)
library(plyr)
library(MASS)

#  Topic 2: Regression Models

getwd()

## Dataset is on Canvas

dir = "." ## fill in directory here if you need to, "." represent current directory 
performance = read.csv(file = paste0(dir, "/Team_Performance.csv"), header = TRUE, as.is = TRUE)

#Performance: Team performance score (in thousands).
#OpponentScore: Score of the opposing team at each game.
#TeamBudget: Team's budget level (in thousands of dollars).
#TeamPromotion: Local promotion/advertising budget for the team (in thousands of dollars).
#StadiumAttendance: Attendance at the stadium (in thousands).
#TicketPrice: Price charged for game tickets (in dollars).
#HomeAdvantage: A factor with levels 'Bad', 'Medium', and 'Good', indicating the level of home advantage at the game location.
#PlayerPlayerAge: Average age of the players on the team.
#TeamExperience: Average level of team experience at each location (in years).
#IsUrbanGame: A factor with levels 'Yes' and 'No' to indicate whether the game is held in an urban location.
#IsUSGame: A factor with levels 'Yes' and 'No' to indicate whether the game is held in the United States.


## Step 1: Determine the purpose of your analysis ----------------------------

## Step 2: Collect and prepare data ----------------------------
## Step 3: Exploratory data analysis ----------------------------

## Step 4: Data partition ----------------------------
## Split the data into training (60-70%), validation (15-20%), and test (15-20%) sets ----------------------------

## I decided to divide the dataset as 60% training, 20% validation, and 20% test
## First we calculate the size of the training set given the size of the full dataset
train_size <- 0.6 * nrow(performance)
valid_size <- 0.2 * nrow(performance)
test_size <- 0.2 * nrow(performance)

## Since we will partition our data randomly, use set.seed to ensure
## that you get the same training and validation datasets every time
set.seed(1)

## Using sample() function, we generate random integers, each represent a row number. 
## Selected rows will be used in the training set and the rest will be used in the test set. 
## Replace is false because we do not want the same row to be selected twice.
## Set Diff will remove the index we selected from performance 
train_index <- sample(x = performance$ID, size = train_size, replace = F)
valid_index <- sample(setdiff(performance$ID, train_index), size = valid_size, replace = F)
test_index <- sample(setdiff(performance$ID, c(train_index, valid_index)), size = test_size, replace = F)

# check if the indices are unique 
# the %in% operator checks if there are overlaps in the data and returns a logic statement (T/F)
any(train_index %in% valid_index)
any(test_index %in% valid_index)

## Finally, we partition our dataset into two based on the selected row 
## numbers
train_set <- performance[train_index, ]
valid_set <- performance[valid_index, ]
test_set = performance[test_index, ]

## Step 5 and 6: Choose a model and Build a simple linear regression model ----------------------------
## The function lm() calculates the fitted linear regression model by minimizing the mean squared error.
## The first argument of the function is formula in which you specify the target variable and the predictor variable using the column names. 
## The second argument is called data and it is the name of the dataframe that includes the dataset you want to use.
## We always use the training set to fit our linear regression line.
fit_sim_reg <- lm(formula = Performance ~ PlayerAge, data = train_set)

## Step 7: Interpret the model ----------------------------
## To see the fitted coefficient values, their p-values, R-square
## and F-test values, you use summary() function.
summary(fit_sim_reg)


## Step 8: evaluate the model on the validation set ----------------------------
#### MAKING PREDICTIONS USING THE FITTED MODEL
## Let's use the simple regression model we fit to predict the prices of the cars in the validation dataset.

## For prediction, we use a function called predict(). There are
## two arguments, first one is called object, it is the name of 
## the linear regression model you want to use for prediction.
## Second one is called newdata, it includes the dataset that
## includes the observations whose prices will be predicted.
pred_performance <- predict(object = fit_sim_reg, newdata = valid_set)


## Function accuracy() from a packPlayerAge called forecast calculates multiple prediction accuracy measures. 
## There are two arguments, first one is predicted prices and the second argument is the actual prices.
# install.packPlayerAges('forecast') #if you have not
library(forecast)
accuracy(pred_performance, valid_set$Performance)

## Generating box-plot of prediction errors
all_errors <- valid_set$Performance - pred_performance
boxplot(all_errors, main= "Box plot of Prediction Errors")

hist(all_errors, main= "Box plot of Prediction Errors")

## Step 9: Predict the target variable in the test data set and evaluate its predictive performance ----------------------------


## We already calculated the predictive performance for validation set
accuracy(pred_performance, valid_set$Performance)

### Now, we calculate the predictive performance for test set  ----------------------------
pred_performance_test <- predict(object = fit_sim_reg, newdata = test_set)
accuracy(pred_performance_test, test_set$Performance)

### The library() function is used to load libraries, or groups of functions 
### and data sets that are not included in the base R distribution
sim_mod = lm(Performance ~ PlayerAge, data = train_set)
summary(sim_mod)

### In order to obtain a confidence interval for the coefficient estimates, 
### we can use the confint() command.
confint(sim_mod)

## The predict() function can be used to produce confidence intervals 
  ## of medv for a given value of lstat

predict(sim_mod, 
        data.frame(PlayerAge = c(30, 40, 50, 60)), 
        interval = "confidence")


### We will now plot medv and lstat along with the least squares regression line 
### using the plot() and abline() functions.
plot(x = train_set$Performance, y = train_set$PlayerAge) 
abline(sim_mod)

ggplot(data = train_set, aes(x = PlayerAge, y = Performance)) + 
  geom_point() + 
  geom_smooth(method='lm')

#### Group work #### 
## Which single predictor would work the best?

### test predictor on outcome variable 
### what is the evaluation metrics of prediction 
### how do you interpret it
### is the interpretation meaningful? Why and why not? 
### can the result be used in future decision making?
### is the finding generalizable? 

ggplot(data = train_set, aes(x = TicketPrice, y = Performance)) + 
  geom_point() + 
  geom_smooth(method='lm')


ggplot(data = train_set, aes(x = TeamPromotion, y = Performance)) + 
  geom_point() + 
  geom_smooth(method='lm')



## Multiple linear regression model -------------
### we again use the lm() function. The syntax lm(y∼x1+x2+x3) is used to fit 
  ### a model with three predictors, x1, x2, and x3. 

mul_mod = lm(Performance ~ PlayerAge + TicketPrice, data = performance) 
summary(mul_mod)

mul_mod2 = lm(Performance ~ PlayerAge + TicketPrice + StadiumAttendance, data = performance) 
summary(mul_mod2)


## Example 2 Advertising ---------------

rm(list = ls())
dir = "." ## fill in directory here if you need to, "." represent current directory 
Advertising = read.csv(file = paste0(dir, "/Advertising.csv"))

summary(Advertising)
# 1 Is there a relationship between advertising budget and sales?
mod = lm(sales ~ TV + radio + newspaper, data = Advertising)
summary(mod)
## the p-value from the F statistic is small, thus yes

# 2  How strong is the relationship between advertising budget and Performance? 
## R^2 is high, so yes. 


# 3  Which media contribute to Performance?
## TV and Radio have small p-values, so they do 
## newspaper has a big p-value, so newespaper does not 


# 4  How accurately can we estimate the effect of each medium on Performance? 
## The confidence intervals for TV and radio are narrow and far from zero, 
## providing evidence that these media are related to Performance. 
## But the interval for newspaper includes zero, indicating that the variable is 
## not statistically significant given the values of TV and radio.
confint(mod)


# 5  How accurately can we predict future Performance?
## first divide the data set into training and validation data set
## then predict() and then accuracy() functions using the model on the validate set 



## In class exercise: Iowa Home data (HousePrices.csv) ----------------
dir = "." ## fill in directory here if you need to, "." represent current directory 
home_data = read.csv(file = paste0(dir, "/HousePrices.csv"), 
                     header = TRUE, as.is = TRUE)

# Q1 Graphically explore a few variables, their distributions, relationships with the SalePrice dependent variable
## which variables do you think would be good predictors? and Why?

# Q2 Go though the steps of building a predictive model, and report your predictive performance

# Q3 which combination of predictors work the best in predicting the sale prices? 



# --------- more than a linear model ----------------------

## Interaction terms -----------------
### The syntax TV:radio tells R to include an interaction term between TV and radio 
### The syntax TV*radio simultaneously includes TV, radio, 
  ### and the interaction term TV × radio as predictors; it is a shorthand for TV + radio + TV:radio

dir = "." ## fill in directory here if you need to, "." represent current directory 
Advertising = read.csv(file = paste0(dir, "/Advertising.csv"))

summary(Advertising)

mod = lm(sales ~ TV + radio + newspaper, data = Advertising)
summary(mod)

# Q  Is there synergy among the advertising media, i.e., any interaction effect?
mod = lm(sales ~ TV * radio, data = Advertising)
summary(mod)

mod = lm(sales ~ TV + radio + TV:radio, data = Advertising)
summary(mod)

mod = lm(sales ~ radio * newspaper, data = Advertising)
summary(mod)

# The I() function is used to indicate that newspaper^2 should be interpreted as a mathematical operation (squaring the newspaper variable) rather than a formula operation.
mod = lm(sales ~ newspaper + I(newspaper^2), data = Advertising)
summary(mod)



## Polynomial regressions ---------------
### For instance, given a predictor X, we can create a predictor X2 using I(X^2). 
### The function I() is needed since the ^ has a special meaning I() in a formula; 
### wrapping as we do allows the standard usage in R, which is to raise X to the power 2.

ploy_mod = lm(sales ~ newspaper + I(newspaper^2), data = Advertising)
summary(ploy_mod)

ploy_mod = lm(sales ~ newspaper + I(newspaper^2) + I(newspaper^3) , data = Advertising)
summary(ploy_mod)

ggplot(data = Advertising, aes(x=newspaper, y = sales)) + geom_point() + 
  stat_smooth(method='lm', formula = y~poly(x,3))



## Qualitative predictors ------
dir = "." ## fill in directory here if you need to, "." represent current directory 
performance = read.csv(file = paste0(dir, "/Team_Performance.csv"), header = TRUE, as.is = TRUE)

str(performance)
### R generates dummy variables automatically. 

### The contrasts() function returns the coding that R uses for the dummy variables.
performance$HomeAdvantage = as.factor(performance$HomeAdvantage)

qual_mod = lm(Performance ~ HomeAdvantage, data = performance)
summary(qual_mod)

contrasts(performance$HomeAdvantage)

ggplot(performance, aes(x=Performance, fill = HomeAdvantage)) + geom_histogram() + 
  xlab("Performance") + 
  ylab("")

### R has created a HomeAdvantageGood dummy variable that takes on a value of 1 
  ### if the shelving location is good, and 0 otherwise. 
### It has also created a HomeAdvantageMedium dummy variable that equals 1 
  ### if the shelving location is medium, and 0 otherwise. 
### A bad HomeAdvantage corresponds to a zero for each of the two dummy variables. 

### The fact that the coefficient for HomeAdvantage in the regression output 
### is positive indicates that a good shelving location is associated with 
### high Performance (relative to a bad location).


### . includes all the variables 
### 
lm.fit1 = lm(Performance ~ ., data = performance) 
summary(lm.fit1)

# Q: What is the problem with including all variables?

lm.fit = lm(Performance ~ . + TeamBudget:TeamPromotion + TicketPrice:PlayerAge, data = performance) 
summary(lm.fit)

lm.fit2 = lm(Performance ~ . - TeamPromotion, data = performance) 
summary(lm.fit2)


## In class exercise: Iowa Home data (HousePrices.csv) ----------------
home_data = read.csv(file = paste0(dir, "/HousePrices.csv"), 
                     header = TRUE, as.is = TRUE)

# Q1 Graphically explore a few variables, their distributions, relationships with the SalePrice dependent variable
## which variables do you think would be good predictors? and Why?

# Q2 Any nonlinear terms you should include in a preditive model?

# Q3 Any interaction effects? 


#### Cross validation -------------------
library(caret)
# setting seed to generate areproducible random sampling
set.seed(125) 

# defining training control
# as cross-validation and 
# value of K equal to 10
train_control <- trainControl(method = "cv",
                              number = 10)

# training the model by assigning Performance column
# as target variable and rest other column
# as independent variable
model <- train(SalePrice ~ GrLivArea, data = home_data[!is.na(home_data$GrLivArea),], 
               method = "lm",
               trControl = train_control)

# printing model performance metrics
# along with other details
print(model)




