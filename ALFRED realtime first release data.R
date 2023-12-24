
library(alfred)
library(dplyr)
library(tidyverse)
library(arsenal)

macro_variables=list("AWHMAN","AWHNONAG","AWOTMAN","CE16OV","CLF16OV"
                     ,"CPIAUCSL","CURRSL","DMANEMP","DSPI","DSPIC96"
                     ,"HOUST","HOUST1F","HOUST2F","INDPRO","M1SL"
                     ,"MANEMP","NDMANEMP","OCDSL","PAYEMS","PCE"
                     ,"PCEC96","PCEDG","PCEDGC96","PCEND","PCENDC96"
                     ,"PCES","PCESC96","PFCGEF","PI","PPICFF","PPICPE"
                     ,"PPICRM","PPIFCF","PPIFGS","PPIIFF","PPIITM"
                     ,"SAVINGSL","SRVPRD","STDCBSL","STDSL","STDTI"
                     ,"SVGCBSL","SVGTI","SVSTCBSL","TCDSL","UEMP15OV"
                     ,"UEMP15T26","UEMP27OV","UEMP5TO14","UEMPLT5"
                     ,"UEMPMEAN","UEMPMED","UNEMPLOY","UNRATE","USCONS"
                     ,"USFIRE","USGOOD","USGOVT","USMINE","USPRIV"
                     ,"USSERV","USTPU","USTRADE","USWTRADE")


masterlist_vari=list("AWHNONAG","AWOTMAN","CE16OV","CLF16OV"
                                ,"CPIAUCSL","CURRSL","DMANEMP","DSPI","DSPIC96"
                                ,"HOUST","HOUST1F","HOUST2F","INDPRO","M1SL"
                                ,"MANEMP","NDMANEMP","OCDSL","PAYEMS","PCE"
                                ,"PCEC96","PCEDG","PCEDGC96","PCEND","PCENDC96"
                                ,"PCES","PCESC96","PFCGEF","PI","PPICFF","PPICPE"
                                ,"PPICRM","PPIFCF","PPIFGS","PPIIFF","PPIITM"
                                ,"SAVINGSL","SRVPRD","STDCBSL","STDSL","STDTI"
                                ,"SVGCBSL","SVGTI","SVSTCBSL","TCDSL","UEMP15OV"
                                ,"UEMP15T26","UEMP27OV","UEMP5TO14","UEMPLT5"
                                ,"UEMPMEAN","UEMPMED","UNEMPLOY","UNRATE","USCONS"
                                ,"USFIRE","USGOOD","USGOVT","USMINE","USPRIV"
                                ,"USSERV","USTPU","USTRADE","USWTRADE")



missing_variables_from_paper=list("CURRDD","DEMDEPSL","M2SL","SVSTSL") 
#Variables in the paper that the get_alfred function cant scrape 
#(after contacting the creator of the library, he said it was a problem with the server, and not much can be done)
#After looking into it more, you CAN pull data from them, but it must be a very restricted time frame, say starting in 1970, you can run the loop again for that if needed.)


vars_in_G_=list("CLF16OV","PCENDC96","PCESC96","PPICFF","SVGCBSL")
#variables prof Fred did not have in his list, (this is more so as a heads up).




#for loop to get and format variables 
for(vari in macro_variables){
  #using "value" as a place holder, it will be renamed to the variable name in the end.
  temp1=get_alfred_series(vari,"value",) 
  
  #Formatting the data, using keeping the first observation/latest of every release date.
  temp2= aggregate(value~realtime_period, temp1, tail, n=1) 
  
  #more formatting, expanding the data to be day-day instead of release day to release day.
  final=data.frame(realtime_period=seq(as.Date("1927-01-24"),as.Date("2022-09-16"),1)) %>% left_join(temp2) %>% fill("value") 
  
  #renaming value to the variable date.
  names(final)[names(final) == 'value'] <- tolower(vari) 
  
  #creating the data frame using the assign function.
  assign(tolower(vari), final)
}




#for loop to combine all the individual data frames 

#creating a new data frame with the first variable name to start the next loop
masterlist=awhman 

#masterlist does not have awhman in the list to not duplicate it
for(vari in masterlist_vari){ 
  
  # unlisting then putting the variables in lowercase to match the data frame names
  fin=tolower(unlist(vari))
  
  # need the get function to be able to tell R call the data frame
  tmp <- get(fin)
  
  # only getting the variables and not the dates.(Merge by realtime period will also work, this is faster though)
  tmp <- tmp[setdiff(names(tmp), "realtime_period")]
  
  # cbind them together. (if columns are different lengths, try merge function by realtime period)
  masterlist<-cbind(masterlist, tmp )
}

#making the CSV
write.csv(masterlist,"masterlist.csv", na = "")







