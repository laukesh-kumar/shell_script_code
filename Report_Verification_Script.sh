#!/bin/bash

# Set your database credentials
DB_HOST="ziiki-media-sandbox.chsm95yoqpj0.eu-west-1.rds.amazonaws.com"
DB_USER="L1ops"
DB_PASSWORD="L!(0w"
DB_NAME="CMS"

# Function to execute SQL query and get result
execute_query() {
  QUERY="$1"
  RESULT=$(mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD -D$DB_NAME -se "$QUERY")
  echo "$RESULT"
}

# Function to round floating-point numbers
round_number() {
  NUMBER=$1
  DECIMALS=$2
  printf "%.${DECIMALS}f" $NUMBER
}

# Function to check UDR status
check_udr_status() {
  UDR_ID="$1"

  # Count
  UDR_RAW_TP_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionThirdPartyRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_YT_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionYouTubeRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_ADA_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionAdaRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_WASAFI_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionWasafiRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_YT_TRANS_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionYoutubeTransactionRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_BELIVE_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionBeliveDigitalRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")

  UDR_FORMATTED_TP_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionThirdPartyFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_YT_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionYouTubeFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_ADA_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionAdaFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_WASAFI_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionWasafiFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_BELIVE_COUNT=$(execute_query "SELECT COUNT(1) FROM UdrTransactionBeliveDigitalFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")

  UDR_MAIN_TP_COUNT=$(execute_query "SELECT COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID")

  # Gross Sale Price
  UDR_RAW_TP_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionThirdPartyRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_YT_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.partner_revenue) FROM UdrTransactionYouTubeRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_ADA_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionAdaRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_WASAFI_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionWasafiRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_YT_TRANS_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.partner_revenue) FROM UdrTransactionYoutubeTransactionRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")
  UDR_RAW_BELIVE_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.account_total) FROM UdrTransactionBeliveDigitalRawUdrs t1 WHERE t1.is_valid=1 AND t1.udr_transaction_id = $UDR_ID")

  UDR_FORMATTED_TP_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionThirdPartyFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_YT_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionYouTubeFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_ADA_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionAdaFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionWasafiFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")
  UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UdrTransactionBeliveDigitalFormattedUdrs t1 WHERE t1.udr_transaction_id = $UDR_ID")

  UDR_MAIN_GROSS_SALES_PRICE=$(execute_query "SELECT SUM(t1.gross_sales_price) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID")
  #Null
  
  IS_NULL_COUNT=$(execute_query "SELECT COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND (t1.country_id IS NULL OR t1.currency_id IS NULL OR t1.usd_currency_rate IS NULL OR t1.gross_sales_price IS NULL OR t1.cp_share_percentage IS NULL OR t1.cp_share_provisional_usd IS NULL)")
  
  NULL_COUNTRY_COUNT=$(execute_query "SELECT content_partner_id, COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND t1.country_id IS NULL GROUP BY content_partner_id")
  NULL_CURRENCY_COUNT=$(execute_query "SELECT content_partner_id, COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND t1.currency_id IS NULL GROUP BY content_partner_id")
  NULL_USD_RATE_COUNT=$(execute_query "SELECT content_partner_id, COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND t1.usd_currency_rate IS NULL GROUP BY content_partner_id")
  NULL_GROSS_SALES_PRICE_COUNT=$(execute_query "SELECT content_partner_id, COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND t1.gross_sales_price IS NULL GROUP BY content_partner_id")
  NULL_CP_SHARE_PERCENTAGE_COUNT=$(execute_query "SELECT content_partner_id, COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND t1.cp_share_percentage IS NULL GROUP BY content_partner_id")
  NULL_CP_SHARE_PROVISIONAL_COUNT=$(execute_query "SELECT content_partner_id, COUNT(1) FROM UsageAndSalesSummaries t1 WHERE t1.udr_transaction_id = $UDR_ID AND t1.cp_share_provisional_usd IS NULL GROUP BY content_partner_id")


 # Round the gross sales price values to 2 decimal places
  UDR_RAW_TP_GROSS_SALES_PRICE=$(round_number "$UDR_RAW_TP_GROSS_SALES_PRICE" 2)
  UDR_RAW_YT_GROSS_SALES_PRICE=$(round_number "$UDR_RAW_YT_GROSS_SALES_PRICE" 2)
  UDR_RAW_ADA_GROSS_SALES_PRICE=$(round_number "$UDR_RAW_ADA_GROSS_SALES_PRICE" 2)
  UDR_RAW_WASAFI_GROSS_SALES_PRICE=$(round_number "$UDR_RAW_WASAFI_GROSS_SALES_PRICE" 2)
  UDR_RAW_YT_TRANS_GROSS_SALES_PRICE=$(round_number "$UDR_RAW_YT_TRANS_GROSS_SALES_PRICE" 2)
  UDR_RAW_BELIVE_GROSS_SALES_PRICE=$(round_number "$UDR_RAW_BELIVE_GROSS_SALES_PRICE" 2)

  UDR_FORMATTED_TP_GROSS_SALES_PRICE=$(round_number "$UDR_FORMATTED_TP_GROSS_SALES_PRICE" 2)
  UDR_FORMATTED_YT_GROSS_SALES_PRICE=$(round_number "$UDR_FORMATTED_YT_GROSS_SALES_PRICE" 2)
  UDR_FORMATTED_ADA_GROSS_SALES_PRICE=$(round_number "$UDR_FORMATTED_ADA_GROSS_SALES_PRICE" 2)
  UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE=$(round_number "$UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE" 2)
  UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE=$(round_number "$UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE" 2)

  UDR_MAIN_GROSS_SALES_PRICE=$(round_number "$UDR_MAIN_GROSS_SALES_PRICE" 2)


  if [ "$UDR_RAW_TP_COUNT" -gt 0 -a "$UDR_RAW_YT_COUNT" -eq 0 -a "$UDR_RAW_ADA_COUNT" -eq 0 -a "$UDR_RAW_WASAFI_COUNT" -eq 0 -a "$UDR_RAW_YT_TRANS_COUNT" -eq 0 -a "$UDR_RAW_BELIVE_COUNT" -eq 0 -a "$UDR_MAIN_TP_COUNT" -gt 0 ]; then
    if [ "$(echo "$UDR_RAW_TP_COUNT == $UDR_FORMATTED_TP_COUNT" | bc)" -eq 1 -a "$(echo "$UDR_RAW_TP_GROSS_SALES_PRICE == $UDR_FORMATTED_TP_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$(echo "$UDR_FORMATTED_TP_GROSS_SALES_PRICE == $UDR_MAIN_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$IS_NULL_COUNT" -eq 0 ]; then
      echo "UDR $UDR_ID: OK"
    else
      echo "UDR $UDR_ID: Not OK. The values are not equal. 
      UDR_RAW_TP_VALID_COUNT : $UDR_RAW_TP_COUNT 
      UDR_FORMATTED_TP_VALID_COUNT : $UDR_FORMATTED_TP_COUNT 
      UDR_RAW_TP_GROSS_SALES_PRICE: $UDR_RAW_TP_GROSS_SALES_PRICE 
      UDR_FORMATTED_TP_GROSS_SALES_PRICE: $UDR_FORMATTED_TP_GROSS_SALES_PRICE 
      UDR_MAIN_GROSS_SALES_PRICE: $UDR_MAIN_GROSS_SALES_PRICE
      IS_NULL_TOTAL_COUNT: $IS_NULL_COUNT
          
      Null Country Count: $NULL_COUNTRY_COUNT
      Null Currency Count: $NULL_CURRENCY_COUNT
      Null USD Rate Count: $NULL_USD_RATE_COUNT
      Null Gross Sales Price Count: $NULL_GROSS_SALES_PRICE_COUNT
      Null CP Share Percentage Count: $NULL_CP_SHARE_PERCENTAGE_COUNT
      Null CP Share Provisional Count: $NULL_CP_SHARE_PROVISIONAL_COUNT"

    fi
  elif [ "$UDR_RAW_TP_COUNT" -eq 0 -a "$UDR_RAW_YT_COUNT" -gt 0 -a "$UDR_RAW_ADA_COUNT" -eq 0 -a "$UDR_RAW_WASAFI_COUNT" -eq 0 -a "$UDR_RAW_YT_TRANS_COUNT" -eq 0 -a "$UDR_RAW_BELIVE_COUNT" -eq 0 -a "$UDR_MAIN_TP_COUNT" -gt 0 ]; then
    if [ "$(echo "$UDR_RAW_YT_COUNT == $UDR_FORMATTED_YT_COUNT" | bc)" -eq 1 -a "$(echo "$UDR_RAW_YT_GROSS_SALES_PRICE == $UDR_FORMATTED_YT_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$(echo "$UDR_FORMATTED_YT_GROSS_SALES_PRICE == $UDR_MAIN_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$IS_NULL_COUNT" -eq 0 ]; then
      echo "UDR $UDR_ID: OK"
    else
      echo "UDR $UDR_ID: Not OK. The values are not equal. 
      UDR_RAW_YT_VALID_COUNT : $UDR_RAW_YT_COUNT 
      UDR_FORMATTED_YT_VALID_COUNT : $UDR_FORMATTED_YT_COUNT 
      UDR_RAW_YT_GROSS_SALES_PRICE: $UDR_RAW_YT_GROSS_SALES_PRICE 
      UDR_FORMATTED_YT_GROSS_SALES_PRICE: $UDR_FORMATTED_YT_GROSS_SALES_PRICE 
      UDR_MAIN_GROSS_SALES_PRICE: $UDR_MAIN_GROSS_SALES_PRICE
      IS_NULL_TOTAL_COUNT: $IS_NULL_COUNT
      Null Country Count: $NULL_COUNTRY_COUNT
      Null Currency Count: $NULL_CURRENCY_COUNT
      Null USD Rate Count: $NULL_USD_RATE_COUNT
      Null Gross Sales Price Count: $NULL_GROSS_SALES_PRICE_COUNT
      Null CP Share Percentage Count: $NULL_CP_SHARE_PERCENTAGE_COUNT
      Null CP Share Provisional Count: $NULL_CP_SHARE_PROVISIONAL_COUNT"

    fi
  elif [ "$UDR_RAW_TP_COUNT" -eq 0 -a "$UDR_RAW_YT_COUNT" -eq 0 -a "$UDR_RAW_ADA_COUNT" -gt 0 -a "$UDR_RAW_WASAFI_COUNT" -eq 0 -a "$UDR_RAW_YT_TRANS_COUNT" -eq 0 -a "$UDR_RAW_BELIVE_COUNT" -eq 0 -a "$UDR_MAIN_TP_COUNT" -gt 0 ]; then
    if [ "$(echo "$UDR_RAW_ADA_COUNT == $UDR_FORMATTED_ADA_COUNT" | bc)" -eq 1 -a "$(echo "$UDR_RAW_ADA_GROSS_SALES_PRICE == $UDR_FORMATTED_ADA_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$(echo "$UDR_FORMATTED_ADA_GROSS_SALES_PRICE == $UDR_MAIN_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$IS_NULL_COUNT" -eq 0 ]; then
      echo "UDR $UDR_ID: OK"
    else
       echo "UDR $UDR_ID: Not OK. The values are not equal. 
      UDR_RAW_ADA_VALID_COUNT: $UDR_RAW_ADA_COUNT 
      UDR_FORMATTED_ADA_VALID_COUNT: $UDR_FORMATTED_ADA_COUNT 
      UDR_RAW_ADA_GROSS_SALES_PRICE: $UDR_RAW_ADA_GROSS_SALES_PRICE 
      UDR_FORMATTED_ADA_GROSS_SALES_PRICE: $UDR_FORMATTED_ADA_GROSS_SALES_PRICE 
      UDR_MAIN_GROSS_SALES_PRICE: $UDR_MAIN_GROSS_SALES_PRICE
      IS_NULL_TOTAL_COUNT: $IS_NULL_COUNT
          
      Null Country Count: $NULL_COUNTRY_COUNT
      Null Currency Count: $NULL_CURRENCY_COUNT
      Null USD Rate Count: $NULL_USD_RATE_COUNT
      Null Gross Sales Price Count: $NULL_GROSS_SALES_PRICE_COUNT
      Null CP Share Percentage Count: $NULL_CP_SHARE_PERCENTAGE_COUNT
      Null CP Share Provisional Count: $NULL_CP_SHARE_PROVISIONAL_COUNT"

      
    fi
  elif [ "$UDR_RAW_TP_COUNT" -eq 0 -a "$UDR_RAW_YT_COUNT" -eq 0 -a "$UDR_RAW_ADA_COUNT" -eq 0 -a "$UDR_RAW_WASAFI_COUNT" -gt 0 -a "$UDR_RAW_YT_TRANS_COUNT" -eq 0 -a "$UDR_RAW_BELIVE_COUNT" -eq 0 -a "$UDR_MAIN_TP_COUNT" -gt 0 ]; then
    if [ "$(echo "$UDR_RAW_WASAFI_COUNT == $UDR_FORMATTED_WASAFI_COUNT" | bc)" -eq 1 -a "$(echo "$UDR_RAW_WASAFI_GROSS_SALES_PRICE == $UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$(echo "$UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE == $UDR_MAIN_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$IS_NULL_COUNT" -eq 0 ]; then
      echo "UDR $UDR_ID: OK"
    else
       echo "UDR $UDR_ID: Not OK. The values are not equal. 
      UDR_RAW_WASAFI_VALID_COUNT: $UDR_RAW_WASAFI_COUNT 
      UDR_FORMATTED_WASAFI_VALID_COUNT: $UDR_FORMATTED_WASAFI_COUNT 
      UDR_RAW_WASAFI_GROSS_SALES_PRICE: $UDR_RAW_WASAFI_GROSS_SALES_PRICE 
      UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE: $UDR_FORMATTED_WASAFI_GROSS_SALES_PRICE 
      UDR_MAIN_GROSS_SALES_PRICE: $UDR_MAIN_GROSS_SALES_PRICE 
      IS_NULL_TOTAL_COUNT: $IS_NULL_COUNT
          
      Null Country Count: $NULL_COUNTRY_COUNT
      Null Currency Count: $NULL_CURRENCY_COUNT
      Null USD Rate Count: $NULL_USD_RATE_COUNT
      Null Gross Sales Price Count: $NULL_GROSS_SALES_PRICE_COUNT
      Null CP Share Percentage Count: $NULL_CP_SHARE_PERCENTAGE_COUNT
      Null CP Share Provisional Count: $NULL_CP_SHARE_PROVISIONAL_COUNT"

    fi
  elif [ "$UDR_RAW_TP_COUNT" -eq 0 -a "$UDR_RAW_YT_COUNT" -eq 0 -a "$UDR_RAW_ADA_COUNT" -eq 0 -a "$UDR_RAW_WASAFI_COUNT" -eq 0 -a "$UDR_RAW_YT_TRANS_COUNT" -gt 0 -a "$UDR_RAW_BELIVE_COUNT" -eq 0 -a "$UDR_MAIN_TP_COUNT" -gt 0 -a "$IS_NULL_COUNT" -eq 0 ]; then
    if [ "$(echo "$UDR_RAW_YT_TRANS_GROSS_SALES_PRICE == $UDR_FORMATTED_YT_TRANS_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$(echo "$UDR_FORMATTED_YT_TRANS_GROSS_SALES_PRICE == $UDR_MAIN_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$IS_NULL_COUNT" -eq 0 ]; then
      echo "UDR $UDR_ID: OK"
    else
       echo "UDR $UDR_ID: Not OK. The values are not equal. 
      UDR_RAW_YT_TRANS_VALID_COUNT: $UDR_RAW_YT_TRANS_COUNT 
      UDR_RAW_YT_TRANS_GROSS_SALES_PRICE: $UDR_RAW_YT_TRANS_GROSS_SALES_PRICE 
      UDR_MAIN_GROSS_SALES_PRICE: $UDR_MAIN_GROSS_SALES_PRICE 
      IS_NULL_TOTAL_COUNT: $IS_NULL_COUNT
          
      Null Country Count: $NULL_COUNTRY_COUNT
      Null Currency Count: $NULL_CURRENCY_COUNT
      Null USD Rate Count: $NULL_USD_RATE_COUNT
      Null Gross Sales Price Count: $NULL_GROSS_SALES_PRICE_COUNT
      Null CP Share Percentage Count: $NULL_CP_SHARE_PERCENTAGE_COUNT
      Null CP Share Provisional Count: $NULL_CP_SHARE_PROVISIONAL_COUNT"

    fi
  elif [ "$UDR_RAW_TP_COUNT" -eq 0 -a "$UDR_RAW_YT_COUNT" -eq 0 -a "$UDR_RAW_ADA_COUNT" -eq 0 -a "$UDR_RAW_WASAFI_COUNT" -eq 0 -a "$UDR_RAW_YT_TRANS_COUNT" -eq 0 -a "$UDR_RAW_BELIVE_COUNT" -gt 0 -a "$UDR_MAIN_TP_COUNT" -gt 0 ]; then
    if [ "$(echo "$UDR_RAW_BELIVE_COUNT == $UDR_FORMATTED_BELIVE_COUNT" | bc)" -eq 1 -a "$(echo "$UDR_RAW_BELIVE_GROSS_SALES_PRICE == $UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$(echo "$UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE == $UDR_MAIN_GROSS_SALES_PRICE" | bc)" -eq 1 -a "$IS_NULL_COUNT" -eq 0 ]; then
      echo "UDR $UDR_ID: OK"
    else
      echo "UDR $UDR_ID: Not OK. The values are not equal. 
      UDR_RAW_BELIVE_VALID_COUNT: $UDR_RAW_BELIVE_COUNT 
      UDR_FORMATTED_BELIVE_VALID_COUNT: $UDR_FORMATTED_BELIVE_COUNT 
      UDR_RAW_BELIVE_GROSS_SALES_PRICE: $UDR_RAW_BELIVE_GROSS_SALES_PRICE 
      UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE: $UDR_FORMATTED_BELIVE_GROSS_SALES_PRICE 
      UDR_MAIN_GROSS_SALES_PRICE: $UDR_MAIN_GROSS_SALES_PRICE 
      IS_NULL_TOTAL_COUNT: $IS_NULL_COUNT
          
      Null Country Count: $NULL_COUNTRY_COUNT
      Null Currency Count: $NULL_CURRENCY_COUNT
      Null USD Rate Count: $NULL_USD_RATE_COUNT
      Null Gross Sales Price Count: $NULL_GROSS_SALES_PRICE_COUNT
      Null CP Share Percentage Count: $NULL_CP_SHARE_PERCENTAGE_COUNT
      Null CP Share Provisional Count: $NULL_CP_SHARE_PROVISIONAL_COUNT"

    fi  
  else
    echo "UDR $UDR_ID: Not OK"
  fi
}

# Read UDR transaction IDs from user input
echo "Enter UDR transaction IDs separated by spaces (e.g., 6285 6286 6287):"
read -a UDR_IDS

# Check UDR status for each ID
for UDR_ID in "${UDR_IDS[@]}"; do
  check_udr_status "$UDR_ID"
done
