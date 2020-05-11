library(tidyverse);library(magrittr);library(RSQLite);library(stringr);library(h2o);library(caroline);library(lubridate);library(rvest);library(readr)
library(quantmod);library(caroline);library(tidyverse) ; library(httr) ; library(jsonlite)
library(BatchGetSymbols)
library(tidyverse) ; library(httr) ; library(jsonlite);library(anytime)


fill_above <- function(x) 
{for(i in seq_along(x)[-1]) if(is.na(x[i])) x[i] <- x[i-1] 
x}


con = dbConnect(SQLite(), "FINANCIAL_METRICS.sqlite")
crypto_sent =  dbGetQuery(con, "SELECT timestamp,value 
                          FROM CRYPTO_SENT")  
  
stocks_t = dbGetQuery(con, "SELECT * FROM STOCK_PRICES WHERE ticker = 'BTC-USD' OR ticker = 'ETH-USD' OR ticker = 'XRP-USD'")
stocks_t = dbGetQuery(con, "SELECT * FROM STOCK_PRICES WHERE ticker = 'BTC-USD'")

stocks = stocks_t %>% left_join(crypto_sent, by = c("ref.date" = "timestamp") ) %>%
  na.omit() %>% select(ticker, ref.date, price.open, price.close, value ) %>% mutate(value = as.numeric(value), rowIndex = 1:length(ticker)) 

drop = 36;multi = 3;buying_lots = 2000; sentiments = 1:100

buy_approach = round(ifelse( (drop - sentiments)/sentiments < -1, -1,(drop - sentiments)/sentiments *multi ),3)
buy_df = data.frame(sentiments = sentiments,buy_approach = buy_approach); buy_df$buy_approach = ifelse(buy_df$buy_approach == 0, 0.01,buy_df$buy_approach)
buy_df$buy_approach = ifelse(buy_df$buy_approach < -1, -1,buy_df$buy_approach) 

stocks$position = buy_df$buy_approach[match(stocks$value, buy_df$sentiments)]

stocks$init_units_t = round(ifelse(stocks$rowIndex == 1 & stocks$position < 0, 0,
                    ifelse(stocks$position > 0, stocks$position * buying_lots /stocks$price.close,
                    ifelse(stocks$rowIndex == -1, 0, -100) ) ),4)

stocks$test = ifelse(stocks$rowIndex == 1, stocks$init_units_t, 
                ifelse(stocks$init_units_t > 0 & lag(stocks$init_units_t,1) > 0,lag(stocks$init_units_t,1) +stocks$init_units_t,  
                ifelse(stocks$position < -1  & lag(stocks$position,1) == -1, 0, 
                       ifelse(stocks$position == 0 ,lag(stocks$position,1), 
                       ifelse(stocks$position > 0 & lag(stocks$position,1) == -1,stocks$position,
                        ifelse(stocks$position < 0  & stocks$position != -1, 10,0 
                        ) ) ) ) ) )  


stocks$groups = ifelse(stocks$position < 0, stocks$rowIndex, NA)  
stocks_t = stocks %>% fill(groups, .direction = "up") %>% split(.$groups )

for(i in 1:length(stocks_t)) {
  reduction = stocks_t[[i]]$position[which(stocks_t[[i]]$position < 0)]
  stocks_t[[i]]$rolling_position = ifelse(stocks_t[[i]]$init_units_t >= 0, cumsum(stocks_t[[i]]$init_units_t),
                                   ifelse(stocks_t[[i]]$position < 0  & stocks_t[[i]]$position != -1,lag(cumsum(stocks_t[[i]]$init_units_t), 1) + lag(cumsum(stocks_t[[i]]$init_units_t), 1) * stocks_t[[i]]$position, 
                                   ifelse(stocks_t[[i]]$position == 0, 999,
                                   ifelse(stocks_t[[i]]$position == -1, 0,       
                                                 0) ) ) )
      } 
stocks_t2 = bind_rows(stocks_t)
stocks_t2$rolling_position = ifelse(stocks_t2$position == -1 & lag(stocks_t2$rolling_position, 1) > 0, -1 * lag(stocks_t2$rolling_position,1), stocks_t2$rolling_position )

stock_groups = sort(unique(stocks_t2$groups))
group_min = min(stock_groups)
stocks_t2$actual_position = ### Essential ###
                            ifelse(stocks_t2$rowIndex == 1, stocks_t2$init_units_t,
                            ifelse(stocks_t2$groups == min(stocks_t2$groups) & stocks_t2$position > 0, lag(stocks_t2$rolling_position,1) + stocks_t2$init_units_t, 
                            ifelse(stocks_t2$groups == min(stocks_t2$groups) & stocks_t2$position < 0, lag(stocks_t2$rolling_position,1) + lag(stocks_t2$rolling_position,1) * stocks_t2$position,   
                            ifelse(lag(stocks_t2$position,1) == stocks_t2$position & stocks_t2$position ==  -1 , 0,
                            ifelse(lag(stocks_t2$position,1) == -1 & stocks_t2$position < 0 , 0,  
                            ifelse(stocks_t2$groups == stock_groups[2] & stocks_t2$position < 0 & stocks_t2$groups != lag(stocks_t2$groups,1), lag(stocks_t2$rolling_position,1) + (lag(stocks_t2$rolling_position,1) * stocks_t2$position ),
                            ifelse(stocks_t2$groups == stock_groups[2] & stocks_t2$position > 0 & stocks_t2$groups != lag(stocks_t2$groups,1), lag(stocks_t2$rolling_position,1) +  stocks_t2$init_units_t,  
                            ifelse(lag(stocks_t2$position,1) == -1 & stocks_t2$position < 0, 0, 
                            ifelse(lag(stocks_t2$position,2) == -1 & lag(stocks_t2$position,1) < 0 & stocks_t2$position < 0, 0, 
                            ifelse(lag(stocks_t2$position,3) == -1.000 & lag(stocks_t2$position,2) < 0 & lag(stocks_t2$position,1) < 0 & stocks_t2$position > 0, stocks$init_units_t,
                            ifelse(stocks_t2$position > 0 & stocks_t2$groups == lag(stocks_t2$groups,1),  stocks_t2$init_units_t + lag(stocks_t2$actual_position,1), 
                            ifelse(stocks_t2$position < 0 & stocks_t2$groups == lag(stocks_t2$groups,1),  lag(stocks_t2$actual_position,1) + (stocks_t2$position * lag(stocks_t2$actual_position,1)),       
                            ifelse(is.na(stocks_t2$rolling_position) & stocks_t2$position < 0, lag(stocks_t2$rolling_position,1) + lag(stocks_t2$rolling_position,1) * stocks_t2$position, 
                            ifelse(lag(stocks_t2$position, 1) == -1 & stocks_t2$position < 0, 0,
                            ifelse(lag(stocks_t2$position, 1) < 0 & stocks_t2$position == -1, 0,                              
                                              NA )))))))))))))))

# Need to rerun this over and over

  while(sum(is.na(stocks_t2$actual_position)) > 520){
  stocks_t2$actual_position = ifelse(lag(stocks_t2$actual_position,1) == 0 & stocks_t2$position < 0 & is.na(stocks_t2$actual_position), 0,
                            ifelse(lag(stocks_t2$actual_position,1) == 0 & stocks_t2$position > 0 & is.na(stocks_t2$actual_position), stocks_t2$init_units_t,
                              stocks_t2$actual_position
                                                        ))
    }

while(sum(is.na(stocks_t2$actual_position)) > 0){
    stocks_t2$actual_position = ifelse(is.na(stocks_t2$actual_position) & !is.na(lag(stocks_t2$actual_position,1)) &  stocks_t2$position > 0, stocks_t2$init_units_t +  lag(stocks_t2$actual_position,1),
                            ifelse(is.na(stocks_t2$actual_position) & !is.na(lag(stocks_t2$actual_position,1)) &  stocks_t2$position < 0, lag(stocks_t2$actual_position,1) + (stocks_t2$position *  lag(stocks_t2$actual_position,1)),  
                              stocks_t2$actual_position
                                  ))
          }

