####setup################
getwd() #see where working directory is set
setwd("C:/Users/Court/Documents/MSc/L4_no2005_correct")

#load library
library(hierfstat)
library(adegenet)
library(qvalue)
library(StAMPP)

#######################################
#genind to genlight
library(dartR)
library(StAMPP)

dat <- "NOSOUTH_top5.gen"
data <- read.genepop(dat, ncode=3)
genlight <- gi2gl(data)

#using stamppFst
convert <- stamppConvert(genlight, type = "genlight")
stampFST <- stamppFst(convert, nboots=10000, percent = 95, nclusters = 2)
View(stampFST)
stampFST

stampFST$Bootstraps
stampFST$Fsts

##############################################################
if (!require("pak")) install.packages("pak")
pak::pkg_install("thierrygosselin/assigner")

library(assigner)

dat <- "NEUTRAL_BYFISHERY_WITHSOUTH_testmissingindv_0.2_library1rem_laneeffect_OUTLIERS_NonNuc_removed.gen"
data <- read.genepop(dat, ncode=3)



