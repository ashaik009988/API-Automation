Feature:Wickes Colleague service positive flow

  Background:

    * url 'https://colleague-api.services.preprod.wickes.systems/colleague/v1'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 Get Retrieve absence data from a particular date( 400 bad request- without mandatory field)

    Given path '/absence'
    And params { fromDate: '#(commonData.fromDate)'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response
    Then match $.responseCode == 'typeMismatch'
    Then match $.fieldErrors[0].fieldName == 'limit'
    Then match $.fieldErrors[0].message == 'Mandatory input/s missing'

  Scenario: 2 Get Retrieve absence data from a particular date ( 404 not found- invalid url)

    Given path 'bsence'
    And params { limit: '5'}
    And params { fromDate: '#(commonData.fromDate)'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response
    Then match $.message == 'No message available'
    Then match $.path == '/colleague/v1/bsence'

  Scenario: 3 Get Retrieve Colleague data

    Given path '/'
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response
    Then match $.status == 'Missing Employee Id or email : Atleast one value must be provided'

  Scenario: 4 Get Retrieve Colleague data (404 not found, invalid params passed)

    Given path '/'
    And params { employeeId : 'test'}
    And params { email: 'test'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response
    Then match $.status == 'No record found'

  Scenario: 5 Get Colleague paged (400 bad request invalid params)

    Given path '/paged'
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 400
    And print 'Response:', response
    Then match $.message == 'Mandatory input/s missing'

  Scenario: 6 Get Colleague paged (404 invalid url)

    Given path 'aged'
    And params { limit: '5'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 404
    And print 'Response:', response






