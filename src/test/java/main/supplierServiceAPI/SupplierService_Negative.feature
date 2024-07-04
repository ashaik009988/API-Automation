Feature: Wickes Supplier Service Negative Scenario

  Background:

    * url 'https://supplier-api.services.preprod.wickes.systems/supplier'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 GET 404 Not found (invalid url)

    * set commonData.productId = commonData.skuCode
    * def writeToCommonData = functions.write(commonData)

    Given path '/v1' + commonData.wickes_supplier_code
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And print 'Response:', response
    Then match $.status == 404
    Then match $.error == 'Not Found'
    Then match $.message == 'No message available'

  Scenario: 2 GET 400 Bad Request if the path variables are not passed(wickes_supplier_code)

    Given path '/v1'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And print 'Response:', response
    Then status 400


  Scenario: 3 PATCH  500 error Invalid URL

    * def writeToCommonData = functions.write(commonData)

    Given path '/v1/installer' + commonData.wickes_supplier_code
    And json requestBody = read('data/PATCH_UpdateInstaller.json')
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And request requestBody
    When method PATCH
    Then status 500


  Scenario: 4 GET 400 bad request without limit

    Given path '/v1/paged'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 400

  Scenario: 5 GET 404 not found invalid url

    Given path '/v1paged'
    And params { limit: '5' , }
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response
    Then match $.status == 404
    Then match $.error == 'Not Found'
    Then match $.message == 'No message available'


  Scenario: 6 GET 500 Internal server error without passing the limit value

    Given path '/v1/paged'
    And params { limit: " " }
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    And print 'Response:', response
    Then status  500

  Scenario: 7 GET 400 bad request when the limit is invalid

    Given path '/v1/paged'
    And params { limit: '#@#$^'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    And print 'Response:', response
    Then status 400




