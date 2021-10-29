##%######################################################%##
#                                                          #
####               HARMONIC 2021 Workshop               ####
#                                                          #
##%######################################################%##

# Documentation
# https://malaga-fca-group.github.io/fcaR/index.html
# Installation:
# In the R console, use
# install.packages("fcaR")

#### Load libraries and code ####
library(tidyverse)
library(here)
library(Matrix)
library(fcaR)
library(readxl)

#### Data import ####
# Import data from data folder
data_folder <- normalizePath(here::here())

# 3rd course
data_files3 <- list.files(
  path = data_folder,
  pattern = "^tidy_Calificaciones_3",
  full.names = TRUE)

data3 <- data_files3 %>% 
  lapply(read_excel) %>% 
  do.call(rbind, .) %>% 
  as.matrix()

# Remove uninteresting columns
data3 <- data3[, -c(4, 8, 11, 13)]

# Formal Context
fc3 <- FormalContext$new(data3)

# Conceptual scaling
fc3$scale(
  attributes = fc3$attributes,
  type = "interval",
  values = c(0, 4.99, 11), 
  interval_names = c("suspenso", "aprobado"))

# Rename attributes
attr <- c("Ent", "-Ent",
          "Dec", "-Dec",
          "Poli", "-Poli",
          "Ec", "-Ec",
          "Fun", "-Fun",
          "Proy", "-Proy",
          "Geo", "-Geo",
          "Est", "-Est",
          "Fin", "-Fin")

fc3$attributes <- attr

# Export to LaTeX
fc3$to_latex(label = "fc:example1",
             caption = "Formal Context for example 1.")

# Derivation operators
O <- Set$new(attributes = fc3$objects,
             "42" = 1)
fc3$intent(O)

A <- Set$new(attributes = fc3$attributes,
             "Geo" = 1)
fc3$extent(A)
fc3$closure(A)

# Context reduction
fc_clarified <- fc3$clarify(TRUE)
fc3$dim()
fc_clarified$dim()
fc_reduced <- fc3$reduce(TRUE)
fc_reduced$dim()

# NextClosure
fc3$find_implications()
fc3$implications$cardinality()

#### Concepts ####
lattice <- fc3$concepts
lattice$size()
lattice$plot(object_names = FALSE)


# List of all concepts (even in LaTeX)
lattice
lattice$to_latex()

lattice$bottom()
lattice$top()

# Subset a particular concept
C <- lattice$sub(5)
C
C$to_latex()
C$get_intent()
C$get_extent()

lattice$subconcepts(C)
lattice$superconcepts(C)

lattice$lower_neighbours(C)
lattice$upper_neighbours(C)

# Irreducible elements
lattice$join_irreducibles()
lattice$meet_irreducibles()
fc3$standardize()

# Sublattice
concepts <- lattice[100:102]
sublattice <- lattice$sublattice(concepts)
sublattice
sublattice$plot(object_names = FALSE)

#### Implications ####
implications <- fc3$implications
implications
implications$to_latex()

# Computation of closure:
# Classical:
implications$closure(A)
# Using Simplification Logic:
cl <- implications$closure(A, reduce = TRUE)
cl$closure
cl$implications

# Application of simplification rules:
impl_orig <- implications$clone()
implications$apply_rules(c("simp", "rsimp"))
colMeans(impl_orig$size())
colMeans(implications$size())

# To check that implications is equivalent to impl_orig:
impl_orig %~% implications

# To check if a set of implications hold in a formal context, 
# we use:
implications %holds_in% fc3

#### Future works ####
# Not currently included in fcaR

# Other algorithms to compute the lattice and the canonical basis (CbO - InClose)

# Algorithms for mixed attributes (positive and negative)

# Manipulation of unknown values

# Graphical interface using Shiny

# Computation of D-bases

# Minimal Generators
mg <- mingen0(
  attributes = fc3$attributes,
  LHS = implications$get_LHS_matrix(),
  RHS = implications$get_RHS_matrix())

mg

# Use minimal generators to compute the left-minimal basis
left_minimal_basis <- mg$to_implications()
left_minimal_basis$cardinality()

