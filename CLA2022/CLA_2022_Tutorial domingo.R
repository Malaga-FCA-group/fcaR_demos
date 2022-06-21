## ----setup, include=FALSE---------------
## Global options
knitr::opts_chunk$set(cache = TRUE, 
                      echo = TRUE,
                      message = FALSE)
library(fcaR)


## ----echo = FALSE-----------------------
degrees <- c("absent", "minimal", "mild", "moderate", "moderate severe", "severe", "extreme")

COBRE_text <- cobre32
COBRE_text[] <- degrees[COBRE_text * 6 + 1]


## ----echo = FALSE-----------------------
COBRE_text[1:6, 1:8] %>% 
  knitr::kable(format = "html", booktabs = TRUE)


## ----eval = FALSE-----------------------
## ?cobre32


## ---------------------------------------
fc <- FormalContext$new(cobre32)


## ---------------------------------------
fc$find_implications()


## ---------------------------------------
fc$implications$cardinality()


## ---------------------------------------
fc$implications[5:9]


## ---------------------------------------
imps <- fc$implications


## ---------------------------------------
S1 <- Set$new(attributes = fc$attributes,
              COSAS_1 = 1/2, COSAS_2 = 1, COSAS_3 = 1/2,
              COSAS_4 = 1/6, COSAS_5 = 1/2, COSAS_6 = 1)
S1


## ---------------------------------------
imps$closure(S1)


## ---------------------------------------
O1 <- fc$extent(S1)
O1
fc$intent(O1)


## ---------------------------------------
fc$closure(S1)


## ----remedy001--------------------------
S2 <- Set$new(attributes = fc$attributes,
              COSAS_4 = 2/3, FICAL_3 = 1/2, 
              FICAL_5 = 1/2, FICAL_8 = 1/2)
S2


## ----remedy002--------------------------
fc$closure(S2)
imps$closure(S2)


## ----remedy003--------------------------
S3 <- Set$new(attributes = fc$attributes,
              COSAS_2 = 1, COSAS_6 = 1, 
              FICAL_1 = 1/3, FICAL_3 = 1/3)
S3


## ----remedy004--------------------------
fc$closure(S3)
imps$closure(S3)


## ----remedy005--------------------------
result <- imps$closure(S3, reduce = TRUE)


## ----remedy006--------------------------
result$closure


## ----remedy007, eval = FALSE------------
## result$implications


## ----remedy008--------------------------
result$implications$apply_rules(c('simp', 'rsimp', 'reorder'))


## ----eval = FALSE-----------------------
## result$implications


## ----remedy009--------------------------
result$implications$filter(rhs = c('dx_ss', 'dx_other'),
                           not_lhs = c('dx_ss', 'dx_other'), 
                           drop = TRUE)

