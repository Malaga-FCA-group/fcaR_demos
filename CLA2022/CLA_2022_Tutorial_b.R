## ----setup, include=FALSE------------------------------------
## Global options
knitr::opts_chunk$set(cache = TRUE)


## ----  load--------------------------------------------------
library(fcaR)
data("planets")


## ----  Visualizing-------------------------------------------
knitr::kable(planets, format = "html", booktabs = TRUE)


## ----  Creating----------------------------------------------
fc_planets <- FormalContext$new(planets)
fc_planets


## ---- tolatex------------------------------------------------
fc_planets$to_latex(caption = "Planets dataset.", label = "tab:planets")


## ---- printplot----------------------------------------------
fc_planets$print()
fc_planets$plot()


## ---- savingloading------------------------------------------
fc_planets$save(filename = "./fc_planets.rds")
fcnew <- FormalContext$new("./fc_planets.rds")
fcnew


## ---- intent-------------------------------------------------
set_objetcs <- Set$new(fc_planets$objects)
set_objetcs$assign(Mars = 1, Earth = 1)
fc_planets$intent(set_objetcs)



## ---- extent-------------------------------------------------

set_attributes <- Set$new(fc_planets$attributes)
set_attributes$assign(medium = 1, far = 1)
fc_planets$extent(set_attributes)



## ---- closure1-----------------------------------------------
# Compute the closure of S
set_attributes1 <- Set$new(fc_planets$attributes)
set_attributes1$assign(medium = 1)
MyClosure <- fc_planets$closure(set_attributes1)
MyClosure



## ---- conceptstolatex----------------------------------------
fc_planets$concepts$to_latex()


## ---- findconcepts-------------------------------------------

fc_planets$find_concepts()
fc_planets$concepts

head(fc_planets$concepts)

firstconcept <- fc_planets$concepts[1]
firstconcept

fc_planets$concepts[3:4]

fc_planets$concepts$plot()


## ---- isclosed-----------------------------------------------
set_attributes2 <-  Set$new(attributes = fc_planets$attributes)
set_attributes2$assign(moon = 1, large = 1, far= 1)
print("Given the set of attributes:")
set_attributes2

print("Is it closed?")
fc_planets$is_closed(set_attributes2)

set_attributes3 <-  Set$new(attributes = fc_planets$attributes)
set_attributes3$assign(small = 1, far = 1)
print("Given the set of attributes:")
set_attributes3

print("Is it closed?")
fc_planets$is_closed(set_attributes3)



## ---- isconcept----------------------------------------------
set_objetcs1 <- Set$new(fc_planets$objects)
set_objetcs1$assign(attributes = c('Mercury', 'Venus','Earth', 'Mars'), values=1)
set_attributes1 <- Set$new(fc_planets$attributes)
set_attributes1$assign(attributes = c('small', 'near'), values=1)
Concepto1 <- Concept$new(extent = set_objetcs1,intent = set_attributes1)

fc_planets$is_concept(Concepto1)



## ---- extentintent-------------------------------------------
set_objetcs1 <- Set$new(fc_planets$objects)
set_objetcs1$assign(attributes = c('Jupiter', 'Saturno'), values=1)
myintent <- fc_planets$intent(set_objetcs1)
myintent
("And the extent of this one is:")
myextent <- fc_planets$extent(myintent)
myextent



## ------------------------------------------------------------
fc_planets$find_implications()


## ------------------------------------------------------------
fc_planets$implications


## ------------------------------------------------------------
fc_planets$implications[3]
fc_planets$implications[1:4]
fc_planets$implications[c(1:4,3)]



## ------------------------------------------------------------
fc_planets$implications$cardinality()
sizes <- fc_planets$implications$size()
sizes
colMeans(sizes)


## ------------------------------------------------------------
fc_planets$implications$to_latex()


## ------------------------------------------------------------
sizes <- fc_planets$implications$size()
colMeans(sizes)
fc_planets$implications$apply_rules(rules = c("composition",
                                      "generalization",
                                      "simplification"),

                            parallelize = FALSE)

sizes <- fc_planets$implications$size()
colMeans(sizes)

fc_planets$implications

equivalencesRegistry$get_entry_names()
equivalencesRegistry$get_entry("simplification")



