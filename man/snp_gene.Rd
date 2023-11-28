\name{snp_gene}
\alias{snp_gene}
\title{snp_gene}

\description{
snp_gene() searches NCBI Gene database and Gene Ontology Resource in order to obtain relevant and specific information about the entered genes.



}
\usage{

snp_gene(dat=NULL,
type=c("info","hgnc","entrezid"),
p=F

)

}
\arguments{

\item{dat}{The data to be searched in Gene. There are three options:
If NULL, the default, the function gives an error.
A data.frame with the values to be searched.}

\item{term}{Argument indicating the type of data to be entered into the function. There are three options:

  Item "info" the search is performed with the genes obtained by applying the function dbSNP_info().

  Item "hgnc" the search is performed with the HGN nomenclature.

  Item "entrezid" the search is performed with the ID gene.}

\item{p}{Parallelization. If is FALSE, the default, the search is carried out without parallelisation. If TRUE, the function parallelises the searches.}

}

\value{

A dataframe that returns the following values:

\item{term}{Entered term to search info}
\item{hgnc}{Name provided by HGNC}
\item{entrez_id}{HGNC identifier}
\item{full_name}{Full name desciption}
\item{gene_type}{Gene type}
\item{refseq}{RefSeq status}
\item{also}{Also known as}
\item{info}{Summary gene description}
\item{GO_id}{Ontology index}
\item{GO_des}{Ontology description}

}


\examples{

library(SNPannot)

temp <- data.table::fread("https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS000146/ScoringFiles/Harmonized/PGS000146_hmPOS_GRCh37.txt.gz",skip=19)
temp$pos<-paste0(temp$"chr_name",":",temp$"chr_position")
temp<-data.frame(temp)

snps_info<-dbSNP_info(dat=temp[,1],type="rs",p=FALSE,build=37,r2=0.99,pop="EUR")
head(snps_info)

# Example 1

genes_info1<-snp_gene(dat=snps_info,type="info",p=F)
  #Parallel
genes_info1<-snp_gene(dat=snps_info,type="info",p=T)

# Example 2

gene_list<-genes_info1$hgnc
genes_info2<-snp_gene(dat=gene_list,type="hgnc",p=F)
  #Parallel
genes_info2<-snp_gene(dat=gene_list,type="hgnc",p=T)

# Example 3

entrez_id_list<-genes_info1$entrez_id
genes_info3<-snp_gene(dat=entrez_id_list,type="entrezid",p=F)
  #Parallel
genes_info3<-snp_gene(dat=entrez_id_list,type="entrezid",p=T)

}
