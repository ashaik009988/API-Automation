Feature:Wickes Colleague service positive flow

  Background:

    * url 'https://colleague-api.services.preprod.wickes.systems/colleague/v1'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)


  Scenario: 1 Get Retrieve absence data from a particular date

    Given path '/absence'
    And params { limit: '5'}
    And params { fromDate: '#(commonData.fromDate)'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json baseSchema = read('schema/baseSchema.json')
    * json schema = read('schema/Scenario_1_GET_RetrieveAbsenceData.json')
    Then match response contains deep schema


  Scenario: 2 Get Retrieve Colleague data

    Given path '/'
    And params { employeeId : '342456'}
    And params { email: 'andrei.birsan.asc@wickes.co.uk'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json baseSchema = read('schema/baseSchema.json')
    * json schema = read('schema/Scenario_2_GET_RetrieveColleagueData.json')
    Then match response contains deep schema


  Scenario: 3 Get Colleague paged

    Given path '/paged'
    And params { limit: '5'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json baseSchema = read('schema/baseSchema.json')
    * json schema = read('schema/Scenario_3_GET_ColleaguePaged.json')
    Then match response contains deep schema

  Scenario: 4 Get Colleague paged

    Given path '/paged'
    And params { limit: '5'}
    And params { lastUpdatedTime: '2023-09-28T00:00:00.000'}
    And header x-api-key = 'XbugH2HdfG3q7U3qdwUkx3XYmDMHEse52mAWA7WU'
    When method GET
    And json response = response
    Then status 200
    And print 'Response:', response
    * json baseSchema = read('schema/baseSchema.json')
    * json schema = read('schema/Scenario_3_GET_ColleaguePaged.json')
    Then match response contains deep schema
