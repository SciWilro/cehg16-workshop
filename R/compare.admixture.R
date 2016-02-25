# TO DO: Explain here what this script does, and how to use it.
library(ggplot2)

# SCRIPT PARAMETERS
# -----------------
labels.file <- "../data/panel/1kg_hgdp.lab"
fam.file1   <- "../data/panel/1kg_hgdp.fam"
fam.file2   <- "../data/panel/1kg_hgdp_test.fam"
admix.file1 <- "../data/admixture/1kg_hgdp.7.Q"
admix.file2 <- "test1.admix"

# These are the shapes and colours used to plot the results.
clrs <- rep(c("darkorange","dodgerblue","forestgreen","red","navyblue","gold",
              "yellowgreen","black","darkviolet","magenta","cyan"),each = 4)
shapes <- rep(c(20,1,2,4),times = 11)

# LOAD SAMPLE DATA FROM .fam FILES
# --------------------------------
cat("Loading sample info from PLINK .fam files.\n")
panel1           <- read.table(fam.file1,stringsAsFactors = FALSE)
panel2           <- read.table(fam.file2,stringsAsFactors = FALSE)
names(panel1)    <- c("fid","iid","pid","mid","sex","pheno")
names(panel2)    <- c("fid","iid","pid","mid","sex","pheno")
rownames(panel1) <- panel1$iid
rownames(panel2) <- panel2$iid
  
# LOAD ADMIXTURE ESTIMATES
# ------------------------
cat("Loading admixture estimates.\n")
admix1           <- as.matrix(read.table(admix.file1))
admix2           <- as.matrix(read.table(admix.file2))
K                <- ncol(admix1)
rownames(admix1) <- panel1$iid
rownames(admix2) <- panel2$iid
colnames(admix1) <- paste0("K",1:K)
colnames(admix2) <- paste0("K",1:K)

# Retain only the admixture estimates for samples that are found in
# both sets of results.
ids    <- intersect(panel1$iid,panel2$iid)
n      <- length(ids)
panel  <- panel1[ids,]
admix1 <- admix1[ids,]
admix2 <- admix2[ids,]
cat("Retaining admixture estimates for",n,"samples.\n")
rm(panel1,panel2,ids)

# LOADING GROUP LABELS
# --------------------
cat("Loading group labels assigned to samples.\n")
labels <- read.table(labels.file,header = TRUE,stringsAsFactors = FALSE)
rownames(labels) <- labels$id
panel  <- cbind(panel,data.frame(label = factor(labels[panel$iid,"label"])))
rm(labels)

# SUMMARIZE DIFFERENCES IN ADMIXTURE PROPORTIONS
# ----------------------------------------------
# To summarize the differences in the admixture estimates, rather than
# look at all admixture proportions, I only show the admixture
# proportion for the ancestral population that shows the largest
# difference between the two estimates. Therefore, this plot gives a
# summary of the maximum admixture differences.
cat("Generating summary of differences in admixture estimates.\n")
dev.new(height = 5,width = 7.75)
i <- apply(abs(admix1 - admix2),1,function (x) which.max(x))
print(ggplot(data.frame(x     = admix1[cbind(1:n,i)],
                        y     = admix2[cbind(1:n,i)],
                        label = panel$label),
             aes(x,y,col = label,shape = label)) +
      geom_abline(intercept = 0,slope = 1,size = 0.5,color = "gray",
                  linetype = "dashed") +
      geom_point() + theme_minimal() +
      scale_color_manual(values = clrs) +
      scale_shape_manual(values = shapes) +
      theme(panel.grid.major  = element_blank(),
            panel.grid.minor  = element_blank(),
            plot.title        = element_text(size = 9),
            axis.title        = element_text(size = 9),
            axis.text         = element_text(size = 9),
            legend.text       = element_text(size = 8),
            legend.key.height = unit(9,"points")) +
      labs(title = "admixture prop. with largest difference in each sample",
           x = "admixture proportion from admix.file1",
           y = "admixture proportion from admix.file2"))