#111 Variables
fredvarlist=list( "W875RX1", "DPCERA3M086SBEA", "CMRMTSPL", "INDPRO", "IPFPNSS",
               "IPFINAL", "IPCONGD", "IPDCONGD", "IPNCONGD", "IPBUSEQ", "IPMAT", "IPDMAT", "IPNMAT", 
               "IPMANSICS", "IPFUELS", "CUMFNS", "CLF16OV", "CE16OV", "UNRATE", "UEMPMEAN", 
               "UEMPLT5", "UEMP5TO14", "UEMP15OV", "UEMP15T26", "UEMP27OV","PAYEMS", "USGOOD", 
               "CES1021000001", "USCONS", "MANEMP", "DMANEMP", "NDMANEMP", "SRVPRD", "USTPU", "USWTRADE",
               "USTRADE", "USFIRE", "USGOVT", "CES0600000007", "AWOTMAN", "AWHMAN", "HOUST", "HOUSTNE",
               "HOUSTMW", "HOUSTS", "HOUSTW", "PERMIT", "PERMITNE", "PERMITMW", "PERMITS", "PERMITW",
               "ACOGNO", "ANDENO", "AMDMUO", "BUSINV", "ISRATIO", "M1SL",
               "M2REAL", "AMBSL", "TOTRESNS", "NONBORRES", "BUSLOANS", "REALLN", "NONREVSL", "FEDFUNDS",
               "TB3MS", "TB6MS", "GS1", "GS5", "GS10", "AAA", "BAA",
               "TB3SMFFM", "TB6SMFFM", "T1YFFM" ,"T5YFFM", "T10YFFM", "AAAFFM", "BAAFFM",
               "TWEXMMTH", "EXSZUS", "EXJPUS", "EXUSUK", "EXCAUS", "PPIFGS", "PPIFCG",
               "PPIITM", "PPICRM", "OILPRICE", "PPICMM", "CPIAUCSL", "CPIAPPSL", "CPITRNSL",
               "CPIMEDSL", "CUSR0000SAC", "CUSR0000SAD", "CUSR0000SAS", "CPIULFSL", "CUSR0000SA0L2",
               "CUSR0000SA0L5", "PCEPI", "DDURRG3M086SBEA", "DNDGRG3M086SBEA", "DSERRG3M086SBEA",
               "CES0600000008", "CES2000000008", "CES3000000008", "UMCSENT", "MZMSL", "DTCOLNVHFNM",
               "DTCTHFNM")

masterlist2_vari=list( "DPCERA3M086SBEA", "CMRMTSPL", "INDPRO", "IPFPNSS",
               "IPFINAL", "IPCONGD", "IPDCONGD", "IPNCONGD", "IPBUSEQ", "IPMAT", "IPDMAT", "IPNMAT", 
               "IPMANSICS", "IPFUELS", "CUMFNS", "CLF16OV", "CE16OV", "UNRATE", "UEMPMEAN", 
               "UEMPLT5", "UEMP5TO14", "UEMP15OV", "UEMP15T26", "UEMP27OV","PAYEMS", "USGOOD", 
               "CES1021000001", "USCONS", "MANEMP", "DMANEMP", "NDMANEMP", "SRVPRD", "USTPU", "USWTRADE",
               "USTRADE", "USFIRE", "USGOVT", "CES0600000007", "AWOTMAN", "AWHMAN", "HOUST", "HOUSTNE",
               "HOUSTMW", "HOUSTS", "HOUSTW", "PERMIT", "PERMITNE", "PERMITMW", "PERMITS", "PERMITW",
               "ACOGNO", "ANDENO", "AMDMUO", "BUSINV", "ISRATIO", "M1SL",
               "M2REAL", "AMBSL", "TOTRESNS", "NONBORRES", "BUSLOANS", "REALLN", "NONREVSL", "FEDFUNDS",
               "TB3MS", "TB6MS", "GS1", "GS5", "GS10", "AAA", "BAA",
               "TB3SMFFM", "TB6SMFFM", "T1YFFM" ,"T5YFFM", "T10YFFM", "AAAFFM", "BAAFFM",
               "TWEXMMTH", "EXSZUS", "EXJPUS", "EXUSUK", "EXCAUS", "PPIFGS", "PPIFCG",
               "PPIITM", "PPICRM", "OILPRICE", "PPICMM", "CPIAUCSL", "CPIAPPSL", "CPITRNSL",
               "CPIMEDSL", "CUSR0000SAC", "CUSR0000SAD", "CUSR0000SAS", "CPIULFSL", "CUSR0000SA0L2",
               "CUSR0000SA0L5", "PCEPI", "DDURRG3M086SBEA", "DNDGRG3M086SBEA", "DSERRG3M086SBEA",
               "CES0600000008", "CES2000000008", "CES3000000008", "UMCSENT", "MZMSL", "DTCOLNVHFNM",
               "DTCTHFNM")
for(vari in fredvarlist){
  temp1=get_alfred_series(vari,"value",) 
  temp2= aggregate(value~realtime_period, temp1, tail, n=1) 
  final=data.frame(realtime_period=seq(as.Date("1927-01-24"),as.Date("2022-09-16"),1)) %>% left_join(temp2) %>% fill("value") 
  names(final)[names(final) == 'value'] <- tolower(vari)
  assign(tolower(vari), final) 
}

masterlist2=w875rx1 
for(vari in masterlist2_vari){
  fin=tolower(unlist(vari))
  tmp <- get(fin)
  tmp <- tmp[setdiff(names(tmp), "realtime_period")]
  masterlist2<-cbind(masterlist2, tmp ) 
}


write.csv(masterlist2, "masterlist2.csv", na="")








