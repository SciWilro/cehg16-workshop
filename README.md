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

Download ADMIXTURE 1.3.0.

Optionally, install git.

Install the following R packages: lattice, latticeExtra, Hmisc, ggplot2,
data.table, maps.

Give survey of data files: 1000 Genomes, HGDP, PLINK format, ADMIXTURE
output.

### Some background on the genotype data.

In these demos, we work with two genetic data sets that have been made
available to the public: the Human Genome Diversity Project from
Stanford University ([link](http://www.hagsc.org/hgdp)), and Phase 3
of 1000 Genomes Project ([link](http://www.1000genomes.org/data)). The
broad aim of both projects is to comprehensively study global human
genetic variation. 

Combining genotype data from two different sources requires a lot of
care to avoid introducing systematic differences that could skew the
results; for example, SNPs are often defined with respect to different
databases and genome assemblies, and differenct genotyping
technologies may also affect an analysis. Here we have taken some
steps to weed out the most obvious problems, although we note that
these steps are far from comprehensive. These steps include: we only
retain SNPs on autosomal chromosomes; we remove SNPs with the same
dbSNP identifier but found on different chromosomes; we remove SNPs
with over 30 missing genotypes in the combined data set; and we make
sure to define the alleles with respect to the same strand so that the
genotypes are compatible. We use a combination of PLINK and R to
implement all these processing and filtering steps.

Since ADMIXTURE makes the simplifying assumption that all SNPs are
"unlinked", we take an additional step to filter out variants that are
more correlated (in linkage disequilibrium) with each other. This is
accomplished using PLINK:

    plink2 --bfile 1kg_hgdp --indep-pairwise 500kb 250kb 0.2
	plink2 --bfile 1kg_hgdp --extract plink.prune.in --make-bed \
	  --out 1kg_hgdp_new

The final combined data set containes genotypes for 940 HGDP
"unrelated" samples (see
[here](http://rosenberglab.stanford.edu/data/rosenberg2006ahg/SampleInformation.txt))
and 2,756 1000 Genomes samples at 162,645 SNPs.

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

[www.cs.ubc.ca/spider/pcarbo](Peter Carbonetto) and
[http://www.linkedin.com/in/akermany](Amir Kermany)
[AncestryDNA](http://dna.ancestry.com)
San Francisco, CA
February, 2016

All members of the AncestryDNA Science Team have contributed to this
work in some way; in particular, Yong Wang did much of the initial
legwork in compiling the HGDP and 1000 Genomes genotype data, and
sorting out potential issues. Also thanks Suyash Shringarpure and
John Novembre for their input on the ADMIXTURE analysis.
