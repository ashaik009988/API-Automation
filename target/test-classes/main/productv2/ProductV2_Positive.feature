Feature: Wickes ProductV2 Service positive flow

  Background:

    * url 'https://product-service-v2.preprod.wickes.systems'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 Gets V2 product details for multiple skus at the same time

    Given path '/v2/skus/' +commonData.skuIds
    And header x-api-key = 'DaDTPMAyGp1i3uhx6GNEi87IRjVj66211NHaxDx2'
    When method GET
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Schema_1_GetsV2productdetailsformultipleskusatthesametime.json')
    Then match response contains deep schema


  Scenario: 2 Gets V2 product details for a single sku by its GTIN

    Given path '/v2/sku/gtin/' +commonData.gtin
    And header x-api-key = 'DaDTPMAyGp1i3uhx6GNEi87IRjVj66211NHaxDx2'
    When method GET
    Then status 200
    And print 'Response:', response
    * json schema = read('schema/Schema_2_GetsV2productdetailsforasingleskubyitsGTIN.json')
    Then match response contains deep schema