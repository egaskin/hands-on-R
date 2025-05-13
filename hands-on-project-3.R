# Project 3: Slot Machine
  # https://rstudio-education.github.io/hopr/project-3-slot-machine.html
  # topics covered:
    # Use a practical strategy to design programs
    # Use if and else statements to tell R what to do when
    # Create lookup tables to find values
    # Use for, while, and repeat loops to automate repetitive operations
    # Use S3 methods, R’s version of Object-Oriented Programming
    # Measure the speed of R code
    # Write fast, vectorized R code

# Section 9 Programs

# exercise 9.0: get_slots_symbols()
get_slots_symbols <- function(){
  slot_symbols <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  # # my initial guesses on the prob when writing it myself
  # probabilities <- c(0.17,0.11,0.17,0.17,0.15,NA)
  # probabilities[length(probabilities)] <- 1 - sum(probabilities[-length(probabilities)])
  probabilities <- c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52)
  
  chosen_slots_symbols <- sample(slot_symbols,3,replace=TRUE,prob=probabilities)
  # print(chosen_slots_symbols)
  return (chosen_slots_symbols)
}

# 9.1 Strategy for all programs:
  # 1. Break tasks into simple subtasks 
  # (top down design + very clear and simple input/output definitions)
  # 2. Use concrete examples 
  # (create test data with expected outputs - try to consider normal use cases, 
  # base cases, and edge cases, NOT input validation)
  # 3. Describe solutions in English (pseudocode)
  # 4. Convert pseudocode to code (R)

# 9.2 if Statements: FIRST section on control flow!
  # NOTE: if this is a boolean vector, R will give warning and use first element
tryCatch(
  {
  #!# THIS IS WHAT AN IN IF STATEMENT LOOKS LIKE! FROM HERE TO
  if (this) # this = logical test or R expression evaluating to single TRUE or FALSE
  {
      do_that() # some code to run (could be any number of lines)
  }
  #!# HERE
  },
  error=function(e)
  {
    cat("Caught Error!",conditionMessage(e),"\n")
  }
)

  # example of an if how to ensure num is positive
num = -2
if (num < 0) {
  num <- num * -1
}
num

num = 4
if (num < 0) {
  num <- num * -1
}
num

# 9.3 else Statements: "if this is true do plan A; else do plan B"
tryCatch(
  {
    #!# THIS IS WHAT AN IN IF STATEMENT LOOKS LIKE! FROM HERE TO
    if (this) # this = logical test or R expression evaluating to single TRUE or FALSE
    {
      PlanA()
    } else 
    {
      PlanB()
    }
    #!# HERE
  },
  error=function(e)
  {
    cat("Caught Error!",conditionMessage(e),"\n")
  }
)

  # example for code rounding to nearest integer
a <- 3.14
dec <- a - trunc(a)
dec
if (dec >= 0.5) {
  a <- trunc(a) + 1
} else {
  a <- trunc(a)
}

a

  # else if statements! for more than two mutually exclusive cases
a <- 1
b <- 1

if (a > b) {
  print("A wins!")
} else if (a < b) {
  print("B wins!")
} else {
  print("Tie.")
}
#!# START: SKELETAL STRUCTURE OF OUR PROGRAM
play_slots <- function(test_slots_symbols=c(),diamonds_wild=FALSE) {
  if (length(test_slots_symbols) == 0)
  {
    slot_symbols <- get_slots_symbols()
  } else
  {
    slot_symbols <- test_slots_symbols
  }
    
  print(slot_symbols)
  score_slots(slot_symbols,diamonds_wild)
}

score_slots <- function(slot_symbols,diamonds_wild=FALSE){

# <9> see exercise 11.6
# only do this if we want to account for diamonds being wild
# count diamonds <6> # we have to save this in advance if we are overwriting slot_symbols
num_diamonds <- count_diamonds(slot_symbols)
if (diamonds_wild){
  slot_symbols <- get_max_scoring_slots_symbols_from_wilds(slot_symbols)
}

if (check_three_of_kind(slot_symbols)){ # Case 1: all the same <1>
  prize <- get_payout_three_of_kind(slot_symbols) # look up the prize <3>
  } else if (check_all_bars(slot_symbols)){ # Case 2: all bars <2> ) {
  prize <- 5 # assign $5 <4>
  } else {
    # count cherries <5>
    num_cherries <- count_cherries(slot_symbols)
    # calculate a prize <7>
    prize <- get_payout_cherries(num_cherries) 
  }

# double the prize if necessary <8>
prize <- double_for_diamonds(prize,num_diamonds)

return(prize)
}
#!# END: SKELETAL STRUCTURE OF OUR PROGRAM

  # SO OUR REMAINING TASKS 
    # For each we need to:
    # A. come up with test data (start KISS)
    # B. describe in english then code
  # <1> - Test whether the slot_symbols are three of a kind.
  # <2> - Test whether the slot_symbols are all bars.
  # <3> - Look up the prize for three of a kind based on the common symbol.
  # <4> - Assign a prize of $5.
  # <5> - Count the number of cherries.
  # <6> - Count the number of diamonds.
  # <7> - Calculate a prize based on the number of cherries.
  # <8> - Adjust the prize for diamonds.
  # <9> - wildcard diamonds???


## 9.2.1? Concrete examples 
  # REMEMBER: break tasks into subtasks and subtasks into sub-subtasks until 
  # each step is clearly defined input/output, and easily tested with test data
slot_symbolsTest1 <- rep("7",3)
slot_symbolsTest2 <- c("B","BB","BBB")
slot_symbolsTest3 <- c("C", "DD", "0")

# Exercise 9.4: testing  slot_symbols for three of a kind
check_three_of_kind <- function(slot_symbols){
  # other valid ways of checking slot_symbols
  # return (all(slot_symbols == slot_symbols[1]))
  # return (length(unique(slot_symbols)) == 1)
  return(slot_symbols[1] == slot_symbols[2] && slot_symbols[2] == slot_symbols[3])
}

