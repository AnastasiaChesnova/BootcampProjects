*** Settings ***
Documentation   Набор кейвордов для тестов с взаимодействием с postgresql
Library    CustomersOrdersResult  WITH NAME   cor
*** Variables ***
${postgrest_URL}        http://localhost:3000
${db_login}         authenticator
${db_password}      mysecretpassword
${db_host}          localhost
${db_port}          8432
*** Keywords ***
Connect to postgres db
    [arguments]  ${database}
    DB.Connect To Postgresql      ${database}    ${db_login}   ${db_password}    ${db_host}  ${db_port}
Disconnect From Postgresql
    DB.Disconnect From Postgresql

Get data from category table with SQL
      ${params}    create dictionary    category=21     categoryname=TestCategory
      ${SQL}       set variable         select category, categoryname from bootcamp.categories where category=%(category)s
      ${result list}    DB.Execute Sql String Mapped   ${SQL}   &{params}
      should not be empty  ${result list}
      [return]      ${result list}

Get data from customers and orders tables with sql
    ${params}    create dictionary           totalamount=430
    ${SQL}   set variable       SELECT firstname, lastname, totalamount from bootcamp.customers c join bootcamp.orders o on c.customerid=o.customerid where totalamount > %(totalamount)s
    ${result}    DB.Execute Sql String Mapped    ${SQL}     &{params}
    ${firstname list db}    ${lastname list db}  ${totalamount list db}      cor.get result to firstname lastname and total amount list      ${result}

    [return]   ${firstname list db}         ${lastname list db}        ${totalamount list db}

SQL response should be as expected
    [Arguments]     ${result list}
    ${category value}   convert to number  21
    ${excpected result }=         create dictionary          category=${category value}     categoryname=TestCategory
    ${expected result list}  create list     ${excpected result }
    lists should be equal   ${result list}       ${expected result list}        ожидаемый результат не совпадает с действительным