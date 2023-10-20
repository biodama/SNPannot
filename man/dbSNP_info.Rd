\name{dbSNP_info}
\alias{dbSNP_info}
\title{dbSNP_info}
\description{

  dbSNP_info() searches the dbSNP database belonging to NCBI and Ensembl genome browser in order to annotate the genes belonging to that SNP according to their name or position in build loci 37 or build loci 38 and also SNP in linkage disequilibrium (LD).

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
\item{dat}{The data to be searched in dbSNP. There are three options:
If NULL, the default, the function gives an error.
A data.frame with the values to be searched.}
\item{type}{Argument indicating the type of data to be entered into the function. If "pos" the search is performed by chromosome (1, 2, ..., 22, X, Y, MT):position. If is "rs" the search is performed by SNP name.}
\item{p}{Parallelization. If is FALSE, the default, the search is carried out without parallelisation. If TRUE, the function parallelises the searches.}
\item{build}{Build in which to search. If is 37, the default, the search is performed by build loci 37. If 38, the search is performed by build loci 38.}
\item{r2}{Squared Pearson correlation coefficient when searching for variants in LD. Default = 0.99}
\item{pop}{Population to use as reference panel when searching for variants in LD. Default = "EUR"}
}


\details{

The window size is set by default to 500 kb when searching for variants in LD

}

\examples{

library(SNPannot)

temp <- data.table::fread("https://ftp.ebi.ac.uk/pub/databases/spot/pgs/scores/PGS000146/ScoringFiles/Harmonized/PGS000146_hmPOS_GRCh37.txt.gz",skip=19)
temp$pos<-paste0(temp$"chr_name",":",temp$"chr_position")
temp<-data.frame(temp)
head(temp)

res_loop<-dbSNP_info(dat=temp[,1],type="rs",p=FALSE,build=37,r2=0.99,pop="EUR")
head(res_loop)

  #Parallel

res_par<-dbSNP_info(dat=temp[,1],type="rs",p=TRUE,build=37,r2=0.99,pop="EUR")
head(res_par)




}
