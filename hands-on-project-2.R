# Project 2: Playing Cards
  # https://rstudio-education.github.io/hopr/project-2-playing-cards.html
  # topics covered:
    # Save new types of data, like character strings and logical values
    # Save a data set as a vector, matrix, array, list, or data frame
    # Load and save your own data sets with R
    # Extract individual values from a data set
    # Change individual values within a data set
    # Write logical tests
    # Use R’s missing-value symbol, NA

# SECTION 5.1: Atomic vectors
## Atomic vector: homogeneous type vector (1d collection)
die <- c(1,2,3,4,5)
die
is.vector(die) # tests whther object is atomic vector, returns boolean

## this will create a collection of strings! R inferred type
suprising_atomic_vec <- c(1:10,'A',c(1,2,3)) 
suprising_atomic_vec
is.vector(suprising_atomic_vec)



## length returns length of an atomic vector
length(die)
five <- 5
length(5)

## six basic types of atomic vectors:

###(1) doubles (numerics): stores regular numbers, signed/unsigned, large/small, floating (decimal) or not
  # doubles are 64 bits, accurate to about 16 significant digits
double_atomic <- c(1,2,3,4,5,6) # NOTE: c(1:6) creates integer!
double_atomic

die <- double_atomic
die
typeof(die)

die <- as.numeric(1:6) # make a double atomic with values 1,2,3,4,5,6
die
typeof(die)

### (2) integers:
int_atomic <- c(1L,79L,-100L) # include an L
int_atomic_v2 <- c(1:6) # i:j makes ints from i to j
print(cat(int_atomic,typeof(int_atomic),"")) # print returns NULL
print(cat(int_atomic_v2,typeof(int_atomic_v2),""))
 
  # side note: floating point errors due to floating point arithmetic
sqrt(2)^2 - 2 
  # results in 4.440892e-16, but should be zero
  # why? because sqrt(2) cannot be expressed exactly in 64 bits (16 digits of precision)

### (3) characters: 
character_atomic <- c("ace","spade") # quotations
character_atomic
character_atomic_v2 <- c("Hello","World!")
character_atomic_v2
typeof(character_atomic_v2)

### (4) logicals
logic_atomic <- c(TRUE,FALSE,TRUE)
typeof(logic_atomic)
  # shorthands, but better to sick with TRUE/FALSE since T/F can be overwritten
typeof(T) # T is TRUE
typeof(F) # F is FALSE

### (5) complex: complex numbers with imaginary component
complex_atomic <- c(1 + 1i, 1 + 2i, 1 + 3i)
complex_atomic
typeof(complex_atomic)
typeof(1 + 0i)

### (6) raw: store raw bytes of data
  # making raw bytes of data can be complicated, raw(n) is simplest
raw(2)
raw_atomic <- c(raw(3),raw(1))
raw_atomic
typeof(raw_atomic)

  # initializing int collections vs text collections
int_vals <- c(1:5L)
text_vals <- c("",1:5)[2:6] # including the empty string makes c() infer string, then we need 1 thru 5
int_vals
text_vals

# Exercise 5.2:
hand <- c("ace","king","queen","jack","ten")
hand

# SECTION 5.2 Attributes
  # attribute: piece of information you can attach to any R object (like 
  # an atomic vector). remember, R objects are variables in R. you can
  # think of attribute as "metadata"
  # most common attributes are: names(), dimensions (dim()), and classes
attributes(die)

## 5.2.1 Names: to assign, names(object) <- collection of items w/ length = len(die)
names(die) # returns the names() attribute of die (currently NULL)
names(die) <- 1:6
names(die)
names(die) <- c("one", "two", "three", "four", "five", "six")
names(die)

attributes(die) # now contains names

die # will now display names above die whenever looking at die
die + 1 # value wont affect names (and names wont affect values)

names(die) <- c("uno", "dos", "tres", "quatro", "cinco", "seis")
die

names(die) <- NULL # deletes names attribute
die

## 5.2.2 Dim: reorganize elements of vector into n, m, ... dimensions
dim(die) <- c(2, 3) # 2 rows x 3 columns
die

