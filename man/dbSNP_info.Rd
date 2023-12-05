\name{dbSNP_info}
\alias{dbSNP_info}
\title{dbSNP_info}
\description{

\bold{dbSNP_info()} performs an annotation of a given list of SNPs searching information in dbSNP database belonging to NCBI
}

\usage{

dbSNP_info(
  dat=NULL,
  type=c("pos","rs")
  p=FALSE,
  build=37,
  r2=0.99,
  pop="EUR"
)

}
\arguments{
\item{dat}{character vector containing rsIDs (E.g: rs647161) or chr:positions (E.g.: 5:134499092) of the SNPs to be searched}
\item{type}{argument indicating the type of data to be entered into the function. If "pos" the search is performed by chromosome (1, 2, ..., 22, X, Y, MT):position. If is "rs" the search is performed by SNP name.}
\item{p}{Parallelization. If is FALSE (default) the search is carried out without parallelisation. If TRUE, the function parallelises the searches}
\item{build}{If is 37 (default), the search is performed by build loci 37. If 38, the search is performed by build loci 38}
\item{r2}{squared Pearson correlation coefficient when searching for variants in LD. Default = 0.99}
\item{pop}{population to use as reference panel when searching for variants in LD. Default = "EUR"}
}


\details{

The window size is set by default to 500 kb when searching for variants in LD

}

\value{
a dataframe containing the following values:

\item{term}{Entered term to annotate}
\item{rsID}{Alternative names of the SNP}
\item{gene}{Gene to which it belongs}
\item{alleles}{Alleles. Ref>Alt}
\item{GRCh37,GRCh38}{Chromosome position in Build 37 and Build 38}
\item{rs_ld}{SNPs in linkage disequilibrium}


}

\examples{

library(SNPannot)

temp <- data.table::fread("https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS000146/ScoringFiles/Harmonized/PGS000146_hmPOS_GRCh37.txt.gz",skip=19)
temp$pos<-paste0(temp$"chr_name",":",temp$"chr_position")
temp<-data.frame(temp)
head(temp)

res_loop<-dbSNP_info(dat=temp[,1],type="rs",p=FALSE,build=37,r2=0.99,pop="EUR")
head(res_loop)

#####################
#Parallel
#####################

res_par<-dbSNP_info(dat=temp[,1],type="rs",p=TRUE,build=37,r2=0.99,pop="EUR")
head(res_par)




}
