
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SNPannot

<!-- badges: start -->
<!-- badges: end -->

SNPannot is a package designed to perform an annotation of single
nucleotide polymorphisms.

## Installation

You can install the development version of SNPannot from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("biodama/SNPannot")
```

## Example 1

This is a basic example which shows you how to load the library an use
dbSNP_info.

``` r
library(SNPannot)

temp <- data.table::fread("https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS000146/ScoringFiles/Harmonized/PGS000146_hmPOS_GRCh37.txt.gz",skip=19)
temp$pos<-paste0(temp$"chr_name",":",temp$"chr_position")
temp<-data.frame(temp)
head(temp)

res_loop<-dbSNP_info(dat=temp[,1],type="rs",p=FALSE,build=37,r2=0.99,pop="EUR")


  #Parallel

res_par<-dbSNP_info(dat=temp[,1],type="rs",p=TRUE,build=37,r2=0.99,pop="EUR")
```

## Example 2

This is a basic example which shows you how to load the library an use
snp_gene.

``` r
temp <- data.table::fread("https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS000146/ScoringFiles/Harmonized/PGS000146_hmPOS_GRCh37.txt.gz",skip=19)
temp$pos<-paste0(temp$"chr_name",":",temp$"chr_position")
temp<-data.frame(temp)

snps_info<-dbSNP_info(dat=temp[,1],type="rs",p=FALSE,build=37,r2=0.99,pop="EUR")
head(snps_info)

# Example 2.1

genes_info1<-snp_gene(dat=snps_info,type="info",p=F)
  #Parallel
genes_info1<-snp_gene(dat=snps_info,type="info",p=T)

# Example 2.2

gene_list<-genes_info1$hgnc
genes_info2<-snp_gene(dat=gene_list,type="hgnc",p=F)
  #Parallel
genes_info2<-snp_gene(dat=gene_list,type="hgnc",p=T)

# Example 2.3

entrez_id_list<-genes_info1$entrez_id
genes_info3<-snp_gene(dat=entrez_id_list,type="entrezid",p=F)
  #Parallel
genes_info3<-snp_gene(dat=entrez_id_list,type="entrezid",p=T)
```
