*** Settings ***
Documentation  Набор кейвордов для работы с postgres
Resource     resource.robot
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
     restapi.post_data_to_rest       alias=${session}    url=/categories?    params=columns=category,categoryname
     ...    jsonData=${body}        headers=${header}

Get data from category table with postgrest
     ${json}  restapi.get data from rest      alias=${session}    url=/categories?       params=category=eq.21&categoryname=eq.TestCategory
     ${category}        ${categoryname}          parser.get_category_categoryname       data=${json}
    [return]        ${category}     ${categoryname}

Get data from customers and orders tables with postgrest
    ${json}  restapi.get data from rest        alias=${session}     url=/orders?        params=select=totalamount,customer:fk_customerid(firstname,lastname)&totalamount=gt.430
    ${firstname list}     ${lastname list}      ${totalamount}       parser.get_firstname_lastname_totalamount      data=${json}
    [return]          ${firstname list}        ${lastname list}      ${totalamount}

Category and categoryname should be as expected
    [Arguments]     ${category}     ${categoryname}
    ${category value}   convert to number  21

    ${excpected category list }        create list  ${category value}
    ${expected categoryname list}       create list    TestCategory

    lists should be equal    ${category}    ${excpected category list }           ожидаемый результат не совпадает с действительным
    lists should be equal    ${categoryname}    ${expected categoryname list}          ожидаемый результат не совпадает с действительным

Delete and check data from previous request (DELETE)
    restapi.delete data from rest     alias=${session}     url=/categories?    params=category=eq.21&categoryname=eq.TestCategory
    ${result list}      sql.get_category_and_catygoryname_from_categories   category=${21}      categoryname=TestCategory
    Should be empty        ${result list}           значение не удалено