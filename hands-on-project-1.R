# Project 1: Weighted Dice
  # https://rstudio-education.github.io/hopr/project-1-weighted-dice.html
  # topics covered:
    # Use the R and RStudio interfaces
    # Run R commands
    # Create R objects
    # Write your own R functions and scripts
    # Load and use R packages
    # Generate random samples
    # Create quick plots
    # Get help when you need it

# to run in Rstudio, you can
# (1) click "Run" for the previous line
# (2) highlight code and run the entire highlighted block. once ran, they will be in R console workspace (see Enviroment)
# click Ctrl + Enter for previous line or highlight to do multiple (Ctrl+A for whole script)

## variables are objects in R (at least for this book)

## creating an object
die_v1 = 1:6 # "=" and "<-" both perform object assignment (equivalently)
die_v2 <- as.numeric(1:6)
die_v2[6] <- 7
die_v1==die_v2
all(die_v1==die_v2)

##  how to roll a pair of dice (once)
die <- 1:6
dice <- sample(die,size=2,replace=TRUE)
print(sum(dice))

##  how to declare a function.
  # a function is a variable that stores code and arguments
  # every R function has 3 basic parts: name, code body, arguments
my_function <- function() {}
  # my_function = the name
  # <- function(arg1,arg2,...) = instantiates a function and name arguments
  # {
  # code is placed in between brackets, 
  # potentially spanning lines.
  # returns RESULT of last line (assignment<- is NULL, print() is NULL)
  # }

# example function, roll pair of dice
roll <- function(die=1:6, weights=rep(1,length(die))/length(die)){
  # if die and/or weight is not supplied, their default is used
  # by defaults, the prob are all equal weight
  # rep() replicates a value to make vector
  
  dice <- sample(die,size=2,replace=TRUE,prob=weights)
  sum(dice) # this is returned since sum(dice) returns a value
}
roll # will show you contents of roll function
roll() # () triggers function

# how to know what will be returned? don't ASSIGN
  # think about if R would display result in R console
  
  # examples that do return
dice
1 + 1
sqrt(2)
  # examples that do NOT return
dice <- sample(die,size=2,replace=TRUE)
two <- 1+1
a <-sqrt(2)

