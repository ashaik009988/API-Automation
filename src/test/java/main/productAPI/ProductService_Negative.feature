Feature:Wickes Product Service Negative flow

  Background:

    * url 'https://product-api.services.preprod.wickes.systems/product/v1'
    * def functions = Java.type('main.CustomDefs')
    * json commonData = functions.readCommonValue()

  Scenario: 1 v1 GET/product 404 negative scenario invalid url

    Given path '/product/'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 404
    And print 'Response:', response
    Then match $.status == 404
    Then match $.error == 'Not Found'
    Then match $.message == 'No message available'


  Scenario: 2 POST/retrieve Negative scenario 400 bad request

    Given path '/retrieve'
    When request
    """
    {
  "productId": [

  ]
}
    """
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method POST
    And print 'Response:', response
    Then status 400
    #Then match $.productId contains 'size must be between 1 and 2147483647'
    Then match $ contains {"productRequest => [productId]" : '#notnull'}

  Scenario: 3 POST/retrieve No content -500 bad request

    Given path '/retrieve'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And header Content-Type = 'application/json'
    When method POST
    And print 'Response:', response
    Then status 500
    Then match $.responseCode == "500"
    Then match $.status contains "Required request body is missing:"

  Scenario: 4 GET/products/paged negative scenario 400 bad request

    Given path '/products/paged'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'


  Scenario: 5 GET/products/ negative scenario 404 Not Found

    Given path '/products/'
    And params { limit: '5'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response
    Then match $.status == 404
    Then match $.error == 'Not Found'
    Then match $.message == 'No message available'


  Scenario: 6 V1 POST /search - 204 No Content

    Given path '/search'
    And params {limit : '5'}
    And json requestBody = read('data/postSearch_requestBodyNoContent.json' )
    And request requestBody
    And configure readTimeout = 50000
    When method POST
    And print 'Response:', response
    Then status 204

  Scenario: 7 V1 POST /search - Negative Scenario - 500 internal server error

    Given path '/search'
    And params {limit : '10'}
    And configure readTimeout = 10000
    And header Content-Type = 'application/json'
    When method POST
    And print 'Response:', response
    Then status 500
    Then match $.status contains "Required request body is missing"

  Scenario: 8 V1 POST /search - Negative Scenario - 400 bad request

    Given path '/search'
    And json requestBody = read('data/postSearch_requestBody.json' )
    And request requestBody
    And configure readTimeout = 10000
    When method POST
    And print 'Response:', response
    Then status 400
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'


  Scenario: 9 V1 POST /searchCache - 204 No Content

    Given path '/search'
    And params {limit : '5'}
    And request

"""
{
"operator": "OR",
"searchItems": [
{
"fieldName": "description",
"operator": "=",
"fieldValue": "jhsaj"
}
]
}
"""

    And configure readTimeout = 50000
    When method POST
    And print 'Response:', response
    Then status 204

  Scenario: 10 V1 POST /searchCache - Negative Scenario - 500 internal server error

    Given path '/search'
    And params {limit : '10'}
    And json requestBody = read('data/postSearch_requestBodyError')
    And request requestBody
    And print requestBody
    And configure readTimeout = 10000
    And header Content-Type = 'application/json'
    When method POST
    And print 'Response:', response
    Then status 500
# Then match $.status contains "JSON parse error: Unexpected close marker '}': expected ']'"
    Then match $.status contains "Required request body is missing"

  Scenario: 11 V1 POST /searchCache - Negative Scenario - 400 bad request

    Given path '/search'
    And json requestBody = read('data/postSearch_requestBody.json' )
    And request requestBody
    And configure readTimeout = 10000
    When method POST
    And print 'Response:', response
    Then status 400
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'


    #GET Call

    # Error message "message": "Mandatory input/s missing"

  Scenario: 12 GET Publish Core transaction to Kinesis stream_Negative cases_400 Bad Request

    Given path '/publish'
    And params { toTime : '#(commonData.toTime)', stream: '#(commonData.stream)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 400
    And print 'Response:', response
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'
    Then match $.fieldErrors[0].fieldName == 'fromTime' || 'stream' || 'toTime'


# Error message "message": "Value not valid"

  Scenario: 13 GET Publish Core transaction to Kinesis stream_Negative cases_400 Bad Request
    Given path '/publish'
    And params { fromTime : '2022-12-10T05:36:50.59', toTime : '#(commonData.toTime)', stream: '#(commonData.stream)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 400
    And print 'Response:' , response

#POST call
    # 500_Internal server_Error message "message": "Required request body is missing:"

  Scenario: 14 POST Product service api to retrieve list of product data_500 Internal server error

    Given path '/publish'
    And params {key : '#(commonData.key)'}
    When request
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method POST
    Then status 500
    And print 'Response:', response
    Then match $.responseCode == "500"
    Then match $.status contains "Required request body is missing:"

# 400_Bad request_Error message "message": "Mandatory input/s missing"


  Scenario: 15 POST Product service api to retrieve list of product data_400 Bad Request

    Given path '/publish'
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
    Then status 400
    And print 'Response:', response
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'
    Then match $.fieldErrors[0].fieldName == 'key'

# PUT call

      # 500_Internal server_Error message "message": "Required request body is missing:"
  Scenario: 16 PUT product service persists product data passed in the input_500_internal Server

    Given path '/persist'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And header Content-Type = 'application/json'
    When method PUT
    Then status 500
    And print 'Response:' , response
    Then match $.responseCode == "500"
    Then match $.status contains "Required request body is missing:"

  Scenario: 17 PUT product service persists product data passed in the input.
    * set commonData.skuCode = functions.getRandomTransactionNumber()
    * def writeToCommonData = functions.write(commonData)

    Given path '/persist'
    And json requestBody = read('data/PUT_Persist_Negative scenario_request.json' )
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And request requestBody
    When method PUT
    Then status 400
    And print 'Response:' , response
    Then match $ contains {"persistProduct => [gpid]" : '#notnull'}