*** Settings ***
Documentation   Набор кейвордов для тестов с взаимодействием с postgresql
Resource     resource.robot
*** Variables ***
${postgrest_URL}        http://localhost:3000
${db_login}         authenticator
${db_password}      mysecretpassword
${db_host}          localhost
${db_port}          8432
${connection_id}      db1
*** Keywords ***
Connect to local postgresql db
    [arguments]  ${database}
   DB.Connect To Postgresql      ${database}    ${db_login}   ${db_password}    ${db_host}  ${db_port}     ${connection_id}
Disconnect From Postgresql
    DB.Disconnect From Postgresql

Get data from category table with SQL
      ${result list}      sql.get_category_and_catygoryname_from_categories       category=${21}          categoryname=TestCategory
      should not be empty  ${result list}
      [return]      ${result list}

Get data from customers and orders tables with sql
     ${result}  sql.get_firstname_lastname_totalamount_from_customers_and_orders_with_totalamounts_greater_than_430    totalamount=${430}
    ${firstname list db}    ${lastname list db}  ${totalamount list db}      cor.get result to firstname lastname and total amount list      ${result}

    [return]   ${firstname list db}         ${lastname list db}        ${totalamount list db}

SQL response should be as expected
    [Arguments]     ${result list}
    ${category value}   convert to number  21
    ${excpected result }=         create dictionary          category=${category value}     categoryname=TestCategory
    ${expected result list}  create list     ${excpected result }
    lists should be equal   ${result list}       ${expected result list}        ожидаемый результат не совпадает с действительным