dim(die) <- c(3,2) # 3 rows x 2 columns
die

dim(die) <- c(1, 2, 3) # 1 row x 2 col x 3 slices (3d hypercube)
die

# 5.3 matrices allow you to control the ordering of the elements
m <- matrix(die, nrow=2)
m
  #      [,1] [,2] [,3]
  # [1,]    1    3    5
  # [2,]    2    4    6

m <- matrix(die, nrow = 2, byrow = TRUE)
m
  #      [,1] [,2] [,3]
  # [1,]    1    2    3
  # [2,]    4    5    6

# 5.4 array: creates an n, m, ... dimensional array. same result as dims but not setting attribute
ar <- array(c(11:14, 21:24, 31:34), dim = c(2, 2, 3))
ar

# exercise 5.3
matrix(c(hand,rep("spades",length(hand))),
       nrow=length(hand),byrow=FALSE)
matrix(c(hand,rep("spades",length(hand))),
       ncol=2,byrow=FALSE)

# 5.5 class: 
  # changing dimensions doesn't change object type, but will change class!
  # the class of doubles is numeric
die <- as.numeric(1:6) 
dim(die) # NULL
typeof(die) # double
class(die) # numeric

dim(die) <- c(2,3)
typeof(die) #  double
class(die) # matrix

  # matrix is special case of atomic vector. for example die matrix is
  # special case of double vector. every element is a double, but arranged
  # in new way
  # R added class attribute to die when changed its dimensions

  # NOTE: class won't always appear for atributes(object)
attributes(die)

## 5.5.1 dates and times: 
  # attributes allow you to go beyond doubles, 
  # integers, characters, logicals, complexes and raws
now <- Sys.time()
now
typeof(now) # double
class(now) # "POSIXct" "POSIXt" 
  # POSIXct is standardized way of listing times, represents seconds
  # between current time and 12:00 AM January 1st 1970 Universal Time Coordinated (UTC)

  # fun but bad idea, force a number to be POSIXct class to see that number as a time
mil <- 1000000
mil
class(mil) <- c("POSIXct", "POSIXt")
mil # shows 1e6 seconds after 12:00 a.m. Jan. 1, 1970

## 5.5.2 Factors - ubiquitous class R uses to store categorical information
  # for example: gender, race, eye color
  # BE CAREFUL, by DEFAULT: R will try to onvert character strings to factors when loading and creating data, DON'T let it

  # factor(atomic) 
    # (1) recodes the data as integers
    # (2) stores the results in an integer atomic 
    # (3) adds a "levels" attribute to object, containing set of labels for factor values
    # (4) adds a "class" called factor
genders <- factor(c("male", "female", "female", "male"))
genders # R uses the "levels" attribute to display factors, but will do "factor" functions on the integers
typeof(genders)
attributes(genders)
unclass(genders) # see exactly how R is storing them
as.character(genders) # converts factor back to character string using "levels"

# exercise 5.4
card <- c("ace","heart",1)
typeof(card) # should return character

# 5.6 Coercion: for atomics, R will force input data into the same datatype 
  # RULE: the following arrangement preserves information, easy to tell what original value was
  # 1. if string is present in atomic, R will make everything strings
  # 2. If only logicals and numbers, R will convert every logical to numbers (TRUE=1, FALSE=0)

  # coercion rules allow us to do math with logicals
sum(c(TRUE, TRUE, FALSE, FALSE)) == sum(c(1, 1, 0, 0)) # both equal 2
  # sum() counts TRUEs in logical vec, and mean() counts proportion of TRUEs

as.character(1) # "1"
as.logical(1) # TRUE
as.numeric(FALSE) # 0

  # atomic vectors are great for homogeneous data, but \
  # what if we want to mix datatypes! list()

# 5.7 Lists
  # list(element_1,element_2,element_3)
  # (1) group together data into 1D set (which may contain other lists!)
  # (2) don't group together individual values, group together R objects
  # (3) [[x]][y] double bracket notation indicates the x'th element, 
  # single bracket indicates the y'th element of the x'th element

