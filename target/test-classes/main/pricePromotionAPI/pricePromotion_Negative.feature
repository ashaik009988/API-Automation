Feature:Wickes Price Promotion Negative flow

  Background:

    * url 'https://price-promotion-api.services.preprod.wickes.systems/price-promotion/v1'
    * def functions = Java.type('main.CustomDefs')
    * json commonData = functions.readCommonValue()

  Scenario: 1 GET 404 negative scenario invalid url

    Given path '/page'
    And params { limit: '5'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 404
    And print 'Response:', response
    Then match $.status == 404
    Then match $.error == 'Not Found'
    Then match $.message == 'No message available'

  Scenario: 2 GET  negative scenario 400 bad request

    Given path '/paged'
    And params { limit: '0'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response
    Then match $.fieldErrors[0].message == 'Value not valid'


  Scenario: 3 GET  negative scenario 400 bad request

    Given path '/paged'
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'


  Scenario: 4 GET Negative 404 bad request

    Given path '/delta/pag'
    And params { limit: '5'}
    And params { deltaDate : '#(commonData.deltaDate)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 404
    And print 'Response:', response
    Then match $.status == 404
    Then match $.error == 'Not Found'
    Then match $.message == 'No message available'

  Scenario: 5 GET Negative 400 bad request

    Given path '/delta/paged'
    And params { limit: '5'}
    #And params { deltaDate : '#(commonData.deltaDate)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 400
    And print 'Response:', response
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'