library(tidyverse);library(magrittr);library(RSQLite);library(stringr);library(h2o);library(caroline);library(lubridate);library(rvest);library(readr)
library(quantmod);library(caroline)
library(BatchGetSymbols)

con = dbConnect(SQLite(), "FINANCIAL_METRICS.sqlite")

stocks_output =  dbGetQuery(con, "SELECT * FROM STOCK_PRICES")
stocks_output_t = stocks_output %>%  mutate(ref.date = as.Date(ref.date)) %>% select(ticker, ret.closing.prices, ref.date)
stocks = test %>% spread(ticker, ret.closing.prices)




x = spread( stocks_output, tickers,-ret.closing.prices) 

y = round(cor(stocks[, 2:100], use = "complete.obs"),4)










