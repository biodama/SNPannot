
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SNPannot

<!-- badges: start -->
<!-- badges: end -->

SNPannot is a package designed to perform an annotation of single
nucleotide polymorphisms. <br /> <br /> This package has been developed
in the context of the CIBERESP Strategic Subprogram Genrisk
(<https://cancer.genrisk.org/en/>).

## Installation

You can install the development version of SNPannot from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("biodama/SNPannot")
```

## Data Source

This set of functions in package accesses data from:

- **NCBI’s dbSNP SNP database**
  - See [](https://www.ncbi.nlm.nih.gov/snp/) for more details.
  - Function: **dbSNP_info()**
- **Ensembl genome database**
  - See [](https://www.ensembl.org/index.html) for more details.
  - Function: **dbSNP_info()**
- **NCBI’s dbSNP Gene database**
  - See [](https://www.ncbi.nlm.nih.gov/gene/) for more details.
  - Function: **snp_gene()**
- **Ontology Resource**
  - See [](http://geneontology.org/) for more details.
  - Function: **snp_gene()**
  - Require packages: **ontologyIndex** , **ontologySimilarity**

## Example 1

### **dbSNP_info()**

Searches the dbSNP database belonging to NCBI and Ensembl genome browser
in order to annotate the genes belonging to that SNP. According to the
SNP name or position, the function annotates the GRCh37, GRCh38 and also
SNPs in linkage disequilibrium (LD).

``` r
library(SNPannot)

temp <- data.table::fread("https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS000146/ScoringFiles/Harmonized/PGS000146_hmPOS_GRCh37.txt.gz",
  skip = 19)
temp$pos <- paste0(temp$chr_name, ":", temp$chr_position)
temp <- data.frame(temp)
```

<table>
<thead>
<tr>
<th style="text-align:center;">
rsID
</th>
<th style="text-align:center;">
effect-allele
</th>
<th style="text-align:center;">
other-allele
</th>
<th style="text-align:center;">
MAF
</th>
<th style="text-align:center;">
hm-source
</th>
<th style="text-align:center;">
hm-rsID
</th>
<th style="text-align:center;">
Position
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
rs10911251
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.57
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs10911251
</td>
<td style="text-align:center;">
1:183081194
</td>
</tr>
<tr>
<td style="text-align:center;">
rs6687758
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.20
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs6687758
</td>
<td style="text-align:center;">
1:222164948
</td>
</tr>
<tr>
<td style="text-align:center;">
rs11903757
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs11903757
</td>
<td style="text-align:center;">
2:192587204
</td>
</tr>
<tr>
<td style="text-align:center;">
rs10936599
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.77
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs10936599
</td>
<td style="text-align:center;">
3:169492101
</td>
</tr>
<tr>
<td style="text-align:center;">
rs647161
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.67
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs647161
</td>
<td style="text-align:center;">
5:134499092
</td>
</tr>
<tr>
<td style="text-align:center;">
rs1321311
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.25
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs1321311
</td>
<td style="text-align:center;">
6:36622900
</td>
</tr>
<tr>
<td style="text-align:center;">
rs16892766
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs16892766
</td>
<td style="text-align:center;">
8:117630683
</td>
</tr>
<tr>
<td style="text-align:center;">
rs6983267
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.50
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs6983267
</td>
<td style="text-align:center;">
8:128413305
</td>
</tr>
<tr>
<td style="text-align:center;">
rs719725
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.62
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs719725
</td>
<td style="text-align:center;">
9:6365683
</td>
</tr>
<tr>
<td style="text-align:center;">
rs10795668
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.69
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs10795668
</td>
<td style="text-align:center;">
10:8701219
</td>
</tr>
<tr>
<td style="text-align:center;">
rs3824999
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.51
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs3824999
</td>
<td style="text-align:center;">
11:74345550
</td>
</tr>
<tr>
<td style="text-align:center;">
rs3802842
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.29
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs3802842
</td>
<td style="text-align:center;">
11:111171709
</td>
</tr>
<tr>
<td style="text-align:center;">
rs10774214
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.38
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs10774214
</td>
<td style="text-align:center;">
12:4368352
</td>
</tr>
<tr>
<td style="text-align:center;">
rs3217810
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs3217810
</td>
<td style="text-align:center;">
12:4388271
</td>
</tr>
<tr>
<td style="text-align:center;">
rs3217901
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.41
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs3217901
</td>
<td style="text-align:center;">
12:4405389
</td>
</tr>
<tr>
<td style="text-align:center;">
rs7136702
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.32
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs7136702
</td>
<td style="text-align:center;">
12:50880216
</td>
</tr>
<tr>
<td style="text-align:center;">
rs59336
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.48
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs59336
</td>
<td style="text-align:center;">
12:115116352
</td>
</tr>
<tr>
<td style="text-align:center;">
rs1957636
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.41
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs1957636
</td>
<td style="text-align:center;">
14:54410919
</td>
</tr>
<tr>
<td style="text-align:center;">
rs4444235
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.46
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs4444235
</td>
<td style="text-align:center;">
14:54560018
</td>
</tr>
<tr>
<td style="text-align:center;">
rs4779584
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.18
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs4779584
</td>
<td style="text-align:center;">
15:32994756
</td>
</tr>
<tr>
<td style="text-align:center;">
rs9929218
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
0.70
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs9929218
</td>
<td style="text-align:center;">
16:68820946
</td>
</tr>
<tr>
<td style="text-align:center;">
rs4939827
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.52
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs4939827
</td>
<td style="text-align:center;">
18:46453463
</td>
</tr>
<tr>
<td style="text-align:center;">
rs10411210
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.90
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs10411210
</td>
<td style="text-align:center;">
19:33532300
</td>
</tr>
<tr>
<td style="text-align:center;">
rs961253
</td>
<td style="text-align:center;">
A
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
0.35
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs961253
</td>
<td style="text-align:center;">
20:6404281
</td>
</tr>
<tr>
<td style="text-align:center;">
rs4813802
</td>
<td style="text-align:center;">
G
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.34
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs4813802
</td>
<td style="text-align:center;">
20:6699595
</td>
</tr>
<tr>
<td style="text-align:center;">
rs2423279
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.25
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs2423279
</td>
<td style="text-align:center;">
20:7812350
</td>
</tr>
<tr>
<td style="text-align:center;">
rs4925386
</td>
<td style="text-align:center;">
C
</td>
<td style="text-align:center;">
T
</td>
<td style="text-align:center;">
0.69
</td>
<td style="text-align:center;">
ENSEMBL
</td>
<td style="text-align:center;">
rs4925386
</td>
<td style="text-align:center;">
20:60921044
</td>
</tr>
</tbody>
</table>

``` r
# Searching for information on some SNPs
res_loop <- dbSNP_info(dat = temp[5:10, 1], type = "rs", p = T, build = 37, r2 = 0.999,
  pop = "EUR")
```

<table>
<thead>
<tr>
<th style="text-align:center;">
term
</th>
<th style="text-align:center;">
rsID
</th>
<th style="text-align:center;">
Gene
</th>
<th style="text-align:center;">
Func
</th>
<th style="text-align:center;">
GRCh37
</th>
<th style="text-align:center;">
GRCh38
</th>
<th style="text-align:center;">
rsLD
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
rs647161
</td>
<td style="text-align:center;">
rs647161
</td>
<td style="text-align:center;">
PITX1-AS1
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
5:134499092
</td>
<td style="text-align:center;">
5:135163402
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
rs1321311
</td>
<td style="text-align:center;">
rs1321311;rs59148954
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
6:36622900
</td>
<td style="text-align:center;">
6:36655123
</td>
<td style="text-align:center;">
rs9918353;rs9470358
</td>
</tr>
<tr>
<td style="text-align:center;">
rs16892766
</td>
<td style="text-align:center;">
rs16892766;rs386541188;rs58713577
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
8:117630683
</td>
<td style="text-align:center;">
8:116618444
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
rs6983267
</td>
<td style="text-align:center;">
rs6983267;rs61163584;rs17467153
</td>
<td style="text-align:center;">
CASC8;CCAT2
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
8:128413305
</td>
<td style="text-align:center;">
8:127401060
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
rs719725
</td>
<td style="text-align:center;">
rs719725
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
9:6365683
</td>
<td style="text-align:center;">
9:6365683
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
rs10795668
</td>
<td style="text-align:center;">
rs10795668;rs60782192
</td>
<td style="text-align:center;">
LOC105376400
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
10:8701219
</td>
<td style="text-align:center;">
10:8659256
</td>
<td style="text-align:center;">
</td>
</tr>
</tbody>
</table>

## Example 2

### **snp_gene()**

Searches NCBI Gene database and Gene Ontology Resource in order to
obtain relevant and specific information about the entered genes. The
function can be based on data generated by the *dbSNP_info()*, or on
user data.

``` r
# Searching for information on some SNPs
snps_info <- dbSNP_info(dat = temp[c(3, 10, 12:13), 1], type = "rs", p = T, build = 37,
    r2 = 0.999, pop = "EUR")
genes_info1 <- snp_gene(dat = snps_info, type = "info", p = T)
```

<table>
<thead>
<tr>
<th style="text-align:center;">
term
</th>
<th style="text-align:center;">
hgnc
</th>
<th style="text-align:center;">
Entrez-id
</th>
<th style="text-align:center;">
full-name
</th>
<th style="text-align:center;">
gene-type
</th>
<th style="text-align:center;">
refseq
</th>
<th style="text-align:center;">
also
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
LOC124908062
</td>
<td style="text-align:center;">
LOC124908062
</td>
<td style="text-align:center;">
124908062
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
ncRNA
</td>
<td style="text-align:center;">
MODEL
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
LOC105376400
</td>
<td style="text-align:center;">
LOC105376400
</td>
<td style="text-align:center;">
105376400
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
ncRNA
</td>
<td style="text-align:center;">
MODEL
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
COLCA2
</td>
<td style="text-align:center;">
COLCA2
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
COLCA1
</td>
<td style="text-align:center;">
COLCA1
</td>
<td style="text-align:center;">
399948
</td>
<td style="text-align:center;">
colorectal cancer associated 1
</td>
<td style="text-align:center;">
ncRNA
</td>
<td style="text-align:center;">
VALIDATED
</td>
<td style="text-align:center;">
CASC12; C11orf92; LOH11CR1F
</td>
</tr>
<tr>
<td style="text-align:center;">
CCND2-AS1
</td>
<td style="text-align:center;">
CCND2-AS1
</td>
<td style="text-align:center;">
103752584
</td>
<td style="text-align:center;">
CCND2 antisense RNA 1
</td>
<td style="text-align:center;">
ncRNA
</td>
<td style="text-align:center;">
VALIDATED
</td>
<td style="text-align:center;">
CCND2-AS2
</td>
</tr>
</tbody>
</table>
<table>
<thead>
<tr>
<th style="text-align:center;">
term
</th>
<th style="text-align:center;">
info
</th>
<th style="text-align:center;">
GO-id
</th>
<th style="text-align:center;">
GO-des
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
LOC124908062
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
LOC105376400
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
<tr>
<td style="text-align:center;">
COLCA2
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
<GO:0005737>
</td>
<td style="text-align:center;">
cytoplasm
</td>
</tr>
<tr>
<td style="text-align:center;">
COLCA1
</td>
<td style="text-align:center;">
This gene encodes a transmembrane protein that localizes to granular
structures, including crystalloid eosinophilic granules and other
granular organelles. This gene, along with an overlapping opposite
strand gene, has been implicated as a susceptibility locus for
colorectal cancer. Alternative splicing of this gene results in multiple
transcript variants. \[provided by RefSeq, Nov 2014\]
</td>
<td style="text-align:center;">
<GO:0016020;GO:0016021>
</td>
<td style="text-align:center;">
membrane;integral component of membrane
</td>
</tr>
<tr>
<td style="text-align:center;">
CCND2-AS1
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
</tr>
</tbody>
</table>

## License

[CC BY-NC-ND
4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/?ref=chooser-v1)