list_example <- list(100:112, "R", list(TRUE, FALSE))
  ## [[1]]
  ## [1] 100 101 102 103 104 105 106 107 108 109 110 111 112
  ## 
  ## [[2]]
  ## [1] "R"
  ##
  ## [[3]]
  ## [[3]][[1]]
  ## [1] TRUE
  ##
  ## [[3]][[2]]
  ## [1] FALSE

# exercise 5.5 
card <- list("ace","hearts",1)
card
  # in theory, could use a list of lists to accomplish this, BUT
  # a dataframe would be much cleaner!

# 5.8 Data Frames
  # (1) 2D version of list
  # (2) data frames store sequence of columns, 
    # (2a) each column can be different data type
    # (2b) each column must be same length (or recyclable to same length, see Fig 2.4)
    # (2c) each column is a atomic vector (homogeneous datatype within column)

  # (v1, creating a dataframe)
df <- data.frame(face = c("ace", "two", "six"),  
                 suit = c("clubs", "clubs", "clubs"), value = c(1, 2, 3))
df
  # note: you can name the columns of a dataframe, but also can for lists and vectors
  # which will be stored in the .names attribute
list(face = "ace", suit = "hearts", value = 1)
c(face = "ace", suit = "hearts", value = "one")

  # data frame is a special type of list!
typeof(df) ## list
class(df) ## data.frame
str(df) ## display the structure of an object

# 5.9 (v2, creating a dataframe) Loading Data 
  # RStudio's loading data features is convenient

  # after loading deck.csv
deck <- read.csv("C:/Users/ethan/Workspace_R/hands-on-R/data/deck.csv")
DECK <- deck # save a pristine copy
head(deck)
tail(deck)
  # see i/o in R: https://rstudio-education.github.io/hopr/dataio.html#dataio

# 5.10 Saving Data
  # write.csv() saves to working directory by default
write.csv(deck,file="./data/cards.csv",row.names=FALSE)
  # ALWAYS INCLUDE IN write.csv()
  # (1) 1st argument is name of dataframe you want to save 
  # (2) file = file path name with extension
  # (3) row.names = FALSE to prevent R adding column of numbers at start of data
?write.csv # to see the many customization options
getwd()
  # change working directory from RStudio menu bar: 
  # Session > Set Working Directory > Choose Directory

# 5.11 Summary
  # figure 5.6 really good summary of R data structures

# 6 R Notation
  # indexing on right side of <- COPIES of values stored in R
  # indexing on left side of <- accesses memory to store values
  # indexing 1D object requires 1 value
  # indexing 2D object requires 2 values
  # indexing nD object requires n values

  # indexing dataframes: dataframe_x[i,j] # NOTICE Brackets []
  # i and j could be 6 things:
  # (1) pos integer
  # (2) neg integer
  # (3) names
  # (4) logicals
  # (5) blank spaces
  # (6) zero (0)

  # NOTE: R is 1-based indexing! NOT 0-based

## 6.1.1 Positive integers: if i and j are integers, just like
  # indexing a matrix in linear algebra (i'th row, j'th col)
  
  # a single value, i and j are one integer
head(deck)
deck[1,1]
  # multiple values,i and/or j are multiple integers
deck[1,1:length(deck)] # gets first row
deck[1,1:3] # gets first row
deck[1,c(1,2,3)] # gets first row

  # REPITITION, if repeat an index number, R will return val equal to repetitions!
num_reps = 3
deck[rep(1,num_reps),1:length(deck)] # repeats num_reps times

  # NOTE: []-indexing with integers works for any R object, just have to supply one index for each dimension
vec <- c(6, 1, 3, 6, 10, 5)
vec[1:3]


### [i,j,drop=FALSE] will force a dataframe for single column indexing, which is
  # valuable since indexing for single column returns a vector
  # dataframe_x[i:j,k,drop = FALSE] # dataframe of 1 column, since k is a single integer

deck[1:2, 1:2] # returns DATAFRAME of 1st/2nd row, 1st/2nd col elements
deck[1:2, 1] # returns VECTOR of 1st/2nd row in 1st column
deck[1:2, 1,drop=FALSE] # returns DATAFRAME of 1st/2nd row in 1st column

## 6.1.2 Negative integers: exact opposite of positive integers - R returns every
  # element EXCEPT the elements in negative index
  # WHY? negatives are more efficient way to subset if we know a few we want to exclude but keep the rest
all(deck[-1, 1:3] == deck[2:52,1:3]) # both return EVERY element except first row
all(deck[-(2:52),1:3] == deck[1,1:3]) # both return ONLY first row

  # negatives can NOT be paired with positives in SAME index
  # tryCatch() explained: # https://www.geeksforgeeks.org/how-to-use-the-trycatch-function-in-r/
tryCatch({deck[c(-1, 1), 1,drop=FALSE]}, # ERROR!
         error = function(e){
           cat("Caught Error!",conditionMessage(e),"\n")
         })

tail(deck)
deck[-1:-50, 1,drop=FALSE] # no error! returns all rows except 1:50, 1st col (as vector)
  # equivalently
deck[-(1:50), 1,drop=FALSE] 
  # NOTE:
all(-1:-50 == -(1:50))

## 6.1.3 Zero: returns nothing from a dimension when indexing with zero
  # NOTE: NOT VERY HELPFUL AT ALL! unless you want an empty dataframe with 0 columns and i rows, or 0 rows and i columns?
deck[0, 0]
deck[0]
  # see 6.1.4 before this
deck[0,,drop=FALSE] # 0 rows and all columns
deck[,0,drop=FALSE] # all rows and 0 columns

## 6.1.4 Blank spaces: tells R to extract EVERY value in blank dimension
deck[1,] # give me first row with all columns

## 6.1.5 logical values: supplying boolean vector (either 
  # equal length to dataframe dimension subsetting OR following R's
  # repeating vector rules)
deck[TRUE] # repeats to TRUE, TRUE, TRUE for all columns of dataframe
all(deck[c(TRUE,FALSE)] == deck[c(TRUE,FALSE,TRUE)]) # repeats to TRUE, FALSE, TRUE for 1st and 3rd column selection (skipping "suit")
all(deck[1, c(TRUE, TRUE, FALSE)] == deck[1,1:2]) # mix integer and boolean! get 1st row and 1st/2nd but not 3rd column
all(deck[c(TRUE,FALSE),] == deck[rep(c(TRUE,FALSE)),]) # repeats to get all odd elements
first_row_bool <- c(TRUE,rep(FALSE,length(deck[,1])-1))
deck[first_row_bool,] # get first row

## DATAFRAME dimensions:
num_cols <- length(deck) 
num_rows <- length(deck[,1]) # assuming has at least 1 column, deck[,0,drop=FALSE][,1] throws error!

  # demonstrates that a dataframe with x rows, and 0 columns 
  # CANNOT 
  # be indexed in the column dimension
tryCatch({deck[,0,drop=FALSE][,1]}, # throws error!
         error = function(e){
           cat("Caught Error!",conditionMessage(e),"\n")
         })


## 6.1.6 Names: ask for elements by name (if object has names attribute)
deck[1,c("face","suit","value")]
deck[,"value"]

# 6.2 Deal a Card
  # RUN THE FOLLOWING TO RESET!
deck <- DECK
discard <- data.frame()

  # RUN THIS ONCE TO CREATE deal_primitive()
deal_primitive <- function(cards){
  num_rows <- length(cards[,1])
  first_row <- cards[1,]
  cards <- cards[2:num_rows,]
  return(list(deck = cards,card = first_row))
}

  # RUN ALL OF THE BELOW TO DEAL
result <- deal_primitive(deck)
deck <- result$deck # access the deck
card <- result$card # access the card dealt
discard <- rbind(discard,card)
deck
card
discard

# 6.3 Shuffle the Deck
  # we have the ingredients! integer indexing already gives rows
  # in the order we ask for. so, just shuffle the integer index
deck <- DECK # set the deck back to original
deck <- deck[1:52,] # gives dataframe in order 
deck <- deck[c(2,1,3:52),] # in order, gives: 2nd, 1st, then 3rd thru 52nd rows
num_rows <- length(deck[,1])
random_order <- sample(1:num_rows,size=num_rows,replace = FALSE) # sample randomly without replacement, 52 times!
random_order

