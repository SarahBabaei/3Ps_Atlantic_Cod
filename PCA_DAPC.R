#########PCA##########
#setup: load libraries we need and prep the work space so it has everything we need
library("ape")
library("pegas")
library("ggplot2") #Plotting functions! we love ggplot
library ("adegenet") #Does most of the PCA, DAPC, and plotting functions
library("gplots")
library("devtools")
library(rgl)
library(plyr)
library(hierfstat)


###load data in, genepop file (found in GitHub repo)
pl <- "NOSOUTH_top5.gen"
read <- read.genepop(pl, ncode=3)

#get PCA
tab <- tab(read, NA.method="mean")
pca1 <- dudi.pca(tab, scannf = FALSE, scale = FALSE, nf=4) #nf=#of PC axes to retain
temp <- as.integer(pop(read))

#plot
goodcolors <- c("black","#b2182b" ,"#fddbc7", "#92c5de", "#2166ac")
s.class(pca1$li,pop(read),col=transp(goodcolors),xax=1,yax=2,axesel=FALSE, clabel = FALSE, cstar=0, cpoint = 2, grid=FALSE)
legend("right", legend = levels(pop(read)), col=goodcolors, pch = 19, cex = 0.8)
add.scatter.eig(pca1$eig[1:50],3,1,2, ratio=.2)

#variation and more PC info
pca1$eig[1]
eig.perc <- 100*pca1$eig/sum(pca1$eig)
head(eig.perc)
#########DAPC###################
#Cross-validation to determine how many PCs retained in DAPC
#read in file (genepop)
genepop <- "X.gen"
genepop_read <- read.genepop(genepop, ncode=3)

mat <- tab(genepop_read, NA.method="mean")
grp <- pop(genepop_read)
grp

xval <- xvalDapc(mat, grp, n.pca.max=300, training.set=0.9, 
                 result="groupMean", center=TRUE, scale=FALSE,
                 n.pca=NULL, n.rep=100, xval.plot=TRUE)
View(xval$`Root Mean Squared Error by Number of PCs of PCA`)



#DAPC
#with find.clusters. select #of PCs recommended by lowest root mean squared error and select number of clusters with the lowest BIC
grp <- find.clusters(genepop_read, max.n.clust=10, n.iter = 100000)
table(pop(genepop_read), grp$grp) #gives info about where things are clustering 


#with dapc
dapc1 <- dapc(genepop_read, grp$grp) #using info from find.clusters
#export dapc info
write.table(dapc1$var.contr, "DAPCLOADINGS_NEUTRAL_byBATCHno3Ps_testmissingindv_0.2_library1rem_NonNucrem.txt")

#plot dapc
colors <- c("black","#b2182b" ,"#fddbc7", "#92c5de", "#2166ac")
scatter.dapc(dapc1, grp = (genepop_read$pop), bg="white", pch=19, cstar = 0, cell=0, 
             clab=0, col = colors, scree.da=FALSE, scree.pca = TRUE, legend = TRUE, solid = 0.4)