## ------------------------------------------------------------
imp1 <- fc_planets$implications[1]
imp1 %holds_in% fc_planets


## ---- echo=FALSE---------------------------------------------
S <- Set$new(attributes = fc_planets$objects)
S$assign(Earth = 1)

S2 <- Set$new(attributes = fc_planets$objects)
S2$assign(attributes = c("Earth","Mars", "Mercury"),values = c(1,1,1))
S2
cat("Given the set of objects:")
S
cat("The intent is:")
# Compute the intent of S
fc_planets$intent(S)
cat("Given the set of objects:")
S2
fc_planets$intent(S2)




## ---- echo=FALSE---------------------------------------------
M <- Set$new(attributes = fc_planets$attributes)
M$assign(large = 1)
M2 <- Set$new(attributes = fc_planets$attributes)
M2$assign(attributes = c("far","large"),values = c(1,1))
cat("Given the set of objects:")
M
cat("The extent is:")
# Compute the intent of S
e1 <- fc_planets$extent(M)
e1
cat("Given the set of objects:")
M2
e2 <- fc_planets$extent(M2)
e2


## ---- echo=FALSE---------------------------------------------
fc_planets$intent(e1)
fc_planets$intent(e2)



## ---- echo=FALSE---------------------------------------------
S <- Set$new(attributes = fc_planets$attributes)
S$assign(no_moon = 1)
Sc <- fc_planets$closure(S)
Sc

fc_planets$att_concept("moon")


## ---- echo=FALSE---------------------------------------------
fc_planets$find_concepts()
last <- fc_planets$concepts$size()
fc_planets$concepts[c(1,last)]
fc_planets$concepts$plot()


## ---- echo=FALSE---------------------------------------------
fc_planets$att_concept("moon")
fc_planets$att_concept("no_moon")



## ---- echo=FALSE---------------------------------------------
fc_planets$obj_concept("Pluto")
fc_planets$obj_concept("Earth")



## ---- sublattices--------------------------------------------
# Compute index of interesting concepts - using support
idx <- which(fc_planets$concepts$support() > 0.5)
# Build the sublattice
sublattice <- fc_planets$concepts$sublattice(idx)
sublattice
sublattice$plot()

# Compute index of interesting concepts - using indexes
idx <- c(8,9,10) # concepts 8, 9 , 10
# Build the sublattice
sublattice <- fc_planets$concepts$sublattice(idx)
sublattice
sublattice$plot()


## ------------------------------------------------------------
fc_planets$concepts$support()


## ------------------------------------------------------------
C <- fc_planets$concepts[5]
C
# Its subconcepts:
fc_planets$concepts$subconcepts(C)
# And its superconcepts:
fc_planets$concepts$superconcepts(C)


## ------------------------------------------------------------
# A list of concepts
C <- fc_planets$concepts[5:7]
C

# Supremum of the concepts in C
fc_planets$concepts$supremum(C)
# Infimum of the concepts in C
fc_planets$concepts$infimum(C)


## ------------------------------------------------------------
fc_planets$concepts$join_irreducibles()
fc_planets$concepts$meet_irreducibles()


## ------------------------------------------------------------
fc_planetscopy <- fc_planets$clone()
fc_planetscopy$clarify(TRUE)
fc_planetscopy$reduce(TRUE)


## ------------------------------------------------------------
fc_planetscopy <- fc_planets$clone()
fc_planetscopy$standardize()



## ------------------------------------------------------------
imps <- fc_planets$find_implications()
imps2 <- imps$clone()
imps2$apply_rules(c("simp", "rsimp"))
imps %entails% imps2
imps2 %entails% imps


## ------------------------------------------------------------
imps %~% imps2
imps %~% imps2[1:3]


## ---- echo=FALSE---------------------------------------------
fc_planets$concepts$meet_irreducibles()
 


## ---- echo=FALSE---------------------------------------------
c1 <-  fc_planets$concepts$meet_irreducibles()
fc_planets$concepts$sublattice(c1)


## ---- echo=FALSE---------------------------------------------
c1 <-  fc_planets$concepts$meet_irreducibles()[2:7]
sub1 <- fc_planets$concepts$sublattice(c1)
sub1
plot(sub1)

