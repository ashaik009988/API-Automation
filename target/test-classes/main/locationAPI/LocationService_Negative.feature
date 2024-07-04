Feature:Wickes location service Negative flow

  Background:

    * url 'https://location-api.preprod.wickes.systems'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)


  Scenario: 1 Get a specific open store ( 404 - without passing the locationnumber)

    Given path '/store/' + commonData.locationNumbers
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response


  Scenario: 2 Get list of all location ranges ( 401- x-api key is not passed)

    Given path '/range'
    When method GET
    And json response = response
    Then status 401
    And print 'Response:', response
    Then match $.message == 'Unauthorized'

  Scenario: 3 Post create Range ( 401- x-api key is not passed)
    * set commonData.rangeName = functions.gettherangename()
    * def writeToCommonData = functions.write(commonData)

    Given path '/range'
    When request
    """
    {
    "rangeName": "#(commonData.rangeName)",
    "rangeDescription": "testing the data"
}
    """

    When method POST
    Then status 401
    And print 'Response:', response
    Then match $.message == 'Unauthorized'


  Scenario: 4 Get range by ID (404 - by passing the invalid/deleted randid)

    Given path '/range/7a98cecb-f677-44f0-af13-a4e0c790838a'
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    And print 'Response:', response
    Then status 404
    Then match $.message == 'Range with Id 7a98cecb-f677-44f0-af13-a4e0c790838a was not found'


  Scenario: 5 updateRange ( 401- x-api key is not passed)

    Given path '/range/'    +commonData.rangeId
    When request
    """
    {
    "rangeName": "#(commonData.rangeName)",
    "rangeDescription": "updating the testing data"
}
    """

    When method PUT
    And json response = response
    Then status 401
    And print 'Response:', response
    Then match $.message == 'Unauthorized'


  Scenario: 6 Delete Range ( 404- randId is not passed)

    Given path '/range/'
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    And configure readTimeout = 10000
    When method DELETE
    Then status 404
    And print 'Response:', response
    Then match $.message == 'Path not found'
    Then match $.error == 'NotFoundError'


