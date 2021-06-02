*** Settings ***
Resource        resource.robot
Test Setup      Test Setup
Test Teardown   Test Teardown
*** Keywords ***
Test Setup
    Req.Create session            checkChangesSession       http://localhost:3000
    DB.Connect To Postgresql      hadb    authenticator   mysecretpassword    localhost  8432   db1


Test Teardown

    Req.Delete All Sessions
    DB.Disconnect From Postgresql

Insert data in table and check response code (POST)
    ${body}=         create dictionary          category=21    categoryname=TestCategory
    ${header}=       create dictionary          Content-Type=application/json
    ${response}=      Req.POST On Session     checkChangesSession        /categories?      params=columns=category,categoryname
     ...  json=${body}        headers=${header}     expected_status=201

*** Test Cases ***
Check data changes in category table
    Insert data in table and check response code (POST)

    ${resp}      Req.GET On Session     checkChangesSession    /categories?     params=category=eq.21&categoryname=eq.TestCategory
    ${category}   get elements   ${resp.json()}    $..category
    ${categoryname}     get elements   ${resp.json()}    $..categoryname

    ${params}    create dictionary    category=21     categoryname=TestCategory
    ${SQL}       set variable         select category, categoryname from bootcamp.categories where category=%(category)s
    ${result list}    DB.Execute Sql String Mapped   ${SQL}   &{params}
    should not be empty  ${result list}
    ${category value}   convert to number  21

    ${excpected result }=         create dictionary          category=${category value}     categoryname=TestCategory
    ${expected result list}  create list     ${excpected result }

    lists should be equal   ${result list}       ${expected result list}        ожидаемый результат не совпадает с действительным


Delete and check data from previous request (DELETE)
    ${resp}      Req.DELETE On Session     checkChangesSession    /categories?     params=category=eq.21&categoryname=eq.TestCategory
    ...  expected_status=204

    ${params}    create dictionary    category=21     categoryname=TestCategory
    ${SQL}       set variable         select category, categoryname from bootcamp.categories where category=%(category)s
    ${result list}    DB.Execute Sql String Mapped   ${SQL}   &{params}

    Should be empty        ${result list}           значение не удалено

