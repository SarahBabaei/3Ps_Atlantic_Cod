########-----------------------------PCAdapt R Package for Outliers---------------------------################
#Used Bonferroni since its more conservative
#install.packages("pcadapt")
library(pcadapt)

#Read Genotype Data (can be file type pcadapt, lfmm, vcf, bed, ped, pool)
path_to_file <- "C:/Users/Court/Documents/MSc/L4_no2005_correct/L4_LD_no2005_popmap5_NonNuc_LG_rem.lfmm"
outpath <- "C:/Users/Court/Documents/MSc/L4_no2005_correct"
genepop <- read.genepop("L4_LD_no2005_popmap5_NonNuc_LG_rem.gen", ncode = 3)
library(dartR)
library(LEA)
genlight <- gi2gl(genepop, parallel = FALSE, verbose = NULL)
geno <- gl2geno(genlight, outfile="L4_LD_no2005_popmap5_NonNuc_LG_rem", outpath = outpath, verbose = NULL)
lfmm <- geno2lfmm("", output.file = "", force=TRUE)

pcadapt <- read.pcadapt(path_to_file, type = "lfmm")

#choose K=number of PCs
x <- pcadapt(input = pcadapt)
#variance tapers off at around 50

#Scree Plot
#displays decreasing order of %variance explained by each PC
plot(x, option = "screeplot", K=10)

#computing test stat based on PCA
summary (x)

#plot p-values on Manhattan
plot(x, option = "manhattan")

#plot Q-Q plot
#checks expected uniform distribution of p-values
plot(x, option = "qqplot")

#Histogram of test statistic and p-values
hist(x$pvalues, xlab = "pval", main = NULL, breaks = 50, col = "red")
plot (x, option = "stat.distribution")


#Bonferroni Correction
padj <- p.adjust(x$pvalues, method="bonferroni")
Bonferroni_outliers <- which(padj < alpha)
length(Bonferroni_outliers) 
list(Bonferroni_outliers)

list(Bonferroni_outliers)
write.csv(Bonferroni_outliers, "L4_LD_no2005_popmap5_NonNuc_LG_rem_PCAdaptBonferroni.txt")


#Association between PCs and outliers
snp_pc <- get.pc(x, Bonferroni_outliers)
snp_pc
