library(tidyverse);library(magrittr);library(RSQLite);library(stringr);library(h2o);library(caroline);library(lubridate);library(rvest);library(readr)
library(quantmod);library(caroline)
library(BatchGetSymbols)

yahooQF()

Symbols<-c("ABP.AX","AX1.AX","ABC.AX","APT.AX","AGL.AX","AQG.AX","ALQ.AX","ALU.AX","AWC.AX","AMA.AX","AYS.AX","AMC.AX","AMP.AX","ANN.AX","APE.AX","APA.AX","ADI.AX","APX.AX","ARB.AX","ALG.AX","ARF.AX","ALL.AX","AHY.AX","ASX.AX","ALX.AX","AUB.AX","AIA.AX","AD8.AX","AMI.AX","AZJ.AX","AST.AX","ASB.AX","ANZ.AX","AAC.AX","API.AX","AVN.AX","AVH.AX","BBN.AX","BOQ.AX","BAP.AX","BPT.AX","BGA.AX","BGL.AX","BEN.AX","BHP.AX","BIN.AX","BKL.AX","BSL.AX","BLD.AX","BXB.AX","BVS.AX","BRG.AX","BKW.AX","BUB.AX","BWP.AX","BWX.AX","CTX.AX","CDD.AX","CVN.AX","CAR.AX","CWP.AX","CNI.AX","CIP.AX","COF.AX","CGF.AX","CIA.AX","CHC.AX","CLW.AX","CQR.AX","CQE.AX","CNU.AX","CIM.AX","CWY.AX","CUV.AX","CCL.AX","COH.AX","CDA.AX","COL.AX","CKF.AX","CBA.AX","CPU.AX","COE.AX","CTD.AX","CGC.AX","CCP.AX","CMW.AX","CWN.AX","CSL.AX","CSR.AX","DCN.AX","DTL.AX","DXS.AX","DHG.AX","DMP.AX","DOW.AX","ECX.AX","ELD.AX","EHL.AX","EML.AX","EHE.AX","A2M.AX","EVN.AX","FAR.AX","FBU.AX","FLT.AX","FMG.AX","FNP.AX","FPH.AX","FXL.AX","GDI.AX","GEM.AX","GMA.AX","GMG.AX","GNC.AX","GOR.AX","GOZ.AX","GPT.AX","GUD.AX","GWA.AX","GXY.AX","HLS.AX","HPI.AX","HSN.AX","HT1.AX","HUB.AX","HVN.AX","IAG.AX","IAP.AX","IEL.AX","IFL.AX","IFM.AX","IFN.AX","IGL.AX","IGO.AX","ILU.AX","IMD.AX","IMF.AX","INA.AX","ING.AX","INR.AX","IPH.AX","IPL.AX","IRE.AX","IRI.AX","ISX.AX","ITG.AX","IVC.AX","JBH.AX","JHC.AX","JHG.AX","JHX.AX","JIN.AX","JMS.AX","KAR.AX","KGN.AX","LIC.AX","LLC.AX","LNK.AX","LOV.AX","LYC.AX","MAH.AX","MFG.AX","MGR.AX","MGX.AX","MIN.AX","MLD.AX","MMS.AX","MND.AX","MNY.AX","MP1.AX","MPL.AX","MQG.AX","MSB.AX","MTS.AX","MVF.AX","MYR.AX","MYS.AX","MYX.AX","NAB.AX","NAN.AX","NCK.AX","NCM.AX","NCZ.AX","NEA.AX","NEC.AX","NGI.AX","NHC.AX","NHF.AX","NIC.AX","NSR.AX","NST.AX","NUF.AX","NWH.AX","NWL.AX","NWS.AX","NXT.AX","OFX.AX","OGC.AX","OML.AX","ORA.AX","ORE.AX","ORG.AX","ORI.AX","OSH.AX","OZL.AX","PDL.AX","PDN.AX","PET.AX","PGH.AX","PLS.AX","PME.AX","PMV.AX","PNI.AX","PNV.AX","PPT.AX","PRN.AX","PRU.AX","PTM.AX","QAN.AX","QBE.AX","QUB.AX","RDC.AX","REA.AX","REG.AX","RFF.AX","RHC.AX","RIO.AX","RMD.AX","RMS.AX","RRL.AX","RSG.AX","RWC.AX","S32.AX","SAR.AX","SBM.AX","SCG.AX","SCP.AX","SDA.AX","SDF.AX","SEK.AX","SFR.AX","SGF.AX","SGM.AX","SGP.AX","SGR.AX","SHL.AX","SHV.AX","SIG.AX","SIQ.AX","SKC.AX","SKI.AX","SLC.AX","SLR.AX","SM1.AX","SOL.AX","SPK.AX","SPL.AX","SSM.AX","STO.AX","SUL.AX","SUN.AX","SVW.AX","SWM.AX","SXL.AX","SXY.AX","SYD.AX","SYR.AX","TAH.AX","TCL.AX","TGR.AX","TLS.AX","TNE.AX","TPM.AX","TWE.AX","UMG.AX","URW.AX","VCX.AX","VEA.AX","VOC.AX","VRL.AX","VRT.AX","VUK.AX","VVR.AX","WAF.AX","WBC.AX","WEB.AX","WES.AX","WGX.AX","WHC.AX","WOR.AX","WOW.AX","WPL.AX","WPP.AX","WSA.AX","WTC.AX","XRO.AX","Z1P.AX","FOUR.L","888.L","ASL.L","ADM.L","AGK.L","AAF.L","AJB.L","ATST.L","AAL.L","ANTO.L","APAX.L","ASCL.L","ASHM.L","AHT.L","ABF.L","AGR.L","AML.L","AZN.L","AUTO.L","AVST.L","AVV.L","AGT.L","BME.L","BAB.L","BGFD.L","BAKK.L","BBY.L","BGEO.L","BNKR.L","BARC.L","LLOY.L","BT-A.L","AV.L", "HL.L","STAN.L","TSCO.L", "CCH.L", "VOD.L", "RB.L", "BA.L", "RDSA.L", "MGGT.L", "RTO.L"
           ,"CSCO","CAT","VZ","JNJ","WMT","V","KO","MRK","HD","MMM","IBM","RTX","PG","MCD","WBA","PFE","TRV","XOM","GS","NKE","UNH","JPM","MSFT","AAPL","BA","CVX","AXP","DIS","INTC","DOW",
           "STU.NZ","TWR.NZ","GMT.NZ","WHS.NZ","VHP.NZ","PFI.NZ","MEL.NZ","CEN.NZ","MCY.NZ","AIR.NZ","SCL.NZ","SML.NZ","POT.NZ","SPG.NZ","SUM.NZ","ARG.NZ","HBL.NZ","VGL.NZ","NZR.NZ","ARV.NZ","RYM.NZ","SKT.NZ","MPG.NZ","SPK.NZ","PEB.NZ","FPH.NZ",
           "ETH-USD", "BTC-USD", "XRP-USD","^FTSE", "IOZ.AX", "^DJI","EXS1.DE")

