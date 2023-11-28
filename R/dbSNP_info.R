
dbSNP_info<-function (dat = NULL, type = c("pos", "rs"), p = F, build = 37,
                      r2 = 0.99, pop = "EUR")
{
  x <- dat[1]
  if (is.null(x) == T || is.null(type) == T) {
    stop("ERROR: INTRODUCE dat AND type TERMS")
  }
  else {
    snp_info <- function(dat, build, type, r2, pop) {
      dat <- as.data.frame(dat, stringsAsFactors =F)
      if (type == "pos") {
        if (length(grep(":", dat[1, ])) == 0) {
          stop("ERROR: INTRODUCE THE POSITION DATA SEPARATE WITH : AND WITHOUT CHR")
        }
        else {
          if (length(grep("chr", dat[1, ])) > 0) {
            dat[1, ] <- gsub("chr", "", dat[1, ])
          }
          tp <- unlist(strsplit(dat[1, ], split = ":"))
          url_check <- paste0("https://www.ncbi.nlm.nih.gov/snp/?term=",
                              tp[1], "%3A", tp[2])
        }
      }
      else if (length(grep("rs", dat[1, ])) == 0) {
        stop("ERROR: INTRODUCE THE SNP NAME WITH rs")
      }
      else {
        url_check <- paste0("https://www.ncbi.nlm.nih.gov/snp/?term=",
                            dat[1, ])
      }
      inicio <- Sys.time()
      thepage = try(readLines(url_check, warn = F), silent = T)
      tiempo <- as.numeric(difftime(Sys.time(), inicio,
                                    units = "secs"))
      while (class(thepage) == "try-error" & tiempo <=
             10) {
        rm(tiempo)
        thepage = try(readLines(url_check, warn = F),
                      silent = T)
        tiempo <- as.numeric(difftime(Sys.time(), inicio,
                                      units = "secs"))
      }
      if (class(thepage) == "try-error") {
        thepage = "NO RESULT"
      }
      if (class(thepage) != "try-error") {
        check <- length(grep("message = 'No results'",
                             thepage))
        if (check > 0) {
          thepage = "NO RESULT"
        }
      }
      thepage
      info <- thepage
      if (length(info) == 1) {
        table_info <- data.frame(term = dat[1, ], rsID = "",
                                 gene = "", func = "", GRCh37 = "", GRCh38 = "",
                                 rs_ld = "", stringsAsFactors =F)
        table_info
      }
      else {
        if (length(info) > 1) {
          snps_number <- length(info[grep("ncbi_uid=",
                                          info)])
          if (snps_number > 1) {
            res_snps <- list()
            for (i in 1:snps_number) {
              rs <- paste0("rs", unlist(strsplit(unlist(strsplit(info[grep("ncbi_uid=",
                                                                           info)][i], split = "ncbi_uid="))[2],
                                                 split = "&amp;link_uid"))[1])
              if (length(grep("MT", dat[1, ])) > 0) {
                gene <- try(unlist(strsplit(strsplit(info[grep("Gene:",
                                                               info)][i], split = "Gene:</dt><dd><span class=\"snpsum_hgvs\">")[[1]][2],
                                            split = "<span class=\"highlight\" style=\"background-color:\">")))
                if (class(gene) != "try-error") {
                  gene <- gene[grep("MT", gene)]
                  gene <- unlist(strsplit(gene, split = "</span>-"))
                  gene <- gene[-grep("MT", gene)]
                  gene <- unlist(strsplit(gene, split = "[(]"))
                  gene <- gene[-grep("<a href=", gene)]
                  gene <- gsub(" ", "", paste0("MT-",
                                               gene))
                }
                if (class(gene) == "try-error") {
                  gene <- ""
                }
              }
              else {
                gene <- try(unlist(strsplit(strsplit(info[grep("Gene:",
                                                               info)][i], split = "Gene:</dt><dd><span class=\"snpsum_hgvs\">")[[1]][2],
                                            split = " [(]")), silent = T)
                if (class(gene) != "try-error") {
                  gene <- unlist(strsplit(gene, split = " "))
                  gene <- gene[-grep("href", gene)]
                  gene <- gene[-grep("<a", gene)]
                }
                if (class(gene) == "try-error") {
                  gene <- ""
                }
              }
              check0 <- unlist(strsplit(info[grep("GRCh38",
                                                  info)][i], split = "style=\"background-color:\">"))
              if (length(check0) == 1) {
                chr_pos_37 <- unlist(strsplit(check0,
                                              split = "/>"))[2]
              }
              if (length(check0) == 2) {
                check1 <- unlist(strsplit(check0[length(check0)],
                                          split = "</span>:"))[1]
                check2 <- unlist(strsplit(check0[length(check0)],
                                          split = "</span>:"))[2]
                chr_pos_37 <- paste0(check1, ":", check2)
              }
              if (length(check0) > 2) {
                check1 <- unlist(strsplit(check0[length(check0) -
                                                   1], split = "</span>:"))[1]
                check2 <- unlist(strsplit(check0[length(check0)],
                                          split = "</span>"))
                chr_pos_37 <- paste0(check1, ":", check2)
              }
              check3 <- unlist(strsplit(info[grep("Chromosome:",
                                                  info)][i], split = "style=\"background-color:\">"))
              if (length(check3) == 1) {
                chr_pos_38 <- unlist(strsplit(info[grep("Chromosome:",
                                                        info)][i], split = "<dd>"))[2]
              }
              if (length(check3) > 2) {
                chr_pos_38 <- check3[length(check3)]
                chr_pos_38 <- gsub("</span>", "", chr_pos_38)
                chr_pos_38 <- paste0(check1, ":", chr_pos_38)
              }
              if (length(check3) == 2) {
                chr_pos_38 <- unlist(strsplit(info[grep("Chromosome:",
                                                        info)][i], split = "style=\"background-color:\">"))[2]
                chr_pos_38 <- gsub("</span>", "", chr_pos_38)
              }
              check_functional <- info[grep("Functional Consequence",
                                            info)][i]
              functional <- grep("intergenic", tolower(check_functional))
              functional <- ifelse(length(functional) ==
                                     0, 1, 0)
              res_snps[[i]] <- data.frame(rsID = rs,
                                          gene = paste(gene, collapse = ";"), func = functional,
                                          GRCh37 = chr_pos_37, GRCh38 = chr_pos_38, stringsAsFactors =F)
              rm(check3, rs, gene, chr_pos_37, chr_pos_38)
            }
            table_info <- plyr::ldply(res_snps)
            rm(res_snps)
          }
          if (snps_number == 1) {
            rs <- paste0("rs", unlist(strsplit(unlist(strsplit(info[grep("ncbi_uid=",
                                                                         info)], split = "ncbi_uid="))[2], split = "&amp;link_uid"))[1])
            gene <- try(unlist(strsplit(strsplit(info[grep("Gene:",
                                                           info)], split = "Gene:</dt><dd><span class=\"snpsum_hgvs\">")[[1]][2],
                                        split = " [(]")), silent = T)
            if (class(gene) != "try-error") {
              gene <- unlist(strsplit(gene, split = " "))
              gene <- gene[-grep("href", gene)]
              gene <- gene[-grep("<a", gene)]
            }
            if (class(gene) == "try-error") {
              gene <- ""
            }
            check0 <- unlist(strsplit(info[grep("GRCh38",
                                                info)], split = "style=\"background-color:\">"))
            if (length(check0) == 1) {
              chr_pos_37 <- unlist(strsplit(check0, split = "/>"))[2]
            }
            if (length(check0) == 2) {
              check1 <- unlist(strsplit(check0[length(check0)],
                                        split = "</span>:"))[1]
              check2 <- unlist(strsplit(check0[length(check0)],
                                        split = "</span>:"))[2]
              chr_pos_37 <- paste0(check1, ":", check2)
            }
            if (length(check0) > 2) {
              check1 <- unlist(strsplit(check0[length(check0) -
                                                 1], split = "</span>:"))[1]
              check2 <- unlist(strsplit(check0[length(check0)],
                                        split = "</span>"))
              chr_pos_37 <- paste0(check1, ":", check2)
            }
            check3 <- unlist(strsplit(info[grep("Chromosome:",
                                                info)], split = "style=\"background-color:\">"))
            if (length(check3) == 1) {
              chr_pos_38 <- unlist(strsplit(info[grep("Chromosome:",
                                                      info)], split = "<dd>"))[2]
            }
            if (length(check3) > 2) {
              chr_pos_38 <- check3[length(check3)]
              chr_pos_38 <- gsub("</span>", "", chr_pos_38)
              chr_pos_38 <- paste0(check1, ":", chr_pos_38)
            }
            if (length(check3) == 2) {
              chr_pos_38 <- unlist(strsplit(info[grep("Chromosome:",
                                                      info)], split = "style=\"background-color:\">"))[2]
              chr_pos_38 <- gsub("</span>", "", chr_pos_38)
            }
            check_functional <- info[grep("Functional Consequence",
                                          info)]
            functional <- grep("intergenic", tolower(check_functional))
            functional <- ifelse(length(functional) ==
                                   0, 1, 0)
            table_info <- data.frame(rsID = rs, gene = paste(gene,
                                                             collapse = ";"), func = functional, GRCh37 = chr_pos_37,
                                     GRCh38 = chr_pos_38, stringsAsFactors =F)
            rm(check3, chr_pos_37, chr_pos_38)
          }
        }
        table_info
        check <- dat[1, ]
        if (type == "pos" & build == 37) {
          table_info <- table_info[which(table_info$GRCh37 %in%
                                           check), ]
          if (length(setdiff(table_info$GRCh38, table_info$GRCh38[1])) ==
              0) {
            pos38 <- table_info$GRCh38[1]
          }
          else {
            vec <- setdiff(table_info$GRCh38, table_info$GRCh38[1])
            pos38 <- paste(table_info$GRCh38[1], paste(vec,
                                                       collapse = ";"), sep = ";")
          }
          if (length(setdiff(table_info$func, table_info$func[1])) ==
              0) {
            func2 <- table_info$func[1]
          }
          else {
            vec <- setdiff(table_info$func, table_info$func[1])
            func2 <- paste(table_info$func[1], paste(vec,
                                                     collapse = ";"), sep = ";")
          }
          if (length(setdiff(table_info$gene, table_info$gene[1])) ==
              0) {
            gene2 <- table_info$gene[1]
          }
          else {
            vec <- setdiff(table_info$gene, table_info$gene[1])
            gene2 <- paste(table_info$gene[1], paste(vec,
                                                     collapse = ";"), sep = ";")
          }
          if (length(setdiff(table_info$rsID, table_info$rsID[1])) ==
              0) {
            snp2 <- table_info$rsID[1]
          }
          else {
            vec <- setdiff(table_info$rsID, table_info$rsID[1])
            snp2 <- paste(table_info$rsID[1], paste(vec,
                                                    collapse = ";"), sep = ";")
          }
          table_info <- data.frame(term = check, rsID = snp2,
                                   gene = gene2, func = func2, GRCh37 = check,
                                   GRCh38 = pos38, stringsAsFactors =F)
        }
        else {
          if (type == "pos" & build == 38) {
            table_info <- table_info[which(table_info$GRCh38 %in%
                                             check), ]
            if (length(setdiff(table_info$GRCh37, table_info$GRCh37[1])) ==
                0) {
              pos37 <- table_info$GRCh37[1]
            }
            else {
              vec <- setdiff(table_info$GRCh37, table_info$GRCh37[1])
              pos37 <- paste(table_info$GRCh37[1], paste(vec,
                                                         collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$func, table_info$func[1])) ==
                0) {
              func2 <- table_info$func[1]
            }
            else {
              vec <- setdiff(table_info$func, table_info$func[1])
              func2 <- paste(table_info$func[1], paste(vec,
                                                       collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$gene, table_info$gene[1])) ==
                0) {
              gene2 <- table_info$gene[1]
            }
            else {
              vec <- setdiff(table_info$gene, table_info$gene[1])
              gene2 <- paste(table_info$gene[1], paste(vec,
                                                       collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$rsID, table_info$rsID[1])) ==
                0) {
              snp2 <- table_info$rsID[1]
            }
            else {
              vec <- setdiff(table_info$rsID, table_info$rsID[1])
              snp2 <- paste(table_info$rsID[1], paste(vec,
                                                      collapse = ";"), sep = ";")
            }
            table_info <- data.frame(term = check, rsID = snp2,
                                     gene = gene2, func = func2, GRCh37 = pos37,
                                     GRCh38 = check, stringsAsFactors =F)
          }
          else {
            if (length(setdiff(table_info$GRCh37, table_info$GRCh37[1])) ==
                0) {
              pos37 <- table_info$GRCh37[1]
            }
            else {
              vec <- setdiff(table_info$GRCh37, table_info$GRCh37[1])
              pos37 <- paste(table_info$GRCh37[1], paste(vec,
                                                         collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$func, table_info$func[1])) ==
                0) {
              func2 <- table_info$func[1]
            }
            else {
              vec <- setdiff(table_info$func, table_info$func[1])
              func2 <- paste(table_info$func[1], paste(vec,
                                                       collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$gene, table_info$gene[1])) ==
                0) {
              gene2 <- table_info$gene[1]
            }
            else {
              vec <- setdiff(table_info$gene, table_info$gene[1])
              gene2 <- paste(table_info$gene[1], paste(vec,
                                                       collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$GRCh38, table_info$GRCh38[1])) ==
                0) {
              pos38 <- table_info$GRCh38[1]
            }
            else {
              vec <- setdiff(table_info$GRCh38, table_info$GRCh38[1])
              pos38 <- paste(table_info$GRCh38[1], paste(vec,
                                                         collapse = ";"), sep = ";")
            }
            if (length(setdiff(table_info$rsID, table_info$rsID[1])) ==
                0) {
              snp2 <- table_info$rsID[1]
            }
            else {
              vec <- setdiff(table_info$rsID, table_info$rsID[1])
              snp2 <- paste(table_info$rsID[1], paste(vec,
                                                      collapse = ";"), sep = ";")
            }
            table_info <- data.frame(term = check, rsID = snp2,
                                     gene = gene2, func = func2, GRCh37 = pos37,
                                     GRCh38 = pos38, stringsAsFactors =F)
          }
        }
        table_info
        if (type == "pos") {
          snps_search <- table_info$rsID
        }
        else {
          snps_search <- table_info$term
        }
        check <- unlist(strsplit(snps_search, split = ";"))
        ld_search <- function(snp, r2, pop) {
          require(httr)
          require(jsonlite)
          require(xml2)
          ensembl_get <- try(GET(paste("https://rest.ensembl.org/ld/human/",
                                       snp, "/1000GENOMES:phase_3:", pop, sep = ""),
                                 content_type("application/json")))

          status_time0<-Sys.time()
          if(ensembl_get$status_code != 200){

            while (ensembl_get$status_code != 200 | difftime(Sys.time(),status_time0,units="secs")<=10){

              ensembl_get <- try(GET(paste("https://rest.ensembl.org/ld/human/",
                                           snp, "/1000GENOMES:phase_3:", pop, sep = ""),
                                     content_type("application/json")))

            }
          }
          if(ensembl_get$status_code != 200) {
            rs_ld <- http_status(ensembl_get$status_code)$"category"
          }

          if(ensembl_get$status_code == 200){
            stop_for_status(ensembl_get)
            table_ld <- fromJSON(toJSON(content(ensembl_get)))
            rs_ld <- unlist(table_ld$variation2[table_ld$r2 >=
                                                  r2])
            rs_ld

          }


        }
        res <- sapply(1:length(check), function(i) ld_search(snp = check[i],
                                                             r2 = r2, pop = pop))
        res_new <- paste(unique(unlist(res)), collapse = ";")
        table_info$rs_ld <- res_new
        table_info
      }
    }
  }
  if (p == F) {
    res_for <- list()
    dat <- c(dat)
    for (i in 1:length(dat)) {
      res_for[[i]] <- snp_info(dat = dat[i], build, type,
                               r2, pop)
      svMisc::progress(i, max.value = length(dat))
      Sys.sleep(0.02)
      if (i == length(dat))
        message("Done!")
    }
    require(plyr)
    res_final <- ldply(res_for)
  }
  else {
    x_list <- as.list(dat)
    require("parallel")
    numWorkers <- detectCores() - 1
    cl <- makeCluster(numWorkers)
    inicio_par <- Sys.time()
    res_par <- parLapply(cl, x_list, snp_info, build = build,
                         type = type, r2 = r2, pop = pop)
    final_par <- Sys.time()
    final_par - inicio_par
    stopCluster(cl)
    require(plyr)
    res_final <- ldply(res_par)
  }
  res_final
}



