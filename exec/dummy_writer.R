#!/usr/bin/env Rscript

rm(list=ls())
devtools::load_all(".") 

require(simlab)

require(LMest)
library(mvtnorm)
require(Formula)
require(MASS)
## source("item_selection_WBnew_Dummy_Sel.R") #Function to perform the inclusion-exclusion algorithm
## source("overall_BIC_inc.R")    #Function to compute BIC_diff (inside the inclusion-exclusion algorithm)
## source("overall_BIC_ex.R")    #Function to compute BIC_diff (inside the inclusion-exclusion algorithm)
## source("regress_miss.R")         #Function to fit the multivariate regression model
## source("lmestContMISS.R")        #Function to estimate the HM model with missing data
## source("functions.R")            #Internal function
## source("lmbasic.cont.MISS.R")    #Internal function
## source("complk_cont_miss.R")     #Internal function
## source("drawHMBasicCont.R")

dd_user  <- "inst/extdata/ext/sim-rs.def/group-a/session-1/out"
dd_local <- "inst/extdata/ext/sim-rs.loc/group-a/session-1/out"
dd_share <- "inst/extdata/ext/sim-rs.net/group-a/session-1/out"

out_path <- function(filename) { io_path(dd_share, filename) }


# simulated data
B <- 10
n<- 10   #number of individuals (250,500)
TT <- 5 #time occasions (5,10)
k <- 2  #number of hidden states (2,3)
J <- 5 #total number of variables 
r <- 2 #clustering variables (2,4)
pmiss <- 0.1 #missing proportion (0.1,0.25)
nmiss <- pmiss*(n*TT)
piv <- rep(1/k,k) #initial probabilities
modBasic <- 1 #time homogenous transitions
Kmax <- 5
ind <- FALSE
if(k==2){
  Pi <- matrix(c(0.8,0.2,0.2,0.8), k, k,byrow=TRUE)
  Pi <- array(Pi, c(k, k, TT))
  Pi[,,1] <- 0
  if(r==2) Mu <- matrix(c(0,0,4,0),r,k)
  else if(r==4) Mu <- matrix(c(0,0,0,0,4,0,-1,-2), r, k)
}else if(k==3){
  Pi <- matrix(c(0.80,0.10,0.10,0.10,0.80,0.10,0.10,0.10,0.80), k, k,byrow=TRUE)
  Pi <- array(Pi, c(k, k, TT))
  Pi[,,1] <- 0
  if(r==2) Mu <- matrix(c(0,0,4,0,4,2),r,k)
  else if(r==4)  Mu <- matrix(c(0,0,0,0,4,0,-1,-2,4,2,1,1), r, k)
}
Si <- matrix(0.5,r,r)
diag(Si) <- 1

basename <- sprintf("LastFB2_n%g_k%g_TT%g_r%g_J%g_pmiss%g_ind%s.RData",n,k,TT,r,J,pmiss,ind)
filename <- out_path(basename)

