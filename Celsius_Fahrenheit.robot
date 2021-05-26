*** Keywords ***
Celsius to Fahrenheit
#(t°C × 9/5) + 32 = t°F
    [Arguments]   ${tC}
    ${result}=  Evaluate   (${tC}*9/5)+32
    Log     Celsius ${tC} conversion to Fahrenheit=${result}
    [return]  ${result}

*** Test Cases ***
Celsius to Fahrenheit conversion
    ${result}=       Celsius to Fahrenheit      0
    Should Be Equal As Numbers    32              ${result}      wrong conversion
    ${result}=       Celsius to Fahrenheit      350
    Should Be Equal As Numbers    662              ${result}     wrong conversion
    ${result}=       Celsius to Fahrenheit      -32
    Should Be Equal As Numbers    -25.6             ${result}      wrong conversion
    ${result}=       Celsius to Fahrenheit      100
    Should Be Equal As Numbers       212           ${result}         wrong conversion
