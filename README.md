# Hands-On Programming with R
This is my notes for the free course ["Hands-On Programming with R"](https://rstudio-education.github.io/hopr/) by Dr. Garrett Grolemund, designed to teach R as a programming language (forming basis for programming for data science). Designed to be used before or alongside [R for Data Science (r4ds)](https://r4ds.hadley.nz/)

# Setting up R on my Windows machine
I followed the book's [appendix 1 installing R and RStudio](https://rstudio-education.github.io/hopr/starting.html). 

To use the latest R installation, I uninstalled all my previous versions (should have used their uninstall scripts, but I just recycled them)

After getting a warning message, I installed [Rtools](https://cran.rstudio.com/bin/windows/Rtools/rtools44/rtools.html) as well. 

# Notes conventions
- my notes are mostly contained in the files "hands-on-project-x.R" where $1 \leq x \leq 3$
- My note taking style varied a little between projects
- I tried to mark the beginning of each section with one, un-indented hashtag and then subsections with one or more additional hashtags. Then, for each section I indented the comments under it to indicate they belong to the most recent section beginning at an unindented hashtag line.
- "WHY?" indicates a question that I have about the material. it may or may not be answered, read the comment
  
# essential R things:
- to run R code: highlight desired code, press ```CTRL``` + ```ENTER```
  - note: for scoped blocks of code (enclosed by set of parentheses), you dont have to highlight the whole scope, you can just put the cursor inside the scope and then ```CTRL``` + ```ENTER```
- don't confuse ```R c(0, 2, 5)[4, 5, 1]``` with ```R c(0,2,5)[c(4,3,1)]``` 
  - ```R c(0, 2, 5)[4, 5, 1]``` will break since it's saying "look at the 4th item in the 1st dimension, 5th item in the 2nd dimension, and 1st item in the 3rd dimension" but c(0,2,5) is a 1D vector of integers. 
  - ```R c(0,2,5)[c(4,5,3,1,2,1)]``` packages all the indices and tries to retrieve them from the 1st dimension:  "4th item in the 1st dimension, 5th item in the 1st dimension, 3rd item in the 1st dimension, etc."
    - note: 4th item in the 1st dimension, 5th item in the 1st dimension, and anything over 3rd item will fail to index and be assigned NA
    - note: since 1 is mentioned twice it will be repeated
- given some numerical vector ```R cherries = c(1,2,0,3,0,0,1)```:
  - ```!cherries``` and ```cherries == FALSE``` return the same thing, which is a vector that has 1's wherever there are 0's and 0's wherever there are nonzero values
  - ```cherries == TRUE``` does the opposite of the above

# miscellaenous R things that are useful
  ```R
  # = and <- are both assignment operators
  a = 1
  b <- 1
  a == b # TRUE
  
  rm(list=ls()) # allows you to clear the current R environment of variables and functions
  
  # block comments in R don't exist but you can comment/uncoment out multiple lines by:
  # (1) highlight section then control + shift + C (to comment)
  # (2) In RStudio menubar: Code > Comment/Uncomment Lines

  install.packages("tidyverse") # seems to have enabled markdown previewing in Rstudio!
  ```

# beautiful concepts misc.

- I incorporated section 9.1's strategy for solving coding problems into my document [General process for solving any coding problem](https://docs.google.com/document/d/1GgkUJNM2ogupQm6GABGjOBHEkWG6HUdDG8evpBpYDBM/edit?tab=t.0#heading=h.886z67xowl1o)

- data science requires solving 3 problems:
  1. Logistical problem: how can you store and manipulate data without making errors? 
  2. Tactical problem: how can you discover information contained in your data?
  3. Strategic problem: how can you use data to draw conclusions about the world at large, and quantify strength of belief in those conclusions?

- visualization of 3 fields solving these problems (note: this photo is made by Dr. Grolemund): ![data-science-visualized](https://rstudio-education.github.io/hopr/images/hopr_1004.png)

# ARCHIVE, SINCE IT DIDN'T WORK
- Also, to use RMarkdown, since RStudio's installation didn't work, so used binaries instead:
    ```R
    install.packages("rmarkdown", type = "binary")
    install.packages("renv", type = "binary")
    ```