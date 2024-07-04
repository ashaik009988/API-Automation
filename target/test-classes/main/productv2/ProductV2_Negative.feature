Feature: Wickes ProductV2 Service Negative flow

  Background:

    * url 'https://product-service-v2.preprod.wickes.systems'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 Gets V2 product details for multiple skus at the same time (404 invalid url)

    Given path '/v2/sku/' +commonData.skuIds
    And header x-api-key = 'DaDTPMAyGp1i3uhx6GNEi87IRjVj66211NHaxDx2'
    When method GET
    Then status 404
    And print 'Response:', response

  Scenario: 2 Gets V2 product details for multiple skus at the same time (403 path variables is not entered)

    Given path '/v2/skus/'
    And header x-api-key = 'DaDTPMAyGp1i3uhx6GNEi87IRjVj66211NHaxDx2'
    When method GET
    Then status 403
    And print 'Response:', response
    Then match $.message == 'Missing Authentication Token'


  Scenario: 3 Gets V2 product details for a single sku by its GTIN (404 invalid url)

    Given path '/v2/sku/gtins/' +commonData.gtin
    And header x-api-key = 'DaDTPMAyGp1i3uhx6GNEi87IRjVj66211NHaxDx2'
    When method GET
    Then status 404
    And print 'Response:', response

  Scenario: 4 Gets V2 product details for a single sku by its GTIN (404, path variable is not entered)

    Given path '/v2/sku/gtin/'
    And header x-api-key = 'DaDTPMAyGp1i3uhx6GNEi87IRjVj66211NHaxDx2'
    When method GET
    Then status 404
    And print 'Response:', response


  Scenario: 5 Gets V2 product details for a single sku by its GTIN- (403- without x api key)

    Given path '/v2/sku/gtin/' +commonData.gtin
    And header x-api-key = ' '
    When method GET
    Then status 403
    And print 'Response:', response
    Then match $.message == 'Forbidden'

