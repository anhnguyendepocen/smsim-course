############################################
#### From the IPF-performance-testing github repo  
#### https://github.com/Robinlovelace/IPF-performance-testing
############################################

ind <- read.csv("data/simple/ind.csv") # load the individual level data
cons <- read.csv("data/simple/cons.csv") # load aggregate constraints

con1 <- cons[,1:2]
con2 <- cons[,3:4]
# inspect the data we have loaded
ind[1,]
cons[1:2,]

source("data/simple/categorise.R") # categorise the individual level variable
ind.cat # take a look at the output
colSums(ind.cat)

# create weight object and aggregated individual-level data
weights <- array(1, dim=c(nrow(ind),nrow(cons))) 
ind.agg <- matrix (rep(colSums ( ind.cat ) , nrow (cons)) , nrow (cons), byrow = T )

## total absolute error 
sum(abs(ind.agg - cons)) # the total absolute error 
sum(abs(ind.agg[1,] - cons[1,])) ## total absolute error for zone 1

############## The IPF part #############

# Re-weighting for constraint 1 via IPF 
for (j in 1:nrow(cons)){
  for(i in 1:ncol(con1)){
 weights[which(ind.cat[,i] == 1),j] <- cons[j,i] / ind.agg[j,i]}}

for (i in 1:nrow(cons)){ # convert con1 weights back into aggregates
  ind.agg[i,]   <- colSums(ind.cat * weights[,i])}

ind.agg[1, ] # check the new aggregate values for zone 1

# test results for first row (not necessary for model)
ind.agg[1,] - cons[1,]
sum(abs(ind.agg - cons)) ## the total absolute error 
sum(abs(ind.agg[1,] - cons[1,])) # total absolute error for zone 1

weights2 <- weights # save weights 2

# Re-weighting for constraint 2 via IPF 
for (j in 1:nrow(cons)){
   for(i in 1:ncol(con2) + ncol(con1)){
 weights[which(ind.cat[,i] == 1),j] <- cons[j,i] / ind.agg[j,i]}}

for (i in 1:nrow(cons)){ # convert con1 weights back into aggregates
  weights[,i] <- weights[,i] * weights2[,i]
  ind.agg[i,]   <- colSums(ind.cat * weights[,i])}
weights3 <- weights

ind.agg[1,] - cons[1,]
sum(abs(ind.agg - cons)) # the total absolute error 
sum(abs(ind.agg[1,] - cons[1,])) # total absolute error for zone 1
weights3[,1] # check the weights allocated for zone 1
