Feature: TEST4 sample karate test script - Rohan PARALLEL Testing

  Background: 
  
    * url 'https://jsonplaceholder.typicode.com'
    * def functions = Java.type('examples.users.customDefs')
    * def DbUtils = Java.type('examples.users.DbUtils')



  Scenario: 1 Calling a Simple REST API endpoint

    * def config = {username: 'etladmin', password: 'etlPassword', url: 'jdbc:mysql://wickes-dcapps-etl-preprod-rds-mysql.ctdle1i6zxs5.eu-west-1.rds.amazonaws.com', driverClassName: 'com.mysql.jdbc.Driver'}
    * def db = new DbUtils(config)
    * def value = db.readValue("SELECT etl_job_id FROM EtlDb.etl_job_state WHERE etl_job_id='hdx-to-by-forecast'")
    Then print 'value is : ', value



    Given url 'https://api.agify.io/?name=bella'
    When method GET
    And print 'Response:', response
    Then status 200
    Then match response.name == 'bella'
    And json count = response.count
    Then match count == '#regex[0-9]{5}'
    #Then match count == '#regex [A-Za-z0-9]{25}'


  Scenario:2 Generate alphaNumeric string and amend the JSON payload
    Given def payload =
     """
      {
        "name": "Test User",
        "username": "testuser",
        "email": "test@user.com",
        "address": {
          "street": "2 Kenton Close",
          "suite": "Apt. 123",
          "city": "Bracknell",
          "county" : "Berkshire",
          "zipcode": "RG1RG129AZ29AZ"
        }
      }
      """
      
    Given def random_number = functions.getAlphaNumericString(7)
    And set payload.address.zipcode = random_number
    And print payload


  Scenario:3 Fuzzy Matching / Markers for schema validations
    Given def payload =
      """
      {
        "name": "Test User",
        "username": "testuser",
        "email": "test@user.com",
        "address": {
        "doorNo":2,
          "street": "Kenton Close",
          "landmark": true,
          "city": "Bracknell",
          "county" : "Berkshire",
          "zipcode": "RG129AZ"
        }
      }
      """
    * def schema =
      """{
        "name": "#string",
        "username": "#string",
        "email": "#present",
      }
      """

    And match payload == '#(schema)'
    And match payload.address.street == 'Kenton Close'


Scenario: 4  Embedded Javascript functions

  * def date = { month: 3 }
  * def min = 1
  * def max = 12
  * match date == { month: '#? _ >= min && _ <= max' }

  * def date = { month: 3 }
  * def isValidMonth = function(m) { return m >= 0 && m <= 12 }
  * match date == { month: '#? isValidMonth(_)' }

Scenario: 5 Reading file from the directory

  Given def fileContents = read('myFile.txt' )
  Then print fileContents