# exercise 6.2
shuffle_primitive <- function(deck){
  num_rows <- length(deck[,1])
  random_card_order <- sample(1:num_rows,size=num_rows,replace=FALSE)
  return (deck[random_card_order,]) # indexing into the rows to randomize rows and leave column blank b/c we want ALL columns
}
deck <- shuffle_primitive(deck)
head(deck)

# 6.4 Dollars Signs and Double Brackets
  # dataframes and lists can use $ syntax to extract column as vector
deck$value # returns the values column
mean(deck$value)
median(deck$value)

  # on lists, valuable because subsetting lists returns lists!
some_list <- list(numbers=c(1,2),logicals=TRUE,strings=c("a","b","c"))
some_list[2] # returns a list of the second element, with name "logicals"
  # which means sum, mean, median wont work bc expect vec

tryCatch({sum(some_list[1])}, # ERROR!!
         error = function(e){
           cat("Caught Error!",conditionMessage(e),"\n")
         })
sum(some_list$numbers) # GOOD :)

  # if list doesn't have names, use two brackets
all(some_list[[1]] == some_list$numbers) 

  # GREAT PIC: see analogy in Figure 6.3
  # one bracket returns train car
some_list[1]
some_list["numbers"]
  # two bracket returns contents of train car
some_list[[1]]
some_list[["numbers"]]

# 7.0 Modifying values - how to alter values in an R object
deck <- DECK
## 7.0.1 Changing values in place
vec <- rep(0,6)
vec
typeof(vec)
class(vec)

### modifying first value
vec[1] <- 1000
vec

### replace multiple values at once
vec[c(1,3,5)] <- c(1,1,1)
vec
  # note that you have to group them, to insert them all wrt 
  # 1st dimension, below is wrong
tryCatch({vec[1, 3, 5]}, # ERROR! b/c vec is 1d object and we didnt group into referencing 1 dimension
         error = function(e){
           cat("Caught Error!",conditionMessage(e),"\n")
         })

vec[4:6] <- vec[4:6] + 1
vec

### create values that dont exist (overindex), R will expand object
vec[8] <- 0
vec
  # great way to add new variables/names to dataset!
deck$new <- 1:52
head(deck)
deck$new <- NA # NA is an empty valuable (like None in Python)
head(deck)
  # and can remove columns using NULL
deck$new <- NULL
head(deck)

  # (1) change ace values knowing prior knowledge:
  # for Unshuffled deck, aces are a multiple of 13
ace_rows = c(13,26,39,52)
deck[ace_rows,] # every 13th row
deck[ace_rows,3] # 3rd column of every 13th row
deck$value[ace_rows] # or subset the column vector deck$value itself!

  # to change aces to high card:
deck$value[ace_rows] <- rep(14,length(ace_rows))
  # OR equivalently
deck$value[ace_rows] <- 14 # using recycling rules
head(deck,13)

  # (2) change ace values after shuffling! see 7.0.2
deck <- shuffle_primitive(deck)
head(deck,10)

## 7.0.2 Logical subsetting
vec
length(vec)
vec[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE)]

### 7.0.2.1 Logical tests: >, >=, <, <=, ==, !=, %in%, TABLE 7.1
  # (1) works on singleton objects AND (except for %in%) element wise multi-dimensional objects!
  # (2) best practice to compare objects of same datatype, otherwise R will
  #     perform coercion to force them to be same type (see Figure 5.1)
1 > 2 # FALSE
1 > c(0,1,2) # TRUE FALSE FALSE
c(1,2,3) == c(3,2,1) # FALSE TRUE FALSE
  
  # %in% checks each element of LHS is somewhere in group on RHS (returning boolean vector length LHS)
  # a %in% c(a, b, c) sees if a is in the given group c(a,b,c)
1 %in% c(1, 2, 3) # TRUE
1 %in% c(3, 4, 5) # FALSE
  # 
