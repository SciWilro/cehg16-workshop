# TO DO: Explain here what this script does.

# SCRIPT PARAMETERS
# -----------------
# There are two variables you need to set to run this script: (1)
# geno.file, which contains the genotypes in a file downloaded from
# Ancestry.com; (2) bim.file, the list of SNPs to keep (set to NULL to
# retain all the genotype data).
geno.file <- "/DNAData2/peter/cehg16/private/peter_carbonetto_ancestry1.txt"
bim.file  <- "/DNAData2/peter/cehg16/public/1kg_hgdp.bim"
out.file  <- "peter_pcarbonetto1"
fid       <- 0
iid       <- "pc1"

# READ GENOTYPE DATA
# ------------------
cat("Reading genotypes from Ancestry data file.\n")
geno        <- read.table(geno.file,header = TRUE,stringsAsFactors = FALSE)
names(geno) <- c("id","chr","pos","A1","A2")
geno        <- cbind(geno,data.frame(dist = 0))
geno        <- geno[c("chr","id","dist","pos","A1","A2")]
cat("Loaded genotype data at",nrow(geno),"SNPs.\n")

# WRITE SNP DATA TO .map FILE
# ---------------------------
cat("Writing SNP data to .map file.\n")
write.table(geno[c("chr","id","dist","pos")],paste0(out.file,".map"),
            sep = " ",row.names = FALSE,col.names = FALSE,quote = FALSE)

# WRITE GENOTYPE DATA TO .ped FILE
# --------------------------------
cat("Writing genotypes to .ped file.\n")
write.table(cbind(data.frame(fid = fid,iid = iid,pid = 0,mid = 0,sex = 0,
                             pheno = -9),geno[c("A1","A2")]),
            paste0(out.file,".ped"),sep = " ",row.names = FALSE,
            col.names = FALSE,quote = FALSE)

stop()

# READ SNP DATA
# -------------
if (!is.null(bim.file)) {
  cat("Reading SNP data from PLINK .bim file.\n")
  map          <- read.table(bim.file,stringsAsFactors = FALSE)
  names(map)   <- c("chr","id","dist","pos","A1","A2")
  map[,"dist"] <- 0
}

