Feature:Wickes Installation Orders Negative flow

  Background:

    * url 'https://installationorders-api.preprod.wickes.systems'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)


  Scenario: 1 GET Retrieve installation order data( 502 Bad Gateway- passing limit as 0).

    Given path '/installation-order'
    And params { limit: "0" }
    And header x-api-key = 'wMJISdppzi5cPMC7LGAJY2l8TYgxB2DxaZb0o5Ok'
    When method GET
    And json response = response
    Then status 502
    Then match $.message == 'Internal server error'


  Scenario: 2 GET Retrieve installation order data( 403 Forbidden- Invalid url).

    Given path '/installationorder'
    And params { limit: '5'}
    And header x-api-key = 'wMJISdppzi5cPMC7LGAJY2l8TYgxB2DxaZb0o5Ok'
    When method GET
    And json response = response
    Then status 403
    Then match $.message == 'Missing Authentication Token'


  Scenario: 3 GET Retrieve installation order data( 404 Not Found- Pasing invalid storeId).

    Given path '/installation-order'
    And params { installerId: '909080'}
    And header x-api-key = 'wMJISdppzi5cPMC7LGAJY2l8TYgxB2DxaZb0o5Ok'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response


  Scenario: 4 GET Retrieve installation order data( 400 Bad Request -passing limit as 'test').

    Given path '/installation-order'
    And params { limit: 'test'}
    And header x-api-key = 'wMJISdppzi5cPMC7LGAJY2l8TYgxB2DxaZb0o5Ok'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response

    ## Verify the by missing mandatory fields in request json
  Scenario: 5 PUT Installation Order.

    * def writeToCommonData = functions.write(commonData)
    Given path '/installation-order'
    And  request
  """
  {
  "jobId": "",
  "number": "925751",
  "orderId": "3109502",
  "quoteId": "3037042",
  "storeId": "8807"
}
  """
    And header x-api-key = 'epk12xtXnh9GRf5JDkqzv4F86KaTdqOK9fFzydyS'
    When method PUT
    And print 'Response:', response
    Then status 502
    Then match $.message == 'Internal server error'

