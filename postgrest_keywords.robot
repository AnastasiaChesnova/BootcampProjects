*** Variables ***
${session}  checkChangesSession

*** Keywords ***
Create postgrest session
    Req.Create session            checkChangesSession       ${postgrest_URL}

Close postgrest session
    Req.Delete All Sessions

Insert data in table and check response code (POST)
    ${body}=         create dictionary          category=21    categoryname=TestCategory
    ${header}=       create dictionary          Content-Type=application/json
    ${response}=      Req.POST On Session     ${session}        /categories?      params=columns=category,categoryname
     ...  json=${body}        headers=${header}     expected_status=201

Get data from category table with postgrest
    ${resp}      Req.GET On Session     ${session}    /categories?     params=category=eq.21&categoryname=eq.TestCategory
    ${category}   get elements   ${resp.json()}    $..category
    ${categoryname}     get elements   ${resp.json()}    $..categoryname
    should not be empty     ${category}
    should not be empty     ${categoryname}
    [return]        ${category}     ${categoryname}

Get data from customers and orders tables with postgrest
   ${resp}      Req.GET On Session     ${session}    /orders?      params=select=totalamount,customer:fk_customerid(firstname,lastname)&totalamount=gt.430
    ${firstname list}   get elements   ${resp.json()}    $..firstname
    ${lastname list}      get elements   ${resp.json()}    $..lastname
    ${totalamount}     get elements   ${resp.json()}    $..totalamount
    [return]          ${firstname list}        ${lastname list}      ${totalamount}

Category and categoryname should be as expected
    [Arguments]     ${category}     ${categoryname}
    ${category value}   convert to number  21

    ${excpected category list }        create list  ${category value}
    ${expected categoryname list}       create list    TestCategory

    lists should be equal    ${category}    ${excpected category list }           ожидаемый результат не совпадает с действительным
    lists should be equal    ${categoryname}    ${expected categoryname list}          ожидаемый результат не совпадает с действительным

Delete and check data from previous request (DELETE)
    ${resp}      Req.DELETE On Session     ${session}    /categories?     params=category=eq.21&categoryname=eq.TestCategory
    ...  expected_status=204

    ${params}    create dictionary    category=21     categoryname=TestCategory
    ${SQL}       set variable         select category, categoryname from bootcamp.categories where category=%(category)s
    ${result list}    DB.Execute Sql String Mapped   ${SQL}   &{params}

    Should be empty        ${result list}           значение не удалено