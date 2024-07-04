Feature: Wickes Sales Service

  Background:

    * def functions = Java.type('main.CustomDefs')


  Scenario: 1 V2 Persist Core Sales Transactional Data

    * json requestBody = read('data/coreSales_retryPayload.json')
    * set requestBody.transaction_number = functions.getRandomTransactionNumber()
    * set requestBody.payment_date = functions.getTodayDate()
    * set requestBody.order_store_code = '8804'
    * set requestBody.creation_date_time = functions.getTodayDateTime()
    * def filename = functions.getAlphaNumericString(6)
    * def writedata = functions.temporaryWrite(requestBody,filename)




