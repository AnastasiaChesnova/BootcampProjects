*** Settings ***
Documentation   Сьют позитивных тестов, проверяющих работу изменения данных через postgrest
Metadata        Автор       Чеснова Анастасия
Force Tags      positive
Resource        resource.robot
Test Timeout    10s
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Keywords ***
Test Setup
    Create postgrest session
    Connect to local postgresql db    hadb

Test Teardown
    Delete and check data from previous request (DELETE)
    Close postgrest session
    Disconnect From Postgresql
*** Test Cases ***
Check data changes in category table with postgrest
    [Documentation]     Проверка изменения данных в таблице category через postgrest
    [Tags]          postgrest        db
    Insert data in table and check response code (POST)
    ${category}     ${categoryname}   Get data from category table with postgrest
    Category and categoryname should be as expected    ${category}     ${categoryname}


Check data changes in category table with SQL
    [Documentation]     Проверка изменения данных в таблице category через SQL запрос
    [Tags]          sql        db
    Insert data in table and check response code (POST)
    ${result list}      Get data from category table with SQL
    SQL response should be as expected     ${result list}