what_metrics <- yahooQF(c("Last Trade (Price Only)","Price/Sales", "P/E Ratio","Price/EPS Estimate Next Year","Earnings/Share",
                          "PEG Ratio","Dividend Yield", "Market Capitalization","Book Value","Currency","Price/Book","EPS Forward","Dividend/Share"
))

metrics <- getQuote(paste(Symbols, sep="", collapse=";"), what=what_metrics) 

metrics$`Trade Time` = as.character(metrics$`Trade Time`)
metrics$symbol = Symbols


con = dbConnect(SQLite(), "FINANCIAL_METRICS.sqlite")
dbRemoveTable(con, "FIN_METRICS")

db_check = try(dbGetQuery(con, "SELECT * FROM FIN_METRICS"),silent = TRUE)
if(class(db_check) == "try-error"){
  dbWriteTable(con, "FIN_METRICS", metrics,overwrite = T)
}
if(class(db_check) != "try-error"){
  dbWriteTable(con, "FIN_METRICS", metrics,append = T)      
}
db_clean = try(dbGetQuery(con, "SELECT * FROM FIN_METRICS"),silent = TRUE)

all_records_temp =  dbGetQuery(con, "SELECT * FROM FIN_METRICS")
write.delim(all_records_temp, "all_records_temp.txt", sep = "|")

last_refresh = as.Date("2020/05/07", format = "%Y/%m/%d")
first.date <- last_refresh;last.date = Sys.Date()
freq.data <- 'daily';tickers <- Symbols
stock_prices <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') ) # cache in tempdir()

stocks = stock_prices$df.tickers
stocks$ref.date = as.character(stocks$ref.date)
db_check = try(dbGetQuery(con, "SELECT * FROM STOCK_PRICES"),silent = TRUE)
if(class(db_check) == "try-error"){
  dbWriteTable(con, "STOCK_PRICES", stocks,overwrite = T)
  }
if(class(db_check) != "try-error"){
  dbWriteTable(con, "STOCK_PRICES", stocks,append = T)
  }
db_clean = try(dbGetQuery(con, "SELECT * FROM STOCK_PRICES"),silent = TRUE)

stocks_output =  dbGetQuery(con, "SELECT * FROM STOCK_PRICES")
write.delim(stocks_output, "stocks_output.txt", sep = "|")


