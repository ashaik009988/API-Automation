Feature: Wickes Sales Service

  Background:

    * url 'https://api-services.preprod.wickes.systems/sales'
    * def functions = Java.type('main.CustomDefs')
    * json commonData = functions.readCommonData()

  Scenario: 1 V2 PUT Persist Core Sales Transactional Data

    * set commonData.transactionNumber = functions.getRandomTransactionNumber()
    * set commonData.paymentDate = functions.getTodayDate()
    * set commonData.dateToday = functions.getTodayDate()
    * set commonData.storeCode = '8804'
    * set commonData.tillReceiptNumber = functions.getRandomTillReceiptNumber()
    * set commonData.creationDateTime = functions.getTodayDateTime()
    * def writeToCommonData = functions.write(commonData)

    Given path '/v2', '/'
    And json requestBody = read('data/coreSales_requestBody.json' )
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And request requestBody

    * json schema = read('schema/Scenario_1_v2_persitCoreSales_PUT.json' )
    Then match requestBody contains deep schema

    When method PUT
    And print 'Response:', response
    Then status 201

  Scenario: 2 V2 PATCH Core Sales Transactional Data with Card Hash

    Given path '/v2/orderStoreCode/'      +commonData.storeCode+      '/tillNumber/'      +commonData.tillNumber+       '/transactionNumber/'       +commonData.transactionNumber+   '/paymentDate/'    +commonData.paymentDate+  '/cardHash'
    And json requestBody = read('data/coreSales_requestBody_patch.json' )
    And set requestBody.paymentDate = functions.getTodayDate()
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And request requestBody
    When method PATCH
    Then status 200
    #201 expected as per swagger
    #PATCH Not working

  Scenario: 3 GET Publish Core transaction to Kinesis stream

    Given path '/v2/resend'
    And params {number : '#(commonData.transactionNumber)', store : '#(commonData.storeCode)', till: '#(commonData.tillNumber)', creationDateTime: '#(commonData.creationDateTime)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 200
    #creationDateTime accepts all the formats

  Scenario: 4 V2 GET Retrieve Core Sales Transaction Paged Data

    Given path '/v2/paged'
    And params { transactionNumber:'#(commonData.transactionNumber)', limit: '3'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 200
    And print 'Response:', response
    * json expected = read('data/coreSales_responseBody.json' )
    Then match response == expected

    * json schema = read('schema/Scenario_4_v2_paged_GET.json' )
    Then match response contains deep schema

  Scenario: 5 PUT Persist Sales Data

    Given path '/v1/persist'
    When request

    """
{
  "locationNumber": "252",
  "quantity": 5,
  "refundAmount": "5.00",
  "refundDateTime": "2023-05-30",
  "refundQuantity": 1,
  "saleMargin": "5",
  "salePrice": "24",
  "salesDate": "#(commonData.dateToday)",
  "sku": "600721"
}

    """
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method PUT
    And print 'Response:', response
    Then status 200

  Scenario: 6 V1 GET Retrieve Paged Sales Data

    Given path '/v1/salesDate/' + commonData.dateToday + '/paged'
    And params { limit: '20'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And print 'Response:', response
    Then status 200
    And def expectedResponse =

        """
{
  "locationNumber": "252",
  "quantity": 5,
  "saleMargin": "5",
  "salePrice": "24",
  "salesDate": "#(commonData.dateToday)",
  "sku": "600721"
}

    """
    And match response.content contains expectedResponse
    # refund data is not present in the response and so not in sync with the swagger

  Scenario: 7 V2 PUT Persist KnB Sales Transactional Data

    * set commonData.transactionNumber = functions.getRandomTransactionNumber()
    * set commonData.customerOrderID = functions.getRandomTransactionNumber()
    * def writeToCommonData = functions.write(commonData)

    Given path '/v2/knb'
    And json requestBody = read('data/knbCoreSales_requestBody.json' )
    And set requestBody.transaction.number = commonData.transactionNumber
    And request requestBody
    And print requestBody
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method PUT
    And print 'Response:', response
    Then status 200

  Scenario: 8 V2 GET Retrieve consolidated KnB sales data using order number


    Given path '/v2/knb'
    And params { customerOrderNumber: '#(commonData.transactionNumber)', storeNumber: '8804', supplierOrderNumber: '00955' }
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And print 'Response:', response
    Then status 200

  Scenario: 9 V2 GET Retrieve KnB Sales Transaction Paged Data

    Given path '/v2/knb/paged'
    And params { supplierCode: '96002', limit: '3'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And configure readTimeout = 10000
    When method GET
    And json response = response
    Then status 200
    * json schema = read('schema/Scenario_9_v2_Knb_Paged_GET.json' )
    Then match response contains deep schema

  Scenario: 10 GET Retrieve KnB sales transaction paged data (YET TO BE DEVELOPED)

#    Given path '/v2/knb/salesOnly/paged'
#    And params { limit: '3', saleDate: '#(commonData.dateToday)', storeCode: '#(commonData.storeCode)', onlyInstSales: 'No' }
#    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
#    When method GET
#    And print 'Response:', response
#    Then status 200

  Scenario: 11 GET Get a single KnB Sales details by Order Number (YET TO BE DEVELOPED)

#    Given path '/v2/knb/salesOnly/store/'  +commonData.storeCode+  '/order/'  + commonData.customerOrderID
#    And path { salesOrderNumber: '', storeNumber: '3' }
#    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
#    When method GET
#    And print 'Response:', response
#    Then status 200

  Scenario: 12 GET Publish KnB transaction to Kinesis stream
    Given path /v2/knb/resend
    And params { customerOrderNumber:  '#(commonData.customerOrderID)', supplierOrderNumber: '#(commonData.transactionNumber)', storeNumber: '#(commonData.storeCode)' }
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And print 'Response:', response
    Then status 200