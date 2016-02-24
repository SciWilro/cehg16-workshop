AncestryDNA Workshop: Genomics at Scale
=======================================
Computational, Evolutionary and Human Genomics
([CEHG](http://web.stanford.edu/dept/cehg/cgi-bin/cehg-symposium/program))
Symposium<br>
Stanford University, Palo Alto, California<br>
March 2, 2016

### Introduction

To date, over 1.4 million people have taken the Ancestry DNA
test. This amounts to a data set of 1.1 trillion genotypes across
700,000 SNPs. What are effective strategies and techniques for
analyzing and understanding genomic data at this scale? In this short
workshop, two computational biologists at Ancestry, Amir Kermany and
Peter Carbonetto, demonstrate some simple approaches to investigating
and visualizing large-scale genetic data sets, with an emphasis on
practical skills that can be applied to research in human genetics. We
will walk through several interactive examples, so all attendees are
encouraged to bring their laptop (or pair with a friend who has one),
with R ([link](http://cran.r-project.org)) installed beforehand.
Participants are expected to have a basic familiarity with R, since
this is helpful for working through the examples on site.

### Getting started

To get ready for the workshop, please do the following:

1. Download ADMIXTURE 1.3.0
([link](http://www.genetics.ucla.edu/software/admixture)).

2. Download and install R ([link](http://cran.r-project.org)).

3. Install the following R packages using function
**install.packages**: lattice, latticeExtra, Hmisc, ggplot2,
data.table, maps. *Note: some of these packages may not be
needed. Revisit this list later. -Peter*

4. Optionally, download and install git
([link](http://git-scm.com/download)).

5. Download the files from this github repository. This can be
accomplished in one of two ways. You can either download all the files
in a single ZIP file by clicking the **Download ZIP** button. Or you can
"clone" the repository with git by running command <code>git clone
url</code>, where **url** is the "clone url" next to the
**SSH** or **HTTPS** button toward the top of the github webpage.

6. We use PLINK for some of the optional exercises. Download and
install PLINK from [here](http://www.cog-genomics.org/plink2)).

7. Optionally, download genotype data from your
[Ancestry](images/screenshot-of-ancestry-rawdata-download.png) and/or
[23andme](images/screenshot-of-23andme-rawdata-download.png) accounts.

### A brief survey of the files in this repository 

Give survey of data files: 1000 Genomes, HGDP, PLINK format, ADMIXTURE
output.

### Some background on the genotype data

In these demos, we work with two genetic data sets that have been made
available to the public: the Human Genome Diversity Project from
Stanford University ([link](http://www.hagsc.org/hgdp)), and Phase 3
of 1000 Genomes Project ([link](http://www.1000genomes.org/data)). The
broad aim of both projects is to comprehensively study global human
genetic variation. 

Combining genotype data from two different sources requires a lot of
care to avoid introducing systematic differences that could skew the
results; for example, SNPs are often defined with respect to different
databases and genome assemblies, and different genotyping technologies
may also contribute to unexpected artifacts in the statistical
analysis. Here we have taken some steps to weed out the most likely
problems, although we note that these steps are far from
comprehensive. These steps include: we only retain SNPs on autosomal
chromosomes; we remove SNPs with the same dbSNP identifier but found
on different chromosomes; we remove SNPs with over 30 missing
genotypes in the combined data set; and we define all SNP alleles with
respect to the same strand so that the genotypes are compatible. We
use R and PLINK to implement these steps.

Since ADMIXTURE makes the simplifying assumption that all SNPs are
"unlinked," we take an additional step to filter out variants that are
more correlated (in linkage disequilibrium) with each other. This is
accomplished using PLINK:

    plink2 --bfile 1kg_hgdp --indep-pairwise 500kb 250kb 0.2
	plink2 --bfile 1kg_hgdp --extract plink.prune.in --make-bed \
	  --out 1kg_hgdp_new

The final combined data set containes genotypes at 162,645 SNPs and
2756 samples---940 HGDP "unrelated" samples (see
[here](http://rosenberglab.stanford.edu/data/rosenberg2006ahg/SampleInformation.txt))
and 2,756 samples from the 1000 Genomes Project.

### 1000 Genomes panel

Meaning of population labels from 1000 Genomes panel, according to
Supplementary Table 1 of the most recent *1000 Genomes* paper
([link](http://dx.doi.org/10.1038/nature15393)).

<pre> code  meaning
  ACB  African Caribbean in Barbados.
  ASW  People with African Ancestry in Southwest USA.
  CDX  Chinese Dai in Xishuangbanna, China.
  CEU  Utah residents (CEPH) with Northern and Western European ancestry.
  CHB  Han Chinese in Beijing, China.
  CHD  Han Chinese from Denver, Colorado.
  CHS  Southern Han Chinese.
  CLM  Colombians in Medellin, Colombia.
  FIN  Finnish in Finland.
  GIH  Gujarati Indians in Houston, TX, USA.
  GBR  British in England and Scotland.
  IBS  Iberian Populations in Spain.
  JPT  Japanese in Tokyo, Japan.
  KHV  Kinh in Ho Chi Minh City, Vietnam.
  LWK  Luhya in Webuye, Kenya.
  MXL  People with Mexican Ancestry in Los Angeles, CA, USA.
  PEL  Peruvians in Lima, Peru.
  PUR  Puerto Ricans in Puerto Rico.
  TSI  Toscani in Italia.
  YRI  Yoruba in Ibadan, Nigeria.
</pre>

### Contributors

[Peter Carbonetto](www.cs.ubc.ca/spider/pcarbo) and
[Amir Kermany](http://www.linkedin.com/in/akermany)<br>
[AncestryDNA](http://dna.ancestry.com)<br>
San Francisco, CA<br>
March, 2016

All members of the AncestryDNA Science Team have contributed to this
work in some way; in particular, Yong Wang did much of the initial
legwork in compiling the HGDP and 1000 Genomes data, and sorting out
potential issues with these data. Also, thanks Suyash Shringarpure and
John Novembre for their input on some aspects of the ADMIXTURE analysis.