c(1, 2) %in% c(3, 4, 5) # FALSE FALSE
c(1, 2, 3) %in% c(3, 4, 5) # FALSE FALSE TRUE
c(1, 2, 3, 4) %in% c(3, 4, 5) # FALSE FALSE TRUE TRUE

  # these are all true, exact 1 and 0 coerced to boolean TRUE/FALSE
0 == FALSE # TRUE
0.0 == FALSE # TRUE
1 == TRUE # TRUE
1.0 == TRUE # TRUE

  # these are all FALSE, since 0 and 1 are only numbers coerced to 
  # boolean TRUE/FALSE
0.1 == TRUE # FALSE
0.1 == FALSE # FALSE
1.1 == TRUE # FALSE
1.1 == FALSE # FALSE
2 == TRUE # FALSE
2 == FALSE # FALSE

  # creating an object
die_v1 = 1:6 # "=" and "<-" both perform object assignment (equivalently)
die_v2 <- as.numeric(1:6)
die_v2[6] <- 7
die_v1==die_v2
all(die_v1==die_v2) # TRUE, as expected
  # NOTE: if you dont provide arguments to as.numeric(), then convert to logical
  # you will get logical(0) as the value! which will create wierd results when
  # comparing against numerics and integers
die_v3 <- as.numeric()
all(die_v3 == die_v1) # TRUE, NOT EXPECTED.
as.logical(as.numeric()) # logical(0) is output
logical(0)==TRUE # returns logical(0)
logical(0)==FALSE # returns logical(0)
logical(0)==1 # returns logical(0)

# exercise 7.1 v1
deck <- DECK
head(deck,13)
deck <- shuffle_primitive(deck)
head(deck,13)
## solution v1
aces_location <- deck$face == "ace"
sum(aces_location)
deck[aces_location,"value"] # boolean index deck to select rows whose face contains ace, then select their value from memory
deck[aces_location,"value"] <- 14
head(deck,13)
## solution v2
deck$value[deck$face == "ace"] 
deck$value[deck$face == "ace"] <- 14
deck$value[deck$face == "ace"]

# exercise 7.2, PLAYING HEARTS
deck <- DECK
deck$value <- 0
head(deck,13)
deck[,"suit"] == "hearts"
hearts_location <- deck[,"suit"] == "hearts"
deck[hearts_location,"value"] <- 1
tail(deck,14)

# 7.0.2.2 Boolean operators: combine multiple logical tests into a single test
  # see TABLE 7.2 (note: && and || will short circuit BUT they are not vectorized - i.e. cannot handle vector arguments)
  # note: supply a Complete logical expression to RHS and LHS, not 
  # x < 9 & > 2 but rather x < 9 & x > 2

  # get queen of spades row
deck$face == "queen" & deck$suit == "spades"
queenOfSpadesV1 <- deck$face == "queen" & deck$suit == "spades"
  # OR, equivalently
deck[,"suit"] == "spades"  & deck[,"face"] == "queen"
queenOfSpadesV2 <- deck[,"suit"] == "spades"  & deck[,"face"] == "queen"
all(queenOfSpadesV1 == queenOfSpadesV2)

  # assign 13 to queen of spades's value
deck[queenOfSpadesV1,]$value <- 13
deck[queenOfSpadesV1,]

# exercise 7.3
w <- c(-1, 0, 1)
w > 0

x <- c(5, 15)
10 < x & x < 20

y <- "February"
y == "February"

z <- c("Monday", "Tuesday", "Friday")
weekdays_atomic <- c("Monday", "Tuesday","Wednesday","Thursday",
              "Friday", "Saturday", "Sunday")
all(z %in% weekdays_atomic)

# BLACKJACK
deck <- DECK
head(deck,13)
facecard_locations <- deck$face %in% c("king","queen","jack")
deck[facecard_locations,]$value <- 10
head(deck,13)
  # aces are 1 or 11 depending on final hand! missing info, cannot simply
  # assign their value in advance

## 7.0.3
NA # special R object indicating N/A. NA in any operation will result in NA (unless ignored)

NA + 1 # == NA, don't know yet
NA == 1 # == NA, don't know yet

### 7.0.3.1 na.rm, how to ignore NA if we want
example7031 = c(NA,1:50)
mean(example7031) # NA! but only one value was NA
mean(example7031,na.rm=TRUE)

