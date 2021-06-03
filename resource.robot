*** Settings ***
Library         RequestsLibrary         WITH NAME       Req
Library         PostgreSQLDB            WITH NAME       DB
Library         JsonValidator
Library         Collections             WITH NAME       Col
Library         CustomersOrdersResult   WITH NAME       cor
Library         SqlRequests             WITH NAME       sql
Library         GetDataFromRest         WITH NAME       restapi
Library         JsonParser              WITH NAME       parser
Resource        postgresql_db_keywords.robot
Resource        postgrest_keywords.robot