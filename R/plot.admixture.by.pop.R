# TO DO: Explain here what this script does, and how to use it.
library(ggplot2)

# SCRIPT PARAMETERS
# -----------------
k           <- 1
fam.file    <- "../data/panel/1kg_hgdp.fam"
labels.file <- "../data/panel/1kg_hgdp.lab"
admix.file  <- "../data/admixture/1kg_hgdp.11.Q"
which.label <- "label1"
int         <- c(0.05,0.95)

# LOAD SAMPLE DATA FROM .fam FILE
# -------------------------------
cat("Loading sample info from PLINK .fam file.\n")
panel        <- read.table(fam.file,stringsAsFactors = FALSE)
names(panel) <- c("fid","iid","pid","mid","sex","pheno")

# LOADING GROUP LABELS
# --------------------
cat("Loading group labels assigned to samples.\n")
labels           <- read.table(labels.file,as.is = "id",header = TRUE)
rownames(labels) <- labels$id
panel <- cbind(panel,data.frame(label = labels[panel$iid,"label"]))
rm(labels)

# LOAD ADMIXTURE ESTIMATES
# ------------------------
cat("Loading admixture estimates.\n")
admix           <- as.matrix(read.table(admix.file))
rownames(admix) <- panel$iid
colnames(admix) <- paste0("K",1:ncol(admix))

# COMPILE ADMIXTURE SUMMARY STATISTICS
# ------------------------------------
admix.stats <-
  data.frame(n = as.vector(table(panel$label)),
             x = tapply(admix[,k],panel$label,mean),
             a = tapply(admix[,k],panel$label,function(x) quantile(x,int[1])),
             b = tapply(admix[,k],panel$label,function(x) quantile(x,int[2])))

# SUMMARIZE CONTRIBUTIONS FROM SELECTED ANCESTRAL POPULATION
# ----------------------------------------------------------
dev.new(height = 9,width = 5)
admix.stats <- admix.stats[order(admix.stats$x),]
n           <- nlevels(panel$label)
print(ggplot(cbind(admix.stats,y = 1:n),aes(x = x,y = y)) +
      geom_point(col = "dodgerblue",cex = 1.4) +
      geom_errorbarh(aes(xmin = a,xmax = b),col = "dodgerblue",height = 0) +
      theme_minimal() +
      scale_x_continuous(limits = c(-0.05,1.05),breaks = c(0,0.5,1)) +
      scale_y_continuous(breaks = 1:n,
                         labels = rownames(admix.stats)) +
      theme(panel.grid.major  = element_blank(),
            panel.grid.minor  = element_blank(),
            axis.text.x       = element_text(size = 9),
            axis.text.y       = element_text(size = 8),
            axis.title        = element_text(size = 10),
            plot.title        = element_text(size = 10)) +
      labs(title = paste("ancestral population k =",k),
           x = "admixture proportion",y = ""))