sim = res_all = res_empty <- vector("list",B)
ARIe = ARIa <- rep(0,B)
for(b in 101:B){
  try({
    print(paste("sample:", b))
   set.seed(b+15200)
    sim[[b]] <- drawHMBasicCont(piv, Pi, Mu, Si, n, 
                           format = "long")
    
    Yc <- sim[[b]]$Y
    
    if(ind){
      a <- seq(-2,2,length.out=J-r)
      Yind <- rmvnorm(n*TT,a,diag(J-r))
      Y.final <- cbind(Yc,Yind)
    } 
    else{
      a <- seq(-2,2,length.out=J-r)
      be <- matrix(c(-1,1),r,J-r)
      Yc2 <- as.matrix(Yc[,3:(r+2)])
      Yreg <- rep(1,n*TT)%x%t(a) +Yc2%*%be+rmvnorm(n*TT,rep(0,J-r),diag(J-r))
      Y.final <- cbind(Yc,Yreg)
    }
  
    #simulate missing values
    if(pmiss>0){
      indmiss <- sample(1:(n*TT),size=nmiss,replace=TRUE)
      indmissJ <- sample(1:J,size=nmiss,replace=TRUE)
      Y.final2 <- Y.final
      for(i in 1:nmiss) Y.final2[indmiss[i],indmissJ[i]+2] <- NA
    }else{
      Y.final2 <- Y.final
    }
    
    Y <- data.frame(Y.final2)
    IdTime <- Y[,c(1,2)]
    id <- colnames(IdTime)[1]
    tt <- colnames(IdTime)[2]
    
    items_now <- 1:J
    Y3 <- data.frame(Y[,-c(1,2)])
    #
    formula <- lmestFormula(data=Y3,response=1:(ncol(Y3)))
    
    miss <- any(is.na(Y))
    mod.comp <- lmestContMISS(index=c(id,tt),
                              k = 1:Kmax, data = Y,
                              responsesFormula = formula$responsesFormula,modBasic=modBasic)
                              
    if(miss){
      Yimp <- mod.comp$Yimp
      Ydim <- dim(Yimp)
      Yimp <- matrix(aperm(Yimp,c(2,1,3)),Ydim[1]*Ydim[2],Ydim[3])
    }else{
      Yimp <- NULL
    }
    k_now <- mod.comp$k
    out_now <- mod.comp
    bic_now <- out_now$bic
    YY<- Y[,-c(1,2)]
    # 
     #starting from the complete set
     res_all[[b]] <- item_selection_DS(IdTime,n,YY,Yimp,J,items_now,k_now,bic_now,modBasic)
     class_all <- apply(res_all[[b]]$out$V,c(1,3),which.max)
     ARIa[b] <- mclust::adjustedRandIndex(sim[[b]]$U,class_all)
     save.image(filename)
     #starting from the empty set
    # try one item at a time
    mod = list()
    for(i in 1:J){
      print("item")
      print(i)
  
      items_now <- i
      items_no <- setdiff(1:J,items_now)
      Y2<- Y[,-(items_no+2)]
      head(Y2)
      Y3 <- data.frame(Y2[,-c(1,2)])
      colnames(Y3) = colnames(Y2)[3]
      formula <- lmestFormula(data=Y3,response=1:(ncol(Y3)))
      mod[[i]] <- lmestContMISS(index=c(id,tt),
                                k = 1:Kmax, data = Y2,
                                responsesFormula = formula$responsesFormula,modBasic=modBasic,tol=10^-5)
    }
    YY <- Y[,-c(1,2)]
    J <- ncol(YY)
    
    save.image(filename)
    
    BICk <- matrix(0,J,3)
    for(i in 1:J){
      print(i)
      BICk[i,1] = mod[[i]]$k
      BICk[i,2] = mod[[i]]$bic
      Y.sel <- YY[,i]
      miss <- (any(is.na(Y.sel)))
      Y.other <- YY[,-i]
      if(miss){
        Y.sel <- Yimp[,i]
      }
      # Fit a multivariate regression model of the remaining variables on the current set
      out <- regress_miss(as.matrix(Y.other),as.matrix(Y.sel),n1=n)
      
      BICk[i,3] = out$bic
      
    }
    save.image(filename)
    
    BICtot <- rowSums(BICk[,2:3])
    # Select the starting set (indicator and number of states) based on BIC
    item1 <- which.min(BICtot)
    print(item1)
    print(colnames(YY)[item1])
    items_now <- item1
    k_now <- mod[[items_now]]$k
    out_now = mod[[items_now]]
    bic_now = out_now$bic
    
    res_empty[[b]] <- item_selection_DS(IdTime,n,YY,Yimp,J,items_now,k_now,bic_now,modBasic)
    
    save.image(filename)
    class_empty <- apply(res_empty[[b]]$out$V,c(1,3),which.max)
    ARIe[b] <- mclust::adjustedRandIndex(sim[[b]]$U,class_empty)
  }) 
  if(b/20==floor(b/20)) save.image(filename)
}

save.image(filename)


