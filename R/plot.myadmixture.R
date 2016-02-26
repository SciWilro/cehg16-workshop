# TO DO: Explain here what this script goes.
library(lattice)

# SCRIPT PARAMETERS
# -----------------
id         <- "pc1"
fam.file   <- "mytest.fam"
admix.file <- "mytest.7.Q"
clr        <- "darkorange"

# LOAD SAMPLE DATA FROM .fam FILE
# -------------------------------
cat("Loading sample info from PLINK .fam file.\n")
panel        <- read.table(fam.file,stringsAsFactors = FALSE)
names(panel) <- c("fid","iid","pid","mid","sex","pheno")

# LOAD ADMIXTURE ESTIMATES
# ------------------------
# Load the n x k admixture proportions matrix, where n is the number
# of samples and k is the number of ancestral populations.
cat("Loading admixture estimates.\n")
admix           <- as.matrix(read.table(admix.file))
K               <- ncol(admix)
rownames(admix) <- panel$iid
colnames(admix) <- paste0("K",1:K)

# PLOT THE ADMIXTURE PROPORTIONS FOR ONE INDIVIDUAL
# -------------------------------------------------
trellis.device(height = 4,width = 4)
trellis.par.set(par.main.text = list(cex = 1,font = 1))
print(barchart(as.table(admix[id,K:1]),box.ratio = 0.5,col = clr,border = clr,
               scales = list(x = list(limits = c(-0.05,1.05))),
               xlab = "admixture proportion",ylab = "ancestral population",
               main = id))
