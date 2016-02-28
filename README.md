![Example of plotting ADMIXTURE results](/images/admixture-demo.gif)

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
([link](http://www.genetics.ucla.edu/software/admixture/download.html)).

2. Download and install R ([link](http://cran.r-project.org)). Verify
that you can create graphics in R by entering command
<code>plot(1,1)</code> in the R console. If this command does not
generate a figure, you will need to download and install the necessary
software on your computer for generating graphics (see
[here](http://cran.r-project.org/bin/macosx/RMacOSX-FAQ.html) for
instructions specific to Mac OS X).

3. Install the following R packages using function
<code>install.packages</code>: lattice, latticeExtra, Hmisc, ggplot2.

4. Optionally, download and install git
([link](http://git-scm.com/download)).

5. Download the files from this github repository. This can be
accomplished in one of two ways. You can either download all the files
in a single ZIP file by clicking the "Download ZIP" button. Or you can
"clone" the repository with git by running command <code>git clone
url</code>, where <code>url</code> is the "clone url" next to the
"SSH" or "HTTPS" button toward the top of the github webpage.

6. We use PLINK for some of the optional exercises. Download and
install PLINK from [here](http://www.cog-genomics.org/plink2).

7. Optionally, download genotype data from your personal account.

8. Finally, there are a few other data files that are too large to be
included in this repository, so they will have to be downloaded
separately. Download these files from the URL that will be given to
you during the workshop. Alternatively, copy the files from one of the
USB flash drives that will be circulated during the workshop. Once you
have obtained the tar.gz archive, decompress it.

**Note:** We are assuming in these exercises that you are using a
UNIX-based command line, such as Linux, or Terminal in Mac OS X. It is
possible to complete these exercises in Windows, but the exact steps
will be slightly different.

### Exercise 1: Exploring global human variation using ADMIXTURE

The primary aim of this exercise is to learn how to visualize and
interpret the results of running ADMIXTURE on a collection of
genotypes. Here we will use R entirely for this aim. A secondary
objective is to learn about some flexible R packages---lattice and
ggplot---for visualizing data.

[ADMIXTURE](http://dx.doi.org/10.1101/gr.094052.109) is a method for
discovering latent structure from a collection of genotype
samples. Unlike principal component analysis (PCA), another widely
used statistical technique for analyzing genetic data, ADMIXTURE is
based on a model; that is, it proposes a (very simple) model of
genetic transmission, then adjusts the model parameters to best fit
the data. Although the ADMIXTURE model is simple and therefore cannot
capture many complexities of natural populations, an important
advantage is ADMIXTURE results are easier to interpret. By contrast,
PCA provides more flexible statistical analysis that can capture a
wide range of population structure, but this flexibility comes at the
cost of making the interpretation more challenging, and therefore
[increases the potential for
misinterpretation](http://dx.doi.org/10.1038/ng.139).

In this exercise, we will investigate the results of running ADMIXTURE
on a set of 2,756 genotype samples that were collected with the intent
of learning about global human genetic diversity. In particular, we
will use R to visualize the parameters of the ADMIXTURE model that
were fit to these data. Note that while specialized software toolkits
(e.g.,
[DISTRUCT](http://web.stanford.edu/group/rosenberglab/index.html))
have been developed for the specific purpose of visualizing population
structure from programs such as STRUCTURE and ADMIXTURE, we will see
that only a few lines of R code are necessary to develop effective
visualizations of these data.
 
#### ADMIXTURE output files

In the standard invocation, ADMIXTURE outputs two files: a text file
that ends with .P, and another that ends with .Q. The first text file
gives the allele frequency estimates for each population. These allele
frequency estimates are represented as a p x K matrix, where p is the
number of genetic variants (SNPs), and K is the number of ancestral
populations. (See the figure below.)

The second text file gives the estimated admixture proportions for
each sample. The admixture estimates are represented as an n x K
matrix, where n is the number of samples, and K is the number of
ancestral populations. The numbers in each line (or, equivalently, row
of the matrix) should add up to 1.

![ADMIXTURE output](/images/admixture-output.gif)

Unfortunately, despite the fact that the ADMIXTURE model is simple,
fitting the model parameters to these data is a challenging
computational problem. We found that optimizing the model parameters
took as long as 6 hours on a multicore machine with 25
CPUs. Therefore, we have included pre-computed ADMIXTURE results in
the [data/admixture](/data/admixture) directory. (This is the command
we used to generate our results in case you would like to reproduce
them: <code>admixture --seed=1 1kg_hgdp.bed K</code>, where K is 7 or
11.) The files with the .out extension store the console output from
running ADMIXTURE. We ran ADMIXTURE with K = 7 and K = 11 ancestral
populations in order to capture population structure at two different
resolutions.

#### R scripts

For this exercise, we have developed two R scripts:
[plot.admixture.by.pop.R](/R/plot.admixture.by.pop.R) and
[plot.admixture.by.group.R](/R/plot.admixture.by.group.R). The first
script summarizes the distribution of admixture proportions across a
data set for a single ancestral population. The second script
summarizes the distribution of admixture proportions across a
collection of samples assigned the same label (or labels). See the
comments at the top of each of these files for detailed instructions
on how to use these scripts. Each of these scripts uses the
group/region labels to connect the ADMIXTURE results to prior
knowledge about the ethnic or geographic origins of the samples. These
labels are stored in [1kg_hgdp.lab](/data/panel/1kg_hgdp.lab).

#### Questions

- How would you characterize each of the 7 (or 11) ancestral
  populations based on the summaries generated by the two R scripts? 

- What histories of these groups can you infer from running
  [plot.admixture.by.group.R](/R/plot.admixture.by.group.R) with
  different labels or sets of labels?  
  
- Are there any groups or samples that do not closely fit your
  historical interpretation of these populations?

- Are any of the ancestral populations difficult to interpret, or do
  not align well with your prior knowledge of human history or
  demography?

- *Optional:* Explore ADMIXTURE results with K=11 ancestral populations.

- *Optional:* Can you suggest ways of improving these visualizations
  of the admixture proportions?

### Exercise 2: Predicting ancestral admixture proportions from genotypes using a global variation reference panel

In this second exercise, we will use the ADMIXTURE results we
generated from the combined HGDP + 1000 Genomes genotype panel to make
admixture predictions for new genotype samples. We will see that once
the hard work of fitting the ADMIXTURE model has already been
accomplished, estimating admixture proportions for new samples is very
fast. This illustrates how we can leverage large genetic data sets to
quickly estimate admixture proportions for any number of new
individuals (e.g., AncestryDNA customers). Here we will continue to
work with the HGDP and 1000 Genomes data, but optionally you may also
apply this analysis to your own genotypes (e.g., downloaded from your
personal account).

#### PLINK files

Here we will work with PLINK data files. These files have been shared
with you separately because they are too large to store in the public
github repository. First, take a look at files
<code>1kg_hgdp_test.map</code> and <code>1kg_hgdp_test.ped</code>. The
first file gives us information about the 162,645 SNPs; each line
gives, from left to right, the chromosome, SNP database identifier,
genetic distance (which isn't used here, so it is set to 0), and the
base-pair position.

The second, much larger text file contains the genotypes at these
SNPs, in which each line of this file corresponds to a sample. The
left-most 6 entries of each line are not used here, except the sample
id in the second column. The remaining entries give the called
genotypes; each pair of letters (e.g., "A G") gives the genotype at a
SNP in the .map file.

Storing the genotypes in this way is very inefficient, so the rest of
the genotype data are stored in the more compressed ".bed"
format. (For more details on PLINK file formats, see
[here](http://www.cog-genomics.org/plink2/formats).) The .bed files
store the genotype data for three data sets: the full HGDP + 1000
Genomes panel with 2,756 genotype samples, and this panel split into a
"training" and "test" set with 2,656 and 100 samples,
respectively. Once you have genotypes stored in this format, you can
analyze these genotypes using ADMIXTURE.

#### The ADMIXTURE -P option

Now that we have explored the genotype data files in PLINK format, we
are ready to estimate ancestral admixture from previously computed
population allele frequencies. For example, to estimate admixture
proportions in the 100 test samples for 7 ancestral populations using
the allele frequencies estimated from the full panel, run the
following commands (here we are assuming you have a multicore computer
with 4 CPUs):

     cp 1kg_hgdp.7.P 1kg_hgdp_test.7.P.in
     admixture -j4 -P 1kg_hgdp_test.bed 7

Although the model fitting, as we mentioned previously, is
computationally intensive, this step should complete in the order of
several minutes on your laptop. The allele frequency files
<code>1kg_hgdp.7.P</code> and <code>1kg_hgdp.11.P</code> were shared
with you separately since they are quite large.

#### Testing ADMIXTURE with your own genotypes

If you have taken a DNA test, and you are especially motivated, you
can also include your genotypes in the test set. Note that you will
need PLINK for this.

Let's suppose you have taken two DNA tests, and your name is Frida
Kahlo. Assuming that you have the genotypes stored in two separate
.ped files, merge these genotypes with the other test samples, and
create a .bed file, with the following commands:

    cat 1kg_hgdp_test.ped frida_kahlo_dna1.ped \
	  frida_kahlo_dna2.ped > mytest.ped
	cp 1kg_hgdp_test.map mytest.map
	plink2 --file mytest --make-bed --out mytest

Now you are ready to run ADMIXTURE on this test set augmented with
your genotypes. You may find script
[plot.myadmixture.R](/R/plot.myadmixture.R) useful for visualizing
your results.


#### Visualizing Admixture Proportions on the Map

In the R folder you find a script named plot.admixture.by.geolocation.R
Using this script we will plot the pie chart of the average admxiture proportion (for K=7)
on the world map.

#### Questions

- Compare the admixture estimates you generated for the test samples
  against the admixture estimates
  [1kg_hgdp.7.Q](/data/admixture/1kg_hgdp.7.Q) obtained by running
  ADMIXTURE on the full reference panel. Use R scripts
  [plot.admixture.by.group.R](/R/plot.admixture.by.group.R),
  [plot.admixture.by.pop.R](/R/plot.admixture.by.pop.R) and
  [compare.admixture.R](/R/compare.admixture.R) for this. How
  different are the admixture estimates overall? Do you get different
  results for some groups or individual samples?

- Repeat the same steps as before, but this time use the allele
  frequency file <code>1kg_hgdp_train.7.P</code> generated from the
  slightly smaller reference panel that does not contain any of the
  samples included in the test set. This represents the more realistic
  scenario in which we are attempting to predict admixture proportions
  for genotypes that are not included in the refrence panel. Use the R
  scripts to compare the two different admixture results for the test
  samples. How different are the two sets of admixture estimates? Are
  some estimates more different for certain samples or groups? Do you
  notice any overall trends in these differences? 

- *Optional:* Re-investigate these questions with K = 11 ancestral
   populations.
  
### Exit slip

*To do: add exit slip here.*

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
[Amir Kermany @akermany](http://www.linkedin.com/in/akermany)<br>
[AncestryDNA](http://dna.ancestry.com)<br>
San Francisco, CA<br>
March, 2016

All members of the AncestryDNA Science Team have contributed to this
work in some way; in particular, Yong Wang did much of the initial
legwork in compiling the HGDP and 1000 Genomes data, and sorting out
potential issues with these data. Also, thanks Suyash Shringarpure and
John Novembre for their input on some aspects of the ADMIXTURE analysis.
