Feature: Wickes Product Service

  Background:

    * url 'https://product-api.services.preprod.wickes.systems/product/v1'
    * def functions = Java.type('main.CustomDefs')
    * json commonData = functions.readCommonValue()

  Scenario: 1 PUT product service persists product data passed in the input.

    * set commonData.gpid = functions.getRandomGpid()
    * set commonData.skuCode = functions.getRandomTransactionNumber()
    * def writeToCommonData = functions.write(commonData)


    Given path '/persist'
    And json requestBody = read('data/PUT_persisit_request.json' )
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And request requestBody
    When method PUT
    And print 'Response:', response
    Then status 200
    * json schema = read('Schema/Scenarios_1_PersistProduct_PUT.json')
    Then match requestBody contains deep schema

  Scenario: 2 GET Product service api to retrieve product data for a product id

    * set commonData.productId = commonData.skuCode
    * def writeToCommonData = functions.write(commonData)

    Given path '/product/'   +commonData.productId
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_2_GET_ProductServiceApitoretrieveproductdataforaproductid.json' )
    Then match response contains deep schema

  Scenario: 3 POST Product service api to retrieve list of product data

    Given path '/retrieve'
    When request
    """
    {
  "productId": [
    "#(commonData.productId)"
  ]
}
    """
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method POST
    And print 'Response:', response
    Then status 200

  Scenario: 4 GET Product service api to retrieve paged product data.

    Given path '/products/paged'
    And params { limit: '5'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_3_GET_Productserviceapitoretrievepagedproductdata.json')
    Then match response contains deep schema

  Scenario: 5 GET Publish Core transaction to Kinesis stream

    Given path '/publish'
    And params {fromTime : '#(commonData.fromTime)', toTime : '#(commonData.toTime)', stream: '#(commonData.stream)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 202

  Scenario: 6 POST Product service api to retrieve list of product data

    Given path '/publish'
    And params {key : '#(commonData.key)'}
    When request
"""
{
"productId": [
"#(commonData.productId)"
]
}
"""
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method POST
    And print 'Response:', response
    Then status 202


  Scenario: 7 V1 POST /search The product service to get product data by SearchItem

    Given path '/search'
    And params {limit : '10'}
    And json requestBody = read('data/postSearch_requestBody.json' )
    And request requestBody
    And configure readTimeout = 10000
    When method POST
    And print 'Response:', response
    Then status 200

    * json schema = read('schema/Scenario_7_v1_search_PUT.json' )
    Then match response contains deep schema

  Scenario: 8 V1 POST /searchCache The product service to get list of product data from Cache

    Given path '/searchCache'
    And params {limit : '10'}
    When request

"""
{
"operator": "OR",
"searchItems": [
{
"fieldName": "description",
"operator": "begins_with",
"fieldValue": "Wickes"
}
]
}
"""
    And configure readTimeout = 10000
    When method POST
    And print 'Response:', response
    Then status 200

    * json schema = read('schema/Scenario_8_v1_searchCache_PUT.json')
    Then match response contains deep schema

  Scenario: 9 V1 POST /reloadCache

    Given path '/reloadCache'
    And configure readTimeout = 10000
    When method POST
    Then status 204





