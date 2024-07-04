Feature:Wickes location service positive flow

  Background:

    * url 'https://location-api.preprod.wickes.systems'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 Get a list of open stores

    Given path '/store'
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    And configure readTimeout = 10000
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_1_GET_Getaalistofopenstores.json')
    Then match response contains deep schema

  Scenario: 2 Get a specific open store

    Given path '/store/' + commonData.locationNumber
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_2_GetaSpecificOpenStore.json')
    Then match response contains deep schema

  Scenario: 3 Get list of all location ranges

    Given path '/range'
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_3_GetRange.json')
    Then match response contains deep schema


  Scenario: 4 Post create Range
    * set commonData.rangeName = functions.getRangeName()
    * def writeToCommonData = functions.write(commonData)

    Given path '/range'
    When request
    """
    {
    "rangeName": "#(commonData.rangeName)",
    "rangeDescription": "testing the data"
}
    """
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method POST
    And print 'Response:', response
    Then status 201
    Then match $.rangeDescription == "testing the data"
    * set commonData.rangeId = $.rangeId
    * def writeToCommonData = functions.write(commonData)


  Scenario: 5 Get range by ID

    Given path '/range/'    +commonData.rangeId
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_5_GetRangeById.json')
    Then match response contains deep schema


  Scenario: 6 updateRange

    Given path '/range/'    +commonData.rangeId
    When request
    """
    {
    "rangeName": "#(commonData.rangeName)",
    "rangeDescription": "updating the testing data"
}
    """
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method PUT
    And json response = response
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Scenario_5_GetRangeById.json')
    Then match response contains deep schema


  Scenario: 7 Delete Range

    Given path '/range/'    +commonData.rangeId
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    And configure readTimeout = 10000
    When method DELETE
    Then status 204
    And print 'Response:', response











