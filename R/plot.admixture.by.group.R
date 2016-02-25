# This R script summarizes the distribution of admixture proportions
# across a collection of samples selected by their group or region
# label.  This script is useful for looking closely at the genetic
# composition of a collection of genotypes that are believed to have
# similar ancestral origins.
#
# To run this script in R, you need to specify several script
# parameters:
#
#   groups       Select all samples that are assigned these labels.
#   fam.file     PLINK .fam file giving sample info.
#   labels.file  Text file containing group/region labels for samples.
#   admix.file   ADMIXTURE output giving estimated admixture proportions.
#
library(lattice)
library(Hmisc)

# SCRIPT PARAMETERS
# -----------------
groups      <- c("MXL","Maya","Pima")
fam.file    <- "../data/panel/1kg_hgdp.fam"
labels.file <- "../data/panel/1kg_hgdp.lab"
admix.file  <- "../data/admixture/1kg_hgdp.7.Q"

# LOAD SAMPLE DATA FROM .fam FILE
# -------------------------------
cat("Loading sample info from PLINK .fam file.\n")
panel        <- read.table(fam.file,stringsAsFactors = FALSE)
names(panel) <- c("fid","iid","pid","mid","sex","pheno")

# LOADING GROUP LABELS
# --------------------
cat("Loading group labels assigned to samples.\n")
labels <- read.table(labels.file,header = TRUE,stringsAsFactors = FALSE)
rownames(labels) <- labels$id
panel  <- cbind(panel,data.frame(label = factor(labels[panel$iid,"label"])))
n      <- nlevels(panel$label)
rm(labels)

# LOAD ADMIXTURE ESTIMATES
# ------------------------
# Load the n x k admixture proportions matrix, where n is the number
# of samples and k is the number of ancestral populations.
cat("Loading admixture estimates.\n")
admix           <- as.matrix(read.table(admix.file))
K               <- ncol(admix)
rownames(admix) <- panel$iid
colnames(admix) <- paste0("K",1:K)

# SUMMARIZE ADMIXTURE PROPORTIONS AMONG SELECTED SAMPLES
# ------------------------------------------------------
# Compile and visualize admixture proportions for the selected samples.
cat("Summarizing admixture among selected samples.\n")
trellis.device(height = 4,width = 4)
trellis.par.set(par.main.text = list(cex = 0.75,font = 1),
                par.xlab.text = list(cex = 0.75),
                par.ylab.text = list(cex = 0.75),
                axis.text = list(cex = 0.65))
rows <- which(is.element(panel$label,groups))
n    <- length(rows)
print(bwplot(y ~ x,
             data.frame(y = factor(as.vector(matrix(1:K,n,K,byrow=TRUE)),K:1),
                        x = as.vector(admix[rows,])),
             scales = list(x = list(limits = c(-0.05,1.05),
                                    at = seq(0,1,0.25))),
             #
             # Uncomment these lines to transform a box-and-whisker plot
             # into a box-percentile plot:
             #
             #   panel     = panel.bpplot,
             #   probs     = c(0.01,0.02,0.05,0.125,0.25,0.375),
             #   nloc      = "none",
             #   cex.means = 0.75,
             #
             xlab = "admixture proportion",
             ylab = "ancestral population",
             main = paste(groups,collapse = ", ")))
