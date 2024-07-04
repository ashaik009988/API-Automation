Feature: Wickes Supplier Service Positive flow

  Background:

    * url 'https://supplier-api.services.preprod.wickes.systems/supplier'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 GET Get Supplier by wickes codes

    * set commonData.productId = commonData.skuCode
    * def writeToCommonData = functions.write(commonData)

    Given path '/v1/' + commonData.wickes_supplier_code
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_1_Get_Supplier_by_wickes_codes.json')
    Then match response contains deep schema


  Scenario: 2 PATCH  Update Installer data using PATCH.

    * def writeToCommonData = functions.write(commonData)

    Given path '/v1/installer/' + commonData.wickes_supplier_code
    And json requestBody = read('data/PATCH_UpdateInstaller.json' )
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    And request requestBody
    When method PATCH
    Then status 201


  Scenario: 3 GET Retrieve supplier paged data.

    Given path '/v1/paged'
    And params { limit: '5'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_3_GET_Retrieve_supplier_paged_data.json')
    Then match response contains deep schema

  Scenario: 4 GET Retrieve supplier paged data with Relatable flag as true

    Given path '/v1/paged'
    And params { limit: '5', rebatableFlag: 'true'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_3_GET_Retrieve_supplier_paged_data.json')
    Then match response contains deep schema


  Scenario: 5 GET Retrieve supplier paged data with Relatable flag as false

    Given path '/v1/paged'
    And params { limit: '9', rebatableFlag: 'false'}
    And header x-api-key = 'IejYqOKZ6HeatBxdbXC1Oe6lSGVgvKIU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_3_GET_Retrieve_supplier_paged_data.json')
    Then match response contains deep schema


