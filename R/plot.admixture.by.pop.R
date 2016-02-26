# This R script summarizes the distribution of admixture proportions
# across a data set for a single ancestral population. Here we assume
# that we have a collection of labeled samples, and we compile summary
# statistics for each set of samples with the same label.
#
# Before running this script in R, you need to specify several script
# parameters:
#
#   k            Index of ancestral population.
#   fam.file     PLINK .fam file giving sample info.
#   labels.file  Text file containing group/region labels for samples.
#   admix.file   ADMIXTURE output giving estimated admixture proportions.
#   int          Quantiles of admixture statistics to plot as error bars.
#
library(grid)
library(ggplot2)

# SCRIPT PARAMETERS
# -----------------
k           <- 1
fam.file    <- "../data/panel/1kg_hgdp.fam"
labels.file <- "../data/panel/1kg_hgdp.lab"
admix.file  <- "../data/admixture/1kg_hgdp.7.Q"
int         <- c(0.05,0.95)

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
rownames(admix) <- panel$iid
colnames(admix) <- paste0("K",1:ncol(admix))

# COMPILE ADMIXTURE SUMMARY STATISTICS
# ------------------------------------
# For each group label, compile statistics for the selected ancestral
# population: (1) the number of samples assigned that label; (2) the
# mean admixture proportion, (3) the lower bound on the interval, (4)
# the upper bound on the interval.
cat("Compiling group-level admixture summary statistics.\n")
admix.stats <-
  data.frame(n = as.vector(table(panel$label)),
             x = tapply(admix[,k],panel$label,mean),
             a = tapply(admix[,k],panel$label,function(x) quantile(x,int[1])),
             b = tapply(admix[,k],panel$label,function(x) quantile(x,int[2])))

# Order the groups by mean admixture proportion.
admix.stats <- admix.stats[order(admix.stats$x),]

# SUMMARIZE CONTRIBUTIONS FROM SELECTED ANCESTRAL POPULATION
# ----------------------------------------------------------
# Visualize these summary statistics using the error bar plot in
# ggplot2.
dev.new(height = 7,width = 4.5)
print(ggplot(cbind(admix.stats,y = 1:n),aes(x = x,y = y)) +
      geom_point(col = "dodgerblue",cex = 1.4) +
      geom_errorbarh(aes(xmin = a,xmax = b),col = "dodgerblue",height = 0) +
      theme_minimal() +
      scale_x_continuous(limits = c(-0.025,1.025),breaks = c(0,0.5,1)) +
      scale_y_continuous(breaks = 1:n,
                         labels = paste(rownames(admix.stats),"-",
                                        admix.stats$n)) +
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.text.x      = element_text(size = 9),
            axis.text.y      = element_text(size = 7),
            axis.title       = element_text(size = 9),
            plot.title       = element_text(size = 9)) +
      labs(title = paste("ancestral population k =",k),
           x = "admixture proportion",y = ""))
