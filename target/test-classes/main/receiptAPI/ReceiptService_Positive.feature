Feature:Wickes Receipt service positive flow

  Background:

    * url 'https://receipt-api.preprod.wickes.systems/receipt/v2'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 Get a whole logical receipt by locationNumber and DRL

    Given path '/receipt/'  + commonData.locationNumber + '/' + commonData.drlNumber
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_1_GetawholelogicalreceiptbylocationNumberandDRL.json')
    Then match response contains deep schema


  Scenario: 2 Get the latest version of a receipt line by location, DRL number, and Product Id

    Given path '/receipt/'  + commonData.locationNumber + '/' + commonData.drlNumber + '/' + commonData.productId
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    And configure readTimeout = 10000
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_2_GetthelatestversionofareceiptlinebylocationDRLnumberandProductId.json')
    Then match response contains deep schema