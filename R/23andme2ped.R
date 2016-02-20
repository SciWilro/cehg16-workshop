# TO DO: Explain here what this script does.

# SCRIPT PARAMETERS
# -----------------
# There are two variables you need to set to run this script: (1)
# geno.file, which contains the genotypes in a file downloaded from
# 23andme.com; (2) bim.file, the list of SNPs to keep (set to NULL to
# retain all the genotype data).
geno.file <- "/DNAData2/peter/cehg16/private/peter_carbonetto_23andme.txt"
bim.file  <- "/DNAData2/peter/cehg16/data/1kg_hgdp.bim"

# READ GENOTYPE DATA
# ------------------
cat("Reading genotypes from Ancestry data file.\n")
geno        <- read.table(geno.file,header = FALSE,stringsAsFactors = FALSE)
names(geno) <- c("id","chr","pos","genotype")
cat("Loaded genotype data at",nrow(geno),"SNPs.\n")

# READ SNP DATA
# -------------
if (!is.null(bim.file)) {
  cat("Reading SNP data from PLINK .bim file.\n")
  map        <- read.table(bim.file,stringsAsFactors = FALSE)
  names(map) <- c("chr","id","dist","pos","A1","A2")
}