### 7.0.3.2 is.na, how to check if something is NA
NA == NA # equals NA! since R doesn't know what NA stands for on LHS and RHS
vec = c(1,2,3,NA)
vec == NA # will return all NA's similarly
is.na(NA) # TRUE
is.na(vec) # FALSE FALSE FALSE TRUE

# re-visiting aces in BLACKJACK
aces_location <- deck$face == "ace"
aces_location
deck[aces_location,]$value <- NA
head(deck,13)

# SECTION 8: R Environments (how to have funcs affect variables in place)
  # recall that deal_primitive() and shuffle_primitive() create 
  # copies of deck and shuffle that need to overwrite them.
  # Environment tree: R's structure for organizing saved R objects:
    # similar to computer's hierarchical file system structure like
    # each environment has parent env (like parent folder). where metaphor breaks:
      # R env exists in RAM memory (not hard drive)
      # R envs aren't technically inside one another, but each is connected to parent
      # R env connections are one way, can look up parent of env, but not child
deck <- DECK
library(pryr)
parenvs(all=TRUE) # Given an environment or object, return an envlist of its parent environments
  # as.environment() allows us to refer to any env in our env tree
as.environment("package:stats")
globalenv() # global environment
baseenv() # base environment
emptyenv() # R's empty environment

  # parent.env() looks up parent of a given environment
parent.env(globalenv()) # look up parent of globalenv()

  # the empty environment has no parent
tryCatch({parent.env(emptyenv())},
         error = function(e){
           cat("Caught error: ",conditionMessage(e),"\n")
         })

  # view objects in environment with ls or ls.str 
  # ls returns just object names
  # ls.str displays a little about each object's structure
ls(emptyenv())
ls(globalenv())

  # can use R's $ syntax to access object in specific environment
head(globalenv()$deck,3)

  # assign() can save object to particular environment
  # 1st argument is name of object as string
  # 2nd argument is value of object
  # 3rd argument is environment to save object in
  # Note: assign() is akin to "<-"/"=", if object exists with the given name, 
  # it will overwrite it without asking
assign("new","Hello Global",envir=globalenv())
globalenv()$new

## 8.2.1 The Active Environment: current env R stores and accesses by default
  # environment() allows us to check the active environment
environment()
  # ^globalenv() is the active environment for every command run in R's CLI and
  # thus any object created in R's CLI will be saved in globalenv()

## 8.3 Scoping rules: what is object isn't in globalenv()? three steps:
  # 1. R looks in the current active environment
  # 2. When working in R's CLI, active env is global env. So, R
      # generally starts in global env
  # 3. When R does not find obejct in an env, R looks in the env's parent env, then
      # continues to parent of parent and so on, until finds object or empty env

## 8.4 Assignment: everytime R assigns a value to an object,
  # R saves the value in active env under object's name - potentially overwriting.
  # So if R runs a function, and you happen to have objects with
  # the same name as some object within the function, how does R prevent
  # accidental overwriting of the object? SOLUTION: R creates a new active env every
  # time it evaluates a function

## 8.5 Evaluation: when R runs a function, it creates a temporary new env, 
  # we call this the "runtime environment" b/c created at function runtime
show_env <- function(){
  list(ran.in = environment(), 
       parent = parent.env(environment()), 
       objects = ls.str(environment()))
}

show_env()
  # the above will show something like:

  ## $ran.in
  ## <environment: 0x000002197a141108>
  ##   
  ## $parent
  ## <environment: R_GlobalEnv>
  ##   
  ## $objects

  # which indicates that show_env() created env 0x000002197a141108, 
  # some RAM location and its parent is R_GlobalEnv, if we ran again
  # 0x000002197a141108 would prob change but the parent would be the same.
  # notice: no objects are the env since there were no objects in the function

  # a function's runtime environment's parent is the env WHERE function was created
environment(show_env) # DONT include the (), since we want the object itself
  # ^ shows show_env parent: <environment: R_GlobalEnv>
environment(parenvs)
  # ^ shows parenvs parent: <environment: namespace:pryr>
