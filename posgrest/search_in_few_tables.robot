*** Settings ***
Resource        resource.robot
Test Setup      Test Setup
Test Teardown   Test Teardown
*** Test Cases ***
Check selection from few tables
   ${resp}      Req.GET On Session     alias    /orders?      params=select=totalamount,customer:fk_customerid(firstname,lastname)&totalamount=gt.430
    ${firstname list}   get elements   ${resp.json()}    $..firstname
    ${lastname list}      get elements   ${resp.json()}    $..lastname
    ${totalamount}     get elements   ${resp.json()}    $..totalamount

    ${params}    create dictionary           totalamount=430
    ${SQL}   set variable       SELECT firstname, lastname, totalamount from bootcamp.customers c join bootcamp.orders o on c.customerid=o.customerid where totalamount > %(totalamount)s
    @{result}    DB.Execute Sql String Mapped    ${SQL}     &{params}

    ${firstname list db}       create list
    ${lastname list db}        create list
    ${totalamount list db}         create list


    FOR   ${row}  IN  @{result}
        log      ${row}
        ${totalamount value from db}   convert to number  ${row}[totalamount]
        Col.Append To List   ${totalamount list db}       ${totalamount value from db}
        Col.Append To List   ${firstname list db}         ${row}[firstname]
        Col.Append To List   ${lastname list db}         ${row}[lastname]
    END

     Col.Lists Should Be Equal    ${totalamount list db}     ${totalamount}
     Col.Lists Should Be Equal      ${firstname list db}      ${firstname list}
     Col.Lists Should Be Equal      ${lastname list db}       ${lastname list}

*** Keywords ***
Test Setup
    Req.Create session            alias       http://localhost:3000
    DB.Connect To Postgresql      hadb    authenticator   mysecretpassword    localhost  8432   db1
Test Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql