Feature:Wickes Price Promotion positive flow

  Background:

    * url 'https://price-promotion-api.services.preprod.wickes.systems/price-promotion/v1'
    * def functions = Java.type('main.CustomDefs')
    * json commonData = functions.readCommonValue()


  Scenario: 1 GET Retrieve paged price and promotion data

    Given path '/paged'
    And params { limit: '5'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_1_GET_Retrievepagedpriceandpromotiondata.json')
    Then match response contains deep schema


  Scenario: 2 GET Retrieve paged price and promotion data without overlapping price events

    Given path '/delta/paged'
    And params { limit: '5'}
    And params { deltaDate : '#(commonData.deltaDate)'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_2_GET_priceandpromotiondatawithoutoverlappingpriceevents.json')
    Then match response contains deep schema

