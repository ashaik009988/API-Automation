Feature: Wickes stockAdjustment Service

  Background:

    * url 'https://stock-adjustment-api.services.preprod.wickes.systems/stock-adjustment/v1'
    * def functions = Java.type('main.CustomDefs')
    * def featureName = karate.feature.fileName
    * json commonData = functions.readCommonData(featureName)

  Scenario: 1 Post Update stock adjustment data
    * set commonData.adjustmentTypeDescription = functions.getRangeName()
    * def writeToCommonData = functions.write(commonData)

    Given path '/'
    When request
    """
{
    "locationNumber": "#(commonData.locationNumber)",
    "adjustment": [
        {
            "SKU": "100412",
            "masterStockAdj": "200",
            "storeStockAdj": "10",
            "adjustmentTypeDescription": "#(commonData.rangeName)"
        },
        {
            "SKU": "104650",
            "masterStockAdj": "201",
            "storeStockAdj": "-10"
        }
    ]
}
    """
    When method POST
    And print 'Response:', response
    Then status 202

