*** Settings ***
Library    Collections

*** Variables ***
@{NUMBER ROW}             1  2  3  5  1  0  -1  10
@{NUMBER AND STRING ROW}    1  2  3  5  1   string  0  string   -1  10  alsoString

*** Keywords ***

Select only numbers
#отбирает только числа из списка
    [Arguments]   ${list}
    ${result}=  Create List

    FOR     ${item}   IN  @{list}
        ${status}  ${item int}=    Run Keyword And Ignore Error    Convert To Number    ${item}
        ${isnumber}=  Run Keyword And Return Status    Should Be Equal As Strings    ${status}   PASS
        Run Keyword If   ${isnumber}  Append To List       ${result}   ${item int}

    END
    [return]  ${result}

Find max
    [Arguments]   ${list}
    ${filtered list}    Select only numbers    ${list}
    Should Not Be Empty  ${filtered list}   List should contain numbers
    Log List  ${filtered list}
    ${max}  set variable    ${filtered list}[0]
     FOR  ${item}  IN   @{filtered list}
        ${max}=    set variable if     ${item} > ${max}
        ...     ${item}   ${max}
     END

    [return]  ${max}



Find min
    [Arguments]   ${list}
    ${filtered list}  Select only numbers    ${list}
    Should Not Be Empty  ${filtered list}   List should contain numbers
    ${min}  set variable    ${filtered list}[0]
     FOR  ${item}  IN   @{filtered list}
        ${min}=    set variable if     ${item} < ${min}
        ...     ${item}   ${min}
     END

    [return]  ${min}


Find unique values
    [Arguments]   ${list}

    ${result list}=      Create List
    FOR  ${item}  IN   @{list}
        ${element count}  set variable  0
        FOR  ${current_element}  IN   @{list}
            Log  cur_element=${current_element}
            ${equal}=  Run Keyword And Return Status    Should Be Equal As Strings   ${current_element}  ${item}
            IF  ${equal}
                    ${element count}=   Evaluate  ${element count}+1
            END
        END
        IF   ${element count}==1
            Append To List   ${result list}  ${item}
        END

    END


    [return]      ${result list}

Find sum
    [Arguments]   ${list}

    ${filtered list}  Select only numbers    ${list}
    ${sum}  set variable  0

    FOR  ${item}  IN   @{filtered list}
        ${sum}=     Evaluate  ${item}+${sum}
    END

    [return]  ${sum}


*** Test Cases ***
Find max and min value
    ${list} =    Create List     @{NUMBER ROW}
    ${max} =  Find max  ${list}
    Should Be Equal As Integers   10   ${max}   value is not max

    ${min} =  Find min  ${list}
    Should Be Equal As Integers   -1   ${min}   value is not min

Find max and min in empty row
    ${empty list} =    Create List
    Run Keyword And Expect Error    List should contain numbers    Find max      ${empty list}
    Run Keyword And Expect Error    List should contain numbers     Find min      ${empty list}

Find max and min value with Strings in the row
    ${list} =    Create List    @{NUMBER AND STRING ROW}
    ${max} =  Find max  ${list}
    Should Be Equal As Integers   10   ${max}   value is not max

    ${min} =  Find min  ${list}
    Should Be Equal As Integers   -1   ${min}   value is not min

Find sum of all numders in the row
   ${list} =    Create List     @{NUMBER ROW}
   ${sum} =  Find sum   ${list}
   Should Be Equal As Integers   21   ${sum}    sum incorrectly calculated

Find sum of all numders with Strings in the row
   ${list} =    Create List      @{NUMBER AND STRING ROW}
   ${sum} =  Find sum   ${list}
   Should Be Equal As Integers   21   ${sum}    sum incorrectly calculated

Find unique values in the row
    ${list} =    Create List     @{NUMBER ROW}
    ${result list}=    Find unique values   ${list}
    ${expected list}=      Create List      2   3  5  0  -1   10
    Lists Should Be Equal      ${result list}      ${expected list}     Values is not unique

Find unique values with Strings in the row
    ${list} =    Create List     @{NUMBER AND STRING ROW}
    ${result list}=    Find unique values   ${list}
    ${expected list}=      Create List      2   3  5  0  -1   10   alsoString
    Lists Should Be Equal      ${result list}      ${expected list}     Values is not unique