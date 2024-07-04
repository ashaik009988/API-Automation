Feature:Wickes Installation Orders positive flow

  Background:

    * url 'https://installationorders-api.preprod.wickes.systems'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

     ##Verify the request json with only mandatory fields
  Scenario: 1 PUT Installation Order.

    * def writeToCommonData = functions.write(commonData)
    Given path '/installation-order'
    And  request
  """
  {
  "jobId": "509611",
  "number": "925751",
  "orderId": "3109502",
  "quoteId": "3037042",
  "storeId": "8807"
}
  """
    And header x-api-key = 'epk12xtXnh9GRf5JDkqzv4F86KaTdqOK9fFzydyS'
    When method PUT
    And print 'Response:', response
    Then status 200

##Verify the request json with all the fields in swagger.
  Scenario: 2 PUT Installation Order.

    * def writeToCommonData = functions.write(commonData)
    Given path '/installation-order'
    And json requestBody = read('data/PUT_Request2.json')
    And header x-api-key = 'epk12xtXnh9GRf5JDkqzv4F86KaTdqOK9fFzydyS'
    And request requestBody
    When method PUT
    And print 'Response:', response
    Then status 200

  Scenario: 3 GET Retrieve installation order data.

    Given path '/installation-order'
    And header x-api-key = 'epk12xtXnh9GRf5JDkqzv4F86KaTdqOK9fFzydyS'
    And configure readTimeout = 60000
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_1_GET_RetrieveInstallationOrderData.json')
    Then match response contains deep schema


  Scenario: 4 GET Retrieve installation order data.

    Given path '/installation-order'
    And params { limit: '5'}
    And header x-api-key = 'epk12xtXnh9GRf5JDkqzv4F86KaTdqOK9fFzydyS'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_1_GET_RetrieveInstallationOrderData.json')
    Then match response contains deep schema