Feature: Wickes Sales Service

  Scenario:

    * def users = function(i){ return karate.call("SalesService.GeneratingRecords.feature")}
    * def usersResult = karate.repeat(10, users )