show_env_v2 <- function(){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(), 
       parent = parent.env(environment()), 
       objects = ls.str(environment()))
}

show_env_v2() # running this gives below
  ## $ran.in
  ## <environment: 0x0000021979667cf8>
  ##   
  ##   $parent
  ## <environment: R_GlobalEnv>
  ##   
  ##   $objects
  ## a :  num 1
  ## b :  num 2
  ## c :  num 3

  # which shows us that the objects created during function runtime are added to 
  # the runtime environment (a separate space, safely away from other variables of
  # the same name)

  # a second type of object in a runtime environment is function arguments
foo <- "take me to your runtime"

show_env_v3 <- function(foo){ # argument foo NOT same memory as object foo passed in (same value tho)
  foo <- paste(foo,"NOW", sep=" ") # paste() concatenates strings
  list(ran.in = environment(), 
       parent = parent.env(environment()), 
       objects = ls.str(environment()))
}

show_env_v3(foo)
print(foo) # foo was not edited!
  ## $ran.in
  ## <environment: 0x7ff712398958>


  ## 
  ## $parent
  ## <environment: R_GlobalEnv>
  ## 
  ## $objects
  ## x :  chr "TAKE me to your runtime"

# exercise 8.2, deck but operates in place to delete card dealt
  # RUN THE FOLLOWING TO RESET!
deck <- DECK
discard <- data.frame()
deal <- function(){
  
  # # BELOW IS WRONG, because the env of a function is the place where it was created, which may not necessarily be global, BUT
  # # we do know that both need to be in global to interact with, as this is the default argument
  # # NOT SURE: but i think that the func_env must be the input_env (not to be confused with "argument env" see above),
  # # since when you evaluate the function you will need the argu
  # func_env <- parent.env(environment())
  # input_env <- func_env

  assign("deck",deck[-1,],envir=globalenv()) # assigns cards minus the first row to the global env, overwriting the original deck
    # REMAINING QUESTIONS: 
      # (1) what if we didn't know the name "deck" beforehand? how could we make sure we are overwriting it??
      # (2) "cards" is still a copy of deck. can we pass by reference instead (which would solve question 1)?
  return(deck[1,]) # return the first row of cards
}
card <- deal()
deck
discard <- rbind(discard,card)
discard

# Exercise 8.3: re-write shuffle
shuffle <- function(){
  num_rows <- length(DECK[,1])
  random_card_order <- sample(1:num_rows,size=num_rows,replace=FALSE)
  shuffled_deck <- DECK[random_card_order,] # indexing into the rows to randomize rows and leave column blank b/c we want ALL columns
  assign("deck",shuffled_deck,envir=globalenv())
}
shuffle()
head(deck)

# 8.6 Closures
deck <- DECK

  # the below works! and we are editing the actual "deck" object in R_GlobalEnv
shuffle()
deal()
deal()
  # DRAWBACKS: deck and DECK exist in the global environment, which means they
  # can be edited by anything working in the default workspace! a safer approach
  # would be store deck and DECK in a safe space only accessible to our game's
  # functions. it turns out that storing deck in a runtime environment is safer after all!
setup <- function(deck) {
  DECK <- deck
  
  # now DEAL() and SHUFFLE() are each in a child runtime env of setup(),
  # the argument deck and object DECK are in the runtime of setup, so when
  # deal() and shuffle() are called after running setup, they will reference
  # deck and DECK within setup() rather than the global env. so global deck and DECK
  # can be messed with after setup() without destroying original deck and DECK stored in setup()
  # ^ this is called a "closure":
    # setup’s runtime environment “encloses” the deal and 
    # shuffle functions. Both deal and shuffle can work 
    # closely with the objects contained in the enclosing 
    # environment, but almost nothing else can. The enclosing 
    # environment is not on the search path for any other 
    # R function or environment.
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment())) # instead of envir = globalenv()
    card
  }
  
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment())) # instead of envir = globalenv()
  }
  
  return (list(deal = DEAL, shuffle = SHUFFLE)) # return the functions so we can use them in the global space
}

setup_result <- setup(deck)
deal <- setup_result$deal
shuffle <- setup_result$shuffle