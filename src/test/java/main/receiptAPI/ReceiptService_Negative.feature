Feature:Wickes Receipt service Negative flow

  Background:

    * url 'https://receipt-api.preprod.wickes.systems/receipt/v2'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)


  Scenario: 1 Get call Negative scenario (400 : invalid location numbers)

    Given path '/receipt'  + commonData.locationNumber + '/' + commonData.drlNumber
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    When method GET
    And json response = response
    Then status 403
    And print 'Response:', response
    Then match $.message == 'Missing Authentication Token'


  Scenario: 2 Get call Negative scenario (400 invalid location number)

    Given path '/receipt/'  + commonData.locationNumberssssss + '/' + commonData.drlNumber
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response


  Scenario: 3 Negative scenario Invalid url 403 bad request

    Given path '/receipt'  + commonData.locationNumber + '/' + commonData.drlNumber + '/' + commonData.productId
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    And configure readTimeout = 10000
    When method GET
    And json response = response
    Then status 403
    And print 'Response:', response
    Then match $.message == 'Missing Authentication Token'


  Scenario: 4 GET call( 403 status: without passing the mandatory params -locationNumber)

    Given path '/receipt' + commonData.drlNumber + '/' + commonData.productId
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    And configure readTimeout = 10000
    When method GET
    And json response = response
    Then status 403
    Then match $.message == 'Missing Authentication Token'


  Scenario: 5 Get call 400 status- passing the invalid location number

    Given path '/receipt/'  + commonData.locationNumberssssss + '/' + commonData.drlNumber + '/' + commonData.productId
    And header x-api-key = 'JwHXlWj5HDbBHJfJ2JGEtCrV7PmHtrWZBhzHvb00'
    And configure readTimeout = 10000
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response


