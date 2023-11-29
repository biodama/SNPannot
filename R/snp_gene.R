snp_gene<-function(dat=NULL,type=c("info","hgnc","entrezid"),p=F){


  x<-dat[1]

  if(is.null(x)==T || is.null(type)==T){
    stop("ERROR: INTRODUCE dat AND type TERMS")

  }else{
    pack<-c("ontologyIndex","ontologySimilarity")

    for(pck in pack){
      if (!require(pck,character.only=T)) {
        install.packages(pck)
        library(pck,character.only=T)
      }else{
        library(pck,character.only=T)
      }
    }

    search_gene<-function(dat,type){

      if(type=="info"){
        gen<-dat
        url_check<-paste0("https://www.ncbi.nlm.nih.gov/gene?term=((",gen,"%5BGene%20Name%5D)%20AND%20Homo%20sapiens%5BOrganism%5D)%20AND%20",gen,"%5BPreferred%20Symbol%5D")

      }
      if(type=="hgnc"){
        gen<-dat
        url_check<-paste0("https://www.ncbi.nlm.nih.gov/gene?term=((",gen,"%5BGene%20Name%5D)%20AND%20Homo%20sapiens%5BOrganism%5D)%20AND%20",gen,"%5BPreferred%20Symbol%5D")
      }
      if(type=="entrezid"){
        gen<-dat
        url_check<-paste0("https://www.ncbi.nlm.nih.gov/gene?term=",gen,"%5Buid%5D")
      }


      inicio<-Sys.time()

      thepage = try(readLines(url_check,warn=F),silent=T)
      tiempo<-as.numeric(difftime(Sys.time(),inicio,units="secs"))

      while(class(thepage)=="try-error" & tiempo<=10){

        rm(tiempo)
        thepage = try(readLines(url_check,warn=F),silent=T)
        tiempo<-as.numeric(difftime(Sys.time(),inicio,units="secs"))

      }


      if(class(thepage)=="try-error"){

        thepage = "NO RESULT"

      }

      if(class(thepage)!="try-error"){


        check<-length(grep("message = 'No results'",thepage))

        if(check>0){

          thepage = "NO RESULT"

        }


      }

      info<-thepage

      if(length(info)==1){


        table_info= "NO RESULT"


      }
      if(length(info)>1){



        # ENTREZ_ID
        entrez_id <- try(unlist(strsplit(unlist(strsplit(info[grep("ncbi_uid=",info)],split="ncbi_uid="))[2],split="&amp;link_uid"))[1],silent=T)
        if(class(entrez_id)=="try-error"){
          entrez_id<-""
        }

        # Official Full Name

        fulln<-try(unlist(strsplit(unlist(strsplit(info[grep("Full Name",info)+1],split="<span class"))[1],split="<dd>"))[2],silent=T)
        if(class(fulln)=="try-error"){
          fulln<-""
        }

        # Gene type

        genety<-try(unlist(strsplit(unlist(strsplit(info[grep("Gene type",info)+1],split="<span class"))[1],split="<dd>"))[2],silent=T)
        if(class(genety)=="try-error"){
          genety<-""
        }else{
          genety<-gsub("</dd>","",unlist(strsplit(unlist(strsplit(info[grep("Gene type",info)+1],split="<span class"))[1],split="<dd>"))[2])
        }

        # RefSeq status

        refsta<-try(gsub("</dd>","",unlist(strsplit(unlist(strsplit(info[grep("RefSeq status",info)+1],split="<span class"))[1],split="<dd>"))[2]),silent=T)
        if(class(refsta)=="try-error"){
          refsta<-""
        }

        # Also known as

        aka<-try(unlist(strsplit(unlist(strsplit(info[grep("Also known as",info)+1],split="<span class"))[1],split="<dd>"))[2],silent=T)
        if(class(aka)=="try-error"){
          aka<-""
        }else{
          aka<-gsub("</dd>","",unlist(strsplit(unlist(strsplit(info[grep("Also known as",info)+1],split="<span class"))[1],split="<dd>"))[2])
        }


        # Summary
        summa<- gsub("</dd>","",info[grep("<dt>Summary</dt>",info)+1])
        summa<- try(gsub("        <dd>","",summa),silent=T)
        if(length(grep("<dt>Summary</dt>",info))<1){
          summa<-""
        }


        # hgnc

        if(type=="entrezid"){

          hgnc<-try(unlist(strsplit(unlist(strsplit(info[grep("Symbol",info)+1][2],split="<span>"))[2],split="</span>")[1]),silent=T)
          if(class(hgnc)=="try-error"){
            hgnc<-""
          }


        }else{

          hgnc<-gen


        }

        # GO-ontology

        require(ontologyIndex)
        require(ontologySimilarity)


        data(go)
        data(gene_GO_terms)


        if(hgnc%in%""){
          go_id<-""
          go_des<-""
        }else{

          look_hgnc <- gene_GO_terms[c(hgnc)]
          go_des<-paste(as.character(go$name[look_hgnc[[1]]]),collapse=";")
          go_id<-paste(as.character(look_hgnc[[1]]),collapse=";")

        }


        table_info<-data.frame(term=gen,hgnc=hgnc,entrez_id=entrez_id,
                               full_name=fulln,
                               gene_type=genety,
                               refseq=refsta,
                               also=aka,
                               info=summa,
                               GO_id=go_id,GO_des=go_des)



      }


      table_info


    }
  }


  if(p==F){

    res_for<-list()
    if(type=="info"){
      dat<-unique(unlist(strsplit(dat$"gene",split=";")))
    }

    for(i in 1:length(dat)){
      res_for[[i]]<-search_gene(dat=dat[i],type)
      svMisc::progress(i,length(dat))
      Sys.sleep(0.02)
      if (i == length(dat)) message("Done!")
    }



    require(plyr)
    res_final<-ldply(res_for)

  }



  else{
    if(type=="info"){
      dat<-unique(unlist(strsplit(dat$"gene",split=";")))
      x_list<-as.list(dat)
    }

    x_list<-as.list(dat)
    require("parallel")
    numWorkers <- detectCores()-1
    cl <- makeCluster(numWorkers)
    inicio_par<-Sys.time()
    res_par<-parLapply(cl,x_list,search_gene,type=type)
    final_par<-Sys.time()
    final_par-inicio_par
    stopCluster(cl)


    require(plyr)
    res_final<-ldply(res_par)



  }


  res_final


}
