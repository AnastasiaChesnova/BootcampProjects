*** Settings ***
Documentation   Сьют позитивных тестов, проверяющих работу поиска данных из нескольких таблиц через postgrest
Metadata        Автор       Чеснова Анастасия
Force Tags      positive
Resource        resource.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Keywords ***
Test Setup
    Create postgrest session
    Connect to local postgresql db    hadb

Test Teardown
    Close postgrest session
    Disconnect From Postgresql

*** Test Cases ***

Check selection from few tables
    [Documentation]     Проверка поиска данных в таблицах customers and orders через postgrest
    [Tags]          postgrest        db
    ${firstname list}        ${lastname list}      ${totalamount}   Get data from customers and orders tables with postgrest
    ${firstname list db}         ${lastname list db}        ${totalamount list db}    Get data from customers and orders tables with sql
    Col.Lists Should Be Equal    ${totalamount list db}     ${totalamount}
    Col.Lists Should Be Equal      ${firstname list db}      ${firstname list}
    Col.Lists Should Be Equal      ${lastname list db}       ${lastname list}