check_three_of_kind(slot_symbolsTest1)
check_three_of_kind(slot_symbolsTest2)
check_three_of_kind(slot_symbolsTest3)

# Excercise 9.5: test for all bars
slot_symbolsTest4 <- c("BB","7","D")
check_all_bars <- function(slot_symbols){
  return(all(slot_symbols %in% c("B","BB","BBB")))
}
check_all_bars(slot_symbolsTest1)
check_all_bars(slot_symbolsTest2)
check_all_bars(slot_symbolsTest3)
check_all_bars(slot_symbolsTest4)

# How would we assign the prize for 3 of a kind? An ugly method that duplicates
# the work of our check_three_of_kind() function would be this:
  # THIS IS NOT IDEAL, see section 9.4 for better solution
slot_symbols_example <- slot_symbolsTest1
if (check_three_of_kind(slot_symbols_example)) {
  symbol <- slot_symbols_example[1]
  if (symbol == "DD") {
    prize <- 800
  } else if (symbol == "7") {
    prize <- 80
  } else if (symbol == "BBB") {
    prize <- 40
  } else if (symbol == "BB") {
    prize <- 5
  } else if (symbol == "B") {
    prize <- 10
  } else if (symbol == "C") {
    prize <- 10
  } else if (symbol == "0") {
    prize <- 0
  }
}


# 9.4 Lookup tables: use an object with names attribute to make it easy
  # to look up the desired info
  # WHEN if-else trees vs lookup tables:
    # generally, use if to run different code vs
    # use lookup to assign/lookup different values
payout_lookup <- c("DD"=100,"7"=80,"BBB"=40,"BB"=25,
                           "B"=10,"C"=10,"0"=0)
payout_lookup
typeof(payout_lookup)
attributes(payout_lookup)
names(payout_lookup)

payout_lookup["DD"]
payout_lookup["B"]
  # to get just the value and not the name:
unname(payout_lookup["DD"])

get_payout_three_of_kind = function(slot_symbols)
{
  payout_lookup_three_of_kind <- c("DD"=100,"7"=80,"BBB"=40,"BB"=25,
                     "B"=10,"C"=10,"0"=0)
  # since all elements are same, use any one
  # NOTE: use unname to get rid of name
  return(unname(payout_lookup_three_of_kind[slot_symbols[1]])) 
}

# Exercise 9.6: Count cherries
  # English: figure out which elements are "C" and count them. We can easily
  # say == "C" then sum the boolean vector
sum(slot_symbolsTest1 == "C")
slot_symbolsTest5 <- c("C", "DD", "C")
sum(slot_symbolsTest5 == "C")

count_cherries <- function(slot_symbols)
{
  return(sum(slot_symbols == "C"))
}

count_diamonds <- function(slot_symbols)
{
  return(sum(slot_symbols == "DD"))
}

double_for_diamonds <-function(current_prize,num_diamonds)
{
  return(current_prize * 2^num_diamonds)
}

get_payout_cherries <-function(num_cherries)
{
  # cherries = 0 is 0, 1 is 2, 2 is 5, since 1-based integer indexing, just
  # add one to the num_cherries value to get the desired value
  return(c(0,2,5)[num_cherries+1])
  
  # BELOW ADDS UNNECESSARY EXTRA STEP, just use integer indexing
  
  # # convert num_cherries to string (coerce to string with 
  # # blank string character and extract the 2nd element)
  # num_cherries_string <- c("",num_cherries)[2]
  # 
  # # lookup table for payout based on cherries
  # # note: we ignore 3 cherry case, as this is in
  # # check_three_of_kind() and
  # # get_payout_three_of_kind()
  # # "2" cherries is worth 5, "1" cherry is worth 2
  # payout_lookup <- c("2" = 5,"1" = 2,"0"=0)
  # return(payout_lookup(num_cherries_string))
}

play_slots()
# fixed: BREAK 1 and BREAK 2
play_slots(c("DD","0","B"))
# double_for_diamonds <-function(num_diamonds,current_prize)
play_slots(c("B","BB","BBB"))
print("CHECK IF FAILS ON THE play() given before 9.6")
# test 3
play_slots(c("DD","DD","DD"))
play_slots(c("BB","BB","BB"))

# SECTION 10: S3

# 10.1 The S3 System:
# R's S3 System is used for objects with classes (which is many, including dataframes!)
# S3 has three components:
  # attributes (especially "class")
  # generic functions
  # methods

# 10.2 Attributes
deck <- read.csv("C:/Users/ethan/Workspace_R/hands-on-R/data/deck.csv")
attributes(deck)
  # built-in attribute helpers in R: row.names, levels, attributes, class 
  # you can use many built-in helper functions to
  # (1) retrieve attribute value
row.names(deck)
  # (2) set attribute value
row.names(deck) <- 101:152
  # (3) give new attribute to object
row.names(deck)
levels(deck) <- c("level 1", "level 2", "level 3")
attributes(deck)

  # attr(): allows you to create new attributes and look up attributes!
  # attr(object,"attribute_name_as_string") <- assign thing to it
one_play <- play_slots() # play_slots() once and save the result!
is.atomic(one_play) # TRUE! one_play is an atomic, it is simply the double created by play_slots()
typeof(one_play)
one_play # WHY is the output of this 0? b/c it's an output of running play_slots()
  # create a new attribute and assign to it
attr(one_play, "slot_symbols") <- c("B","0","B")
attributes(one_play)
  # lookup the value of an attribute
attr(one_play,"slot_symbols")

  # when changing attributes of atomic vector, R usually displays them under the 
  # but note that vector changing the class of a object may change how it's displayed
one_play # displays the value (0) and the attributes
  
  # R generally ignores object's attributes unless R function is looking for
  # an attribute 
one_play + 1 # value = 1 after the operation, but the attribute is unaffected

# Exercise 10.1 Add an attribute to play_slots(), remove print()
# play_slots() version 2!
play_slots <- function(test_slots_symbols=c(),diamonds_wild=FALSE) {
  if (length(test_slots_symbols) == 0)
  {
    slot_symbols <- get_slots_symbols()
  } else
  {
    slot_symbols <- test_slots_symbols
  }
  prize <- score_slots(slot_symbols,diamonds_wild)
  attr(prize,"slot_symbols") <- slot_symbols
  
  return(prize)
}
play_slots()

  # two play
two_play <- play_slots()
two_play

## can use "structure" to set multiple attributes at once
  # structure(object,attribute_1_name = attribute_1_value,
  #                  attribute_2_name = attribute_2_value,
  #                  ...)

# play_slots() version 3
play_slots <- function(test_slots_symbols=c(),diamonds_wild=FALSE) {
  if (length(test_slots_symbols) == 0)
  {
    slot_symbols <- get_slots_symbols()
  } else
  {
    slot_symbols <- test_slots_symbols
  }
  # score(slot_symbols) returns a double, structure will assign the slot_symbols attribute to it
  structure(score_slots(slot_symbols,diamonds_wild), slot_symbols = slot_symbols)
}
three_play <- play_slots()
three_play

# WHAT CAN YOU DO NOW THAT YOU HAVE AN ATTRIBUTE?
  # you can write functions that specifically use those attributes, like
  # a function that will display our slot results prettily
display_slots <- function(prize){
  
  # extract slot_symbols
  slot_symbols <- attr(prize, "slot_symbols")
  
  # collapse slot_symbols into single string
  # paste() collapses a vector of strings into a single string when given the collapse argument
  slot_symbols <- paste(slot_symbols, collapse = " ")
  
  # combine symbol with prize as a character string
  # \n is special escape sequence for a new line (i.e. return or enter)
  # paste() will combine separate objects into a single string, separated by "sep"
  string <- paste(slot_symbols, prize, sep = "\n$")
  
  # DONT use print() because this 
    # (1) doesn't interpret \n and render a blank line
    # (2) includes quotations around strings
    # (3) includes [i] indicating i'th element of the output
  # print(string)
  
  # USE cat() becuase this:
    # (1) will render \n
    # (2) not display strings with quotations
    # (3) not display [i]
  # display character string in console without quotes
  cat(string,"\n")
}

display_slots(one_play)
display_slots(two_play)
display_slots(three_play)

# 10.3 Generic functions
  # displaying cleaned up output of play_slots() with display_slots() requires manually
  # calling the function display_slots() with every play_slots call. but we can 
  # use generic functions, like print(), to affect how our objects with specific
  # attributes are displayed or interacted with
  # WHY? what's the difference between calling print() every time we want to display
  # versus calling display_slots()? the text says print() is called in the background
  # every time we simply call a variable or function on the command line, (e.g. just
  # typing a variable name and clicking enter) so another function is still being called
print # not print() so we can see the function itself. notice: UseMethod("print") 

# 10.4 Methods
  # when calling print(), the function looks at the class of the object then
  # calls print.class on the object via UseMethod("print") 

num <- 1000000000
print(num)
  # changing the class changes the printing
class(num) <- c("POSIXct", "POSIXt")
print(num)

print.POSIXct
print.factor
  
  # use methods() to access methods of a generic function
methods(print)

  # note: basic functions like c, +, -, < behave like generic functions but use 
  # .primitive instead

## 10.4.1 Method Dispatch: UseMethods() matches methods to functions using S3,
  # every S3 has two-part name:
    # 1st part: refers to function the method works with
    # 2nd part: refers to class
    # ^ they are separated by a period e.g. print.function, summary.matrix
    # we can utilize S3 by writing our own function and giving it S3-style name
class(one_play) <- "slots"
one_play

  # two requirements for S3 print method:
    # (1) correct S3 name
    # (2) takes the same arguments as print (otherwise will have errors)
args(print)
print.slots <- function(x,...){
  cat("I'm using the print.slots method")
}
print(one_play) 
one_play # does same thing as print(one_play) 
rm(print.slots) # remove since this version is useless

  # if multiple classes, UseMethod() looks for the first method matching first
  # class and if nothing continue to second class and so on

# Exercise 10.2
print.slots <- function(x,...){
  display_slots(x)
}
one_play

# play_slots() version 4
play_slots <- function(test_slots_symbols=c(),diamonds_wild=FALSE) {
  if (length(test_slots_symbols) == 0)
  {
    slot_symbols <- get_slots_symbols()
  } else
  {
    slot_symbols <- test_slots_symbols
  }
  # score(slot_symbols) returns a double, structure will assign the slot_symbols attribute to it
  # and it will be of class "slots"
  structure(score_slots(slot_symbols,diamonds_wild), slot_symbols = slot_symbols, class = "slots")
}

four_play <- play_slots()
four_play

# 10.5 Classes: S3 system allows you to make new class of objects in R thru 3 steps:
  # 1. choose name of class
  # 2. Assign each instance of class a +class+ attribute with the class name
  # 3. write class methods for any generic function likely to use objects of your class
  # ^ these 3 steps are simple, but are a lot of work. consider how many methods 
  # exist for predefined classes
  # methods(class="someClass") will show available methods for someClass
methods(class="factor")
  # 31 methods for "factor" show how much work is needed to create well-behaved class

  # two additional issues for writing classes:
  # (issue 1) R drops attributes when combines objects into vector
five_play <- play_slots()
five_play # uses print.slots method
six_play <- play_slots()
six_play # uses print.slots method
# below uses print.default()! since c(five_play,six_play) is not of class "slots"
vector_form <- c(five_play,six_play) 
class(vector_form)

  # (issue 2) R drops attributes of object when subsetting
typeof(vector_form[1])
  # issues 1 and 2 can be SOLVED by writing methods c.slots and [.slots,
  # but then how would you combine slot_symbols of multiple plays into a vector of
  # slot_symbols attributes? and how about changing print.splots to handle vectors of slots?

# 10.6 S3 and Debugging: difficult to debug when S3 function calls "UseMethod" but
  # we know that
  # (1) UseMethod calls a class-specific method with the syntax
    # <function.class>, or possibly <function.default>
  # (2) methods() function can show methods assocaited with function or class

# 10.7 S4 and R5 - advance versions to create class specific behavior, see the
  # book by Hadley Wickham http://adv-r.had.co.nz/

# 10.8 Summary:
  # S3 allows simple ways to create object specific behavior in R (i.e. R's verison
    # of object oriented programming)

# 11 Loops: For, While, and Repeat loops, and their uses
  # loops are useful for repeating tasks, which can allow us to perform simulations to
  # estimate probabilities
# 11.1 Expected values: type of weighted average, think of it has the average result
  # if the probabilistic event was done an infinite number of times
  # see formula in 11.1
die <- c(1,2,3,4,5,6)
prob_fair <- rep(1/6,6)
exp_fair <- sum(die * prob_fair)
exp_fair

prob_loaded <- c(rep(1/8,5),3/8)
exp_loaded <- sum(die*prob_loaded)
exp_loaded

# 11.2 expand.grid: combinatorics function to list every combination of n vectors
  # from the docs:
expand.grid(height = seq(60, 80, 5), weight = seq(100, 300, 50),
            sex = c("Male","Female"))

  # get every combination of two dice rolls as a dataframe using expand.grid
rolls <- expand.grid(die,die)
rolls
  
  # get the value (sum) of each combination and assign into a new column of dataframe
  # see 6.4 Dollar Signs and Double Brackets
rolls$RollValue <- rolls$Var1 + rolls$Var2
head(rolls)

  # we can use R's repeated indexing to match the value of each die, with it's 
  # corresponding probability
dummy1 <- c("a","b","c")
dummy2 <- rep(c(1,2,3),12) # 1,2,3 12 times in a row as a vector
dummy2
dummy1[c(3,2,1)]
dummy1[c(1,1,1,2,2,2,3,3,3)]
dummy1[dummy2]
  # therefore we can do this
prob_loaded[rolls$Var1]
rolls$Var1Prob <- prob_loaded[rolls$Var1]
rolls$Var2Prob <- prob_loaded[rolls$Var2]
head(rolls)
rolls$RollProb <- rolls$Var1Prob * rolls$Var2Prob
head(rolls)

  # and finally, can calculate expected value
exp_rolls <- sum(rolls$RollProb*rolls$RollValue)
exp_rolls

# Exercise 11.1-11.4 
  # Exercise 11.1 List combinations
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
all_slots_results <- expand.grid(wheel,wheel,wheel,stringsAsFactors = FALSE)
all_slots_results

  # Exercise 11.2 Make lookup table
probs_lookup <- c("DD"=0.03, "7"=0.03, "BBB"=0.06, "BB"=0.1, "B"=0.25, "C"=0.01, "0"=0.52)

  # Exercise 11.3 Apply lookup table
probs_lookup[c("DD","BB")]
unname(probs_lookup[c("DD","BB")]) # use to get rid of name!
all_slots_results$Var1
probs_lookup[c(all_slots_results$Var1)]
unname(probs_lookup[c(all_slots_results$Var1)])
all_slots_results$Var1Prob <- unname(probs_lookup[c(all_slots_results$Var1)])
all_slots_results$Var2Prob <- unname(probs_lookup[c(all_slots_results$Var2)])
all_slots_results$Var3Prob <- unname(probs_lookup[c(all_slots_results$Var3)])
head(all_slots_results)

  # Exercise 11.4 calc prob of each combination
all_slots_results$ResultProb <- 
  all_slots_results$Var1Prob*
  all_slots_results$Var2Prob*
  all_slots_results$Var3Prob
head(all_slots_results)
  # check the result. should sum to 1!
sum(all_slots_results$ResultProb) == 1 # TRUE


# 11.3 for Loops: R's for loops operates on each item in a set (rather than sequence
  # of integers)
tryCatch(
  {
    #!# THIS IS WHAT A FOR LOOP LOOKS LIKE! FROM HERE TO
    for (value in that){
      this
    }
    #!# HERE
  },
  error=function(e)
  {
    cat("Caught Error!",conditionMessage(e),"\n")
  }
)

for (value in 1){
  print(value)
}
value

for (value in c("My", "second", "for", "loop")) {
  print(value)
}
value

  # all 3 below are equivalent
for (word in c("My", "second", "for", "loop")) {
  print(word)
}
for (string in c("My", "second", "for", "loop")) {
  print(string)
}
for (i in c("My", "second", "for", "loop")) {
  print(i)
}

  # for loops don't return anything, have to save results as you go
for (value in c("My", "third", "for", "loop")) {
  value
}
  ## the output is nothing! although value has changed for each item in set

  # to save the value from a for loop, do something like the following:
messageToMe <- vector(length = 4) # create empty vector
words <- c("My", "fourth", "for", "loop")

for (i in 1:4) {
  messageToMe[i] <- words[i]
}
messageToMe

  # idiomatic in R to execute on set of integers used to index both 
  # original object and the storage vector, like above. use length()
all_slots_results$prize <- NA
head(all_slots_results,3)


# Exercise 11.5 Build a loop
head(all_slots_results)
all_slots_results[1,] # recall this is row 1
num_rows <- length(all_slots_results[,1]) # get length of col 1
num_rows
for (i in 1:num_rows){
  
  # print(all_slots_results[i,1])

  row <- all_slots_results[i,]
  # print(attributes(row))
  # print(c(row$Var1,row$Var2,row$Var3))
  
  score <- score_slots(slot_symbols=c(row$Var1,row$Var2,row$Var3))
  # print(score)
  # equivalent way of getting the slot_symbols for current row
  # score <- score_slots(slot_symbols=c(all_slots_results[i,1],
  #                                all_slots_results[i,2],
  #                                all_slots_results[i,3]))
  
  
  # access the i'th value of the prize column and save score for this slot result
  all_slots_results$prize[i] <- score
  
  # # use this idiom to stop early
  # if (row[1] == "C"){
  #   stop("PAUSE HERE")
  # }
}
head(all_slots_results)

exp_prize <- sum(all_slots_results$ResultProb * all_slots_results$prize)
exp_prize

# Exercise 11.6 (Challenge) - DD's as wild
get_max_scoring_slots_symbols_from_wilds <- function(slot_symbols){
  # print(slot_symbols)
  # (1/7) HANDLE no-diamond scenarios
  # if there are no diamonds, then there are no wilds and this
  # is maximal scoring slot_symbols, return input slot_symbols
  if (any(slot_symbols == "DD") != TRUE){
    return(slot_symbols)
  }
  
  # (2/7) HANDLE 2-diamond scenarios 
  # for example: c("DD","DD","BB") should 
  # return c("BB","BB,"BB") and not c("DD","DD","DD")
  if (sum(slot_symbols %in% "DD") == 2){ # check if there are two diamonds
    non_DD = slot_symbols[(slot_symbols %in% "DD" != TRUE)] # get the non-diamond symbol
    # print(non_DD)
    # stop("PAUSE HERE")
    return(c(non_DD,non_DD,non_DD))
  }
  
  # (3/7 and 4/7) HANDLE 1-diamond or 3-diamond scenarios
  # handle rows 1-6 (three of a kind) and 8-10 (two cherries) of Table 9.1
  # threes of a kind are easiest to handle
  # check if the other two are the same and then make slot_symbols all that same symbol
  # this is equivalent to combinations from combinatorics
  if (slot_symbols[1] == slot_symbols[2]){
     return(c(slot_symbols[1],slot_symbols[1],slot_symbols[1]))
  } else if (slot_symbols[1] == slot_symbols[3]){
    return(c(slot_symbols[1],slot_symbols[1],slot_symbols[1]))
  } else if (slot_symbols[2] == slot_symbols[3]){
    return(c(slot_symbols[2],slot_symbols[2],slot_symbols[2]))
  }
  
  # (5/7) HANDLE row 7 of Table 9.1, check if at least 2 bars present
  if (sum(slot_symbols %in% c("B","BB","BBB")) == 2){
    # we can only make it here if there is one diamond present and two different 
    # bars present. simply return any combination of bars that is NOT all the same
    return(c("B","B","BB"))
  }
  
  # (6/7) HANDLE rows 12-13 of Table 9.1. 1 cherry
  # there must be at least 1 diamond present to make it here.
  # replace diamond with cherry if at least 1 other cherry present
  if ((sum(slot_symbols %in% "C")) == 1){
    # can return ANY combination with 2 cherries and some other symbol
    return(c("C","C","B"))
  }

  # (7/7) HANDLE INEFFECTIVE DIAMOND scenarios
  # this should only happen when there is "DD" but it cannot be used to increase 
  # a prize for example in c("BBB","7",DD"), the "DD" cannot be used to increase
  # the prize since "BBB" and "7" are not in any prize winning combo together
  # therefore simply return slot_symbols
  # print(slot_symbols)
  # print("slot_symbols must not be valid?")
  return(slot_symbols)
}

  # COPIED FROM Exercise 11.5 Build a loop
all_slots_results[1,] # recall this is row 1
num_rows <- length(all_slots_results[,1]) # get length of col 1
num_rows
for (i in 1:num_rows){
  
  row <- all_slots_results[i,]
    
  # SET diamonds_wild = TRUE 
  score <- score_slots(slot_symbols=c(row$Var1,row$Var2,row$Var3),diamonds_wild = TRUE)
  
  # access the i'th value of the prize column and save score for this slot result
  all_slots_results$prize_wild[i] <- score

}
head(all_slots_results)

# Exercise 11.7 - Calculate the Expected Value including Wilds
  # NOTE: my answer is the same as theirs even though I wrote my own 11.6
exp_prize_WILDS <- sum(all_slots_results$ResultProb * all_slots_results$prize_wild)
exp_prize_WILDS

# 11.4 while Loops
tryCatch(
{
  # structure of while loop in R.
  # how to stop? condition = FALSE, or hit ESC
  while (condition){
    code
  }
},
error = function(e){
 cat("Caught error: ",conditionMessage(e),"\n")
})

plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  while (cash > 0) {
    cash <- cash - 1 + play_slots()
    n <- n + 1
  }
  n
}

plays_till_broke(100)

# 11.5 repeat Loops
  # keep running until encounter "break"
plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  repeat {
    cash <- cash - 1 + play_slots()
    n <- n + 1
    if (cash <= 0) {
      break
    }
  }
  n
}

plays_till_broke(100)

# 11.6 Summary
  # for, while, and repeat loops allow you to repeat things
  # repetition is important to data science, since 
  # (1) it allows you to perform sigma and pi notation repititive formulas
    # (aka summation and the product version of summation)
    # for example: calculating probability and variance and maximum likelihood estimates
  # (2) basis for simulation (for example, repeat this test 20 times

  # NOTE: Regular R loops are slow, but vectorized R loops are lightning fast. good
  # for big data


# 12 Speed
# 12.1 Vectorized Code
  # vectorized: ode that takes a vector of values as input and manipulates each value
    # in the vector simultaneously
  # R is vectorized by default in 3 things:
    # logical tests, subsetting, and element-wise execution
  # R is NOT vectorized in loops (similar to Numpy vs lists in Python)

  # consider following example of an absolute value function 
abs_loop <- function(vec){
  for (i in 1:length(vec)) {
    if (vec[i] < 0) {
      vec[i] <- -vec[i]
    }
  }
  vec
}

abs_sets <- function(vec){
  negs <- vec < 0
  vec[negs] <- vec[negs] * -1
  vec
}

  # create a vector of 10 million values odd index have value +1 and
  # even index have value -1
# long <- rep(c(-1:1)[c(1,3)], 5000000)
long <- rep(c(-1,1), 5000000)

  # measure how long each function takes
system.time(abs_loop(long))
1.15
system.time(abs_sets(long))
0.39
1.15/0.39

  # R comes with built-ins that are vectorized and optimized for speed
# exercise 12.1 how fast is built-in abs()
?abs
system.time((abs(long)))
0.05
1.15/0.05 # 23 times faster than abs_loop!
0.39/0.05 # 7.8 times faster than abs_sets!


# 12.2 How to write vectorized code
  # 1. use vectorized functions to complete sequential steps of program (R's built-ins and/or
    # the 3 operations listed above)
  # 2. Use logical subsetting to handle parallel cases, try to manipulate every element in
    # in case at once 
  # 3. assign those values (either back into original object, a separate object, or new object)
  # NOTE: assignment operators and arithmetic operators ARE vectorized

  # example
vec <- c(1, -2, 3, -4, 5, -6, 7, -8, 9, -10)
  # step 1 of 3
vec < 0
vec[vec < 0] # extracts the memory address and values of all neg elements
  # step 2 of 3
vec[vec < 0] * -1 # multiplies all of those values by neg one (BUT DOESNT SAVE THEM)
vec
  # step 3 of 3, into original object this time
vec[vec < 0] <- vec[vec < 0] * -1
vec

# Exercise 12.2 (Vectorize a Function)
change_symbols_sequential <- function(vec){
  for (i in 1:length(vec)){
    if (vec[i] == "DD") {
      vec[i] <- "joker"
    } else if (vec[i] == "C") {
      vec[i] <- "ace"
    } else if (vec[i] == "7") {
      vec[i] <- "king"
    }else if (vec[i] == "B") {
      vec[i] <- "queen"
    } else if (vec[i] == "BB") {
      vec[i] <- "jack"
    } else if (vec[i] == "BBB") {
      vec[i] <- "ten"
    } else {
      vec[i] <- "nine"
    } 
  }
  vec
}
change_symbols_sequential(vec)

change_symbols_vectorized_v2 <- function(vec){
  change_lookup <- c("DD" = "joker", 
                     "C" = "ace",
                     "7" = "king",
                     "B" = "queen",
                     "BB" = "jack",
                     "BBB" = "ten",
                     "0" = "nine")
  unname(change_lookup[vec]) # returns the lookup version
}
change_symbols_vectorized_v2(vec)

change_symbols_vectorized_v1 <- function (vec) {
  # this identifies each one separately, as opposed to 
  # simultaneously with look up table. see v2
  vec[vec == "DD"] <- "joker"
  vec[vec == "C"] <- "ace"
  vec[vec == "7"] <- "king"
  vec[vec == "B"] <- "queen"
  vec[vec == "BB"] <- "jack"
  vec[vec == "BBB"] <- "ten"
  vec[vec == "0"] <- "nine"
  
  vec
}

many <- rep(vec, 1000000)

system.time(change_symbols_sequential(many))
18.29
system.time(change_symbols_vectorized_v1(many))
0.36
system.time(change_symbols_vectorized_v2(many))
0.76
  
  # NOTE:
  # for loops in uncompiled languages get optimized in the compile step
  # for loops in compiled langauages are not necessarily optimized
  # look for combinations of if-statements and for-loops, these typically indicate
    # a step that can be vectorized (since logical operators needed for if, and 
    # often looping through all elements with for)

# 12.3 How to write fast for loops:
  # 1. Do as much OUTSIDE the loop as possible
  # 2. preallocate memory for objects whenever possible. otherwise, appending to
    # an object requires finding new memory locations then copying over the old 
    # data each iteration of the loop that requires adding another element
  # R authors use low-level languages like C and Fortran to write R functions which
  # are precompiled and optimized before becoming part of R (making them fast)
  # .Primitive, .Internal, .Call are often calling code written in another language

# 12.4 Vectorized Code in Practice
  # We can simulate our slot machine by running our slot code many, many times.
  # this estimation method is "the law of large numbers" and is similar to many
  # statistical simulations. using a for loop:
winnings <- vector(length = 1000000) # preallocate outside loop
system.time(for (i in 1:1000000) {
  winnings[i] <- play_slots()
})
47.39 # seconds

  # play_slots() is not vectorized. the score function is if tree. thus the simulation
    # combines if and for, so we can probably vectorize it

  # one solution is to get MANY  slot combinations at once, then use logical subsetting
    # to operate on all of them simultaneously. all parametrized by "n" plays
get_many_slots_symbols <- function(n) {
  # creates n x 3 matrix of symbols representing n different slot machine runs
  
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  vec <- sample(wheel, size = 3 * n, replace = TRUE,
                prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
  matrix(vec, ncol = 3)
}

play_many_slots <- function(n) {
  symb_mat <- get_many_slots_symbols(n = n)
  data.frame(w1 = symb_mat[,1], w2 = symb_mat[,2],
             w3 = symb_mat[,3], prize = score_many_slots(symb_mat))
}

get_many_slots_symbols(5)

# Exercise 12.4/12.3 (Advanced challenge)s

test_symbols <- matrix(
  c("DD", "DD", "DD", 
    "C", "DD", "0", 
    "B", "B", "B", 
    "B", "BB", "BBB", 
    "C", "C", "0", 
    "7", "DD", "DD",
    "DD", "C", "DD",
    "DD","B","B",
    "C","C","C",
    "DD","DD","0",
    "DD", "B", "BB"), nrow = 11, byrow = TRUE)
test_symbols
# 
# score_many_slots <- function(symb_mat,diamonds_wild=FALSE){
#   
#   # identify rows with diamonds
#   n <- length(symb_mat[,1])
#   # print(n)
#   # print(symb_mat %in% "DD")
#   print(symb_mat)
#   # temp <- matrix(symb_mat %in% "DD",nrow=n,byrow=FALSE)
#   # print(temp)
#   is_diamond_mtx <- matrix(symb_mat %in% "DD",nrow=n,byrow=FALSE)
#   # print(is_diamond_mtx)
#   num_DD_vec <- rowSums(is_diamond_mtx)
#   # print(num_DD_vec)
#   
#   # a one time check that takes into account whether diamonds are wild or not
#   if (diamonds_wild){
#     symb_mat <-get_max_scoring_many_slots_symbols_from_wilds(symb_mat,num_DD_vec,is_diamond_mtx)
#   }
#    
#   stop("THIS IS WHERE WE ARE CURRENTLY")
#   # <9> see exercise 11.6
#   # only do this if we want to account for diamonds being wild
#   # count diamonds <6> # we have to save this in advance if we are overwriting slot_symbols
#   num_diamonds <- count_diamonds(symb_mat)
#   if (diamonds_wild){
#     slot_symbols <- get_max_scoring_slots_symbols_from_wilds(slot_symbols)
#   }
#   
#   if (check_three_of_kind(slot_symbols)){ # Case 1: all the same <1>
#     prize <- get_payout_three_of_kind(slot_symbols) # look up the prize <3>
#   } else if (check_all_bars(slot_symbols)){ # Case 2: all bars <2> ) {
#     prize <- 5 # assign $5 <4>
#   } else {
#     # count cherries <5>
#     num_cherries <- count_cherries(slot_symbols)
#     # calculate a prize <7>
#     prize <- get_payout_cherries(num_cherries) 
#   }
#   
#   # double the prize if necessary <8>
#   prize <- double_for_diamonds(prize,num_diamonds)
#   
#   return(prize)
# }
# 
# get_max_scoring_many_slots_symbols_from_wilds <- function(symb_mat,num_DD_vec,is_diamond_mtx){
#   symb_new <- symb_mat
#   # print(slot_symbols)
#   # (1/7) HANDLE rows with no-diamond scenarios
#   # if there are no diamonds, then there are no wilds and this
#   # is maximal scoring slot_symbols, do nothing to that row.
#   
#   # (2/7) HANDLE rows with 2-diamond scenarios 
#   # for example: c("DD","DD","BB") should return
#   # c("BB","BB,"BB") and not c("DD","DD","DD")
#   # (A) symb_mat[num_DD_vec == 2]: extracts rows with exactly two "DD"
#   # print(symb_mat[num_DD_vec == 2])
#   # (B) symb_mat[num_DD_vec == 2] != "DD": specifies which elements are NOT "DD" in selected rows
#   # print(symb_mat[num_DD_vec == 2] != "DD")
#   # (C) symb_mat[num_DD_vec == 2][(see B above)]: within those rows, select the element that is NOT "DD"
#   # print(symb_mat[num_DD_vec == 2][(symb_mat[num_DD_vec == 2] != "DD")])
#   # (D) symb_new[num_DD_vec == 2] <- (see C above): puts it all together, overwrite selected rows with found element within that row (recycling it thru respective row)
#   symb_new[num_DD_vec == 2] <- symb_mat[num_DD_vec == 2][(symb_mat[num_DD_vec == 2] != "DD")]
#   # print(symb_mat) # demonstrate (D) happened as planned
#   # stop("PAUSE HERE")
#   
#   # (3/7 and 4/7) HANDLE 1-diamond or 3-diamond scenarios (rows with 3 diamonds get left alone)
#   # handle rows 1-6 (three of a kind) and 8-10 (two cherries) of Table 9.1
#   # threes of a kind are easiest to handle
#   # check if the other two are the same and then make slot_symbols all that same symbol
#   # this is equivalent to combinations from combinatorics
# 
#   print("")
#   # (A) see if items in first column equal to items in second column
#   print(symb_mat[,1] == symb_mat[,2]) 
#   # (B) (see A above)[num_DD_vec == 1]: extract rows with exactly 1 "DD
#   print((symb_mat[,1] == symb_mat[,2])[num_DD_vec == 1])
#   # (C) symb_mat[num_DD_vec == 1][see B above]: for selected rows, get the non-"DD" elements
#   # print(symb_mat[num_DD_vec == 1][symb_mat[num_DD_vec == 1] != "DD"])
#   # (D) (see C above)[0] == (see C above)[1]: compare 
#   # print(symb_mat[num_DD_vec == 1][symb_mat[num_DD_vec == 1] != "DD"][1] == symb_mat[num_DD_vec == 1][symb_mat[num_DD_vec == 1] != "DD"][2])
#   
#   
#   stop("PAUSE HERE")
#   
#   if (slot_symbols[1] == slot_symbols[2]){
#     return(c(slot_symbols[1],slot_symbols[1],slot_symbols[1]))
#   } else if (slot_symbols[1] == slot_symbols[3]){
#     return(c(slot_symbols[1],slot_symbols[1],slot_symbols[1]))
#   } else if (slot_symbols[2] == slot_symbols[3]){
#     return(c(slot_symbols[2],slot_symbols[2],slot_symbols[2]))
#   }
# 
#   
#   # (5/7) HANDLE row 7 of Table 9.1, check if at least 2 bars present
#   if (sum(slot_symbols %in% c("B","BB","BBB")) == 2){
#     # we can only make it here if there is one diamond present and two different 
#     # bars present. simply return any combination of bars that is NOT all the same
#     return(c("B","B","BB"))
#   }
#   
#   # (6/7) HANDLE rows 12-13 of Table 9.1. 1 cherry
#   # there must be at least 1 diamond present to make it here.
#   # replace diamond with cherry if at least 1 other cherry present
#   if ((sum(slot_symbols %in% "C")) == 1){
#     # can return ANY combination with 2 cherries and some other symbol
#     return(c("C","C","B"))
#   }
#   
#   # (7/7) HANDLE INEFFECTIVE DIAMOND scenarios
#   # this should only happen when there is "DD" but it cannot be used to increase 
#   # a prize for example in c("BBB","7",DD"), the "DD" cannot be used to increase
#   # the prize since "BBB" and "7" are not in any prize winning combo together
#   # therefore simply return slot_symbols
#   # print(slot_symbols)
#   # print("slot_symbols must not be valid?")
#   return(slot_symbols)
# }

# symb_mat should be a matrix with a column for each slot machine window
score_many_slots <- function(symb_mat) {
  # NOTE: diamonds are WILD in this function.
  
  # Step 1: Assign base prize based on cherries and diamonds ---------
  ## Count the number of cherries and diamonds in each combination
  cherries <- rowSums(symb_mat == "C") # count cherries in each row
  diamonds <- rowSums(symb_mat == "DD")  # count diamonds in each row
  
  ## Wild diamonds count as cherries
  # print(cherries)
  # print(diamonds)
  # print(diamonds + cherries + 1)
  
  # diamonds and cherries together means diamonds are cherries. add the sum of each in each row to get a preliminary count of cherries
  prize <- c(0, 2, 5)[cherries + diamonds + 1] # assign 0, 2, 5 for 0, 1, and 2 cherries respectively
  
  ## ...but not if there are zero real cherries 
  ### (cherries is coerced to FALSE where cherries == 0)
  # print(!cherries)
  # print(cherries == TRUE)
  # print(prize[!cherries])
  print("prize before zero real cherries:")
  print(prize)
  prize[!cherries] <- 0 # if a diamond is present but not a cherry, then TRUE bool extracts that memory address and assigns 0 to it (since wild diamond can only be cherry if cherry present)
  print("prize after zero real cherries:")
  print(prize)
  
  # Step 2: Change prize for combinations that contain three of a kind 
  same <- symb_mat[, 1] == symb_mat[, 2] & 
    symb_mat[, 2] == symb_mat[, 3] # THREE OF A KIND BOOL VECTOR: check if elements of 1st column equal elements of 2nd column AND 2nd col equal 3rd
  payoffs <- c("DD" = 100, "7" = 80, "BBB" = 40, 
               "BB" = 25, "B" = 10, "C" = 10, "0" = 0)
  print("same:")
  print(same)
  prize[same] <- payoffs[symb_mat[same, 1]] # if three of a kind (same == TRUE), get that memory address/element
  print("prize after same:")
  print(prize)
  
  # Step 3: Change prize for combinations that contain all bars ------ # AND are not all the same bar
  bars <- symb_mat == "B" | symb_mat ==  "BB" | symb_mat == "BBB" # check if one of the three bars are present in any of the elements of symb_mat
  print("bars:")
  print(bars)
  all_bars <- bars[, 1] & bars[, 2] & bars[, 3] & !same # check if bars are all present but EXCLUDE combos that are all same
  prize[all_bars] <- 5 # if all bars and not same, assign prize of 5
  
  # Step 4: Handle wilds ---------------------------------------------
  
  ## combos with two diamonds
  two_wilds <- diamonds == 2 # find rows with EXACTLY two wilds (exclude 0, 1 and 3 wilds) 
  print("two wilds:")
  print(two_wilds)
  
  ### Identify the nonwild symbol
  one <- two_wilds & symb_mat[, 1] != symb_mat[, 2] & 
    symb_mat[, 2] == symb_mat[, 3] # for rows where two_wilds == TRUE, assign TRUE if 1st is not same as 2nd but 2nd does equal 3rd: this is a row where the 1st element is NOT diamond but the other two are diamonds
  two <- two_wilds & symb_mat[, 1] != symb_mat[, 2] & 
    symb_mat[, 1] == symb_mat[, 3] # for rows where two_wilds == TRUE, assign TRUE if 2nd is not same as 1st but 1st does equal 3rd: this is a row where the 2nd element is NOT diamond but the other two are diamonds
  three <- two_wilds & symb_mat[, 1] == symb_mat[, 2] & 
    symb_mat[, 2] != symb_mat[, 3] # for rows where two_wilds == TRUE, assign TRUE if 1st is same as 2nd but 3rd does not equal 2nd: this is a row where the 3rd element is NOT diamond but the other two are diamonds
  print("three:")
  print(three)
  ### Treat as three of a kind
  prize[one] <- payoffs[symb_mat[one, 1]] # "symb_mat[one, 1]" get's the memory address/elements where one is TRUE from the 1st column of symb_mat. then each of those elements is used in the "payoffs" lookup table, and assigned to prize where "one" is TRUE
  prize[two] <- payoffs[symb_mat[two, 2]] # same as above, except two is TRUE and 2nd column
  prize[three] <- payoffs[symb_mat[three, 3]]
  
  ## combos with one wild
  one_wild <- diamonds == 1 # combos with EXACTLY one wild (exclude 0, 2, and 3 wilds) 
  
  ### Treat as all bars (if appropriate)
  wild_bars <- one_wild & (rowSums(bars) == 2)
  print("wild_bars")
  print(wild_bars)
  prize[wild_bars] <- 5
  print("prize after wild_bars")
  print(prize)
  
  ### Treat as three of a kind (if appropriate)
  one <- one_wild & symb_mat[, 1] == symb_mat[, 2] # one_wild[i] TRUE AND ith row symb_mat[, 1] == symb_mat[, 2] means that 1st and 2nd element of the row are the NON-wild symbol for the ith row
  print("one")
  print(one)
  two <- one_wild & symb_mat[, 2] == symb_mat[, 3]
  print("two")
  print(two)
  three <- one_wild & symb_mat[, 3] == symb_mat[, 1]
  prize[one] <- payoffs[symb_mat[one, 1]] # extract the rows of payoff lookup where the 1st element is non-wild symbol and assign to corresponding row of prize.
  prize[two] <- payoffs[symb_mat[two, 2]] # extract the rows of payoff lookup where the 2nd element is non-wild symbol and assign to corresponding row of prize.
  print("prize after lookup + two:")
  print(prize)
  prize[three] <- payoffs[symb_mat[three, 3]] # extract the rows of payoff lookup where the 3rd element is non-wild symbol and assign to corresponding row of prize.
  print("diamonds")
  print(diamonds)
  # Step 5: Double prize for every diamond in combo ------------------
  unname(prize * 2^diamonds)
  
}


score_many_slots(test_symbols)

# system.time(play_many_slots(10000000))