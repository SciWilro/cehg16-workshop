# TO DO: Explain here what this script does.
#
# Probably a combination of PLINK commands that could accomplish the
# same thing.

# SCRIPT PARAMETERS
# -----------------
# There are two variables you need to set to run this script: (1)
# geno.file, which contains the genotypes in a file downloaded from
# Ancestry.com; (2) bim.file, the list of SNPs to keep (set to NULL to
# retain all the genotype data).
geno.file <- "peter_carbonetto_ancestry1.txt"
bim.file  <- "../data/panel/1kg_hgdp.bim"
out.file  <- "peter_pcarbonetto_ancestry1"
iid       <- "pc1"
fid       <- 0

# READ GENOTYPE DATA
# ------------------
cat("Reading genotypes from Ancestry data file.\n")
geno        <- read.table(geno.file,header = TRUE,stringsAsFactors = FALSE)
names(geno) <- c("id","chr","pos","A1","A2")
geno        <- cbind(geno,data.frame(dist = 0))
geno        <- geno[c("chr","id","dist","pos","A1","A2")]
cat("Loaded genotype data at",nrow(geno),"SNPs.\n")

# OPTIONALLY, SELECT SNPs IN .bim FILE
# ------------------------------------
if (!is.null(bim.file)) {
  cat("Reading SNP data from PLINK .bim file.\n")
  map          <- read.table(bim.file,stringsAsFactors = FALSE)
  names(map)   <- c("chr","id","dist","pos","A1","A2")
  map[,"dist"] <- 0
  cat("Loaded map info for",nrow(map),"SNPs.\n")
  
  # Select SNPs that have the same identifer in the Ancestry file and
  # in the PLINK .bim file.
  rownames(geno) <- geno$id
  rownames(map)  <- map$id
  ids            <- intersect(geno$id,map$id)
  geno           <- geno[ids,]
  map            <- map[ids,]

  # Next, I remove any SNPs that disagree on the chromosome. This is
  # not a foolproof check, and there could remain some entries that
  # refer to different SNPs after this check. But it should take care
  # of most of errors that are likely to occur.
  markers <- which(geno$chr == map$chr)
  geno    <- geno[markers,]
  map     <- map[markers,]

  # Get the base-pair positions from the .bim file.
  geno$pos       <- map$pos
  rownames(geno) <- NULL
  rownames(map)  <- NULL
  
  # Summarize the results of these processing steps.
  cat("Aftering processing, we have genotypes at",nrow(geno),"SNPs.\n")
  
  # Fix SNPs that differ on the strand.
  cat("Fixing strand differences to match .bim file.\n")
  for (i in c("A1","A2")) {
    geno[geno[[i]] == "A" & map$A1 != "A" & map$A2 != "A",i] <- "T"
    geno[geno[[i]] == "T" & map$A1 != "T" & map$A2 != "T",i] <- "A"
    geno[geno[[i]] == "G" & map$A1 != "G" & map$A2 != "G",i] <- "C"
    geno[geno[[i]] == "C" & map$A1 != "C" & map$A2 != "C",i] <- "G"
  }
}


# WRITE SNP DATA TO .map FILE
# ---------------------------
cat("Writing SNP data to PLINK .map file.\n")
write.table(geno[c("chr","id","dist","pos")],paste0(out.file,".map"),
            sep = " ",row.names = FALSE,col.names = FALSE,quote = FALSE)

# WRITE GENOTYPE DATA TO .ped FILE
# --------------------------------
cat("Writing genotypes to PLINK .ped file.\n")
write.table(cbind(data.frame(fid = fid,iid = iid,pid = 0,mid = 0,sex = 0,
                             pheno = -9),geno[c("A1","A2")]),
            paste0(out.file,".ped"),sep = " ",row.names = FALSE,
            col.names = FALSE,quote = FALSE)
