*** Settings ***
Documentation    UI test — fills the DemoQA Practice Form with hardcoded (static) data.
...
...              When to use this approach:
...                - Quick smoke check with one known-good dataset
...                - Debugging a specific scenario
...                - Demos / onboarding
...
...              Run command (from DemoQA_Boilerplate folder):
...                robot --outputdir results tests/ui/test_form_static.robot

Library          SeleniumLibrary
Resource         ../../resources/keywords/CommonKeywords.robot
Resource         ../../resources/page_objects/PracticeFormPage.robot

Suite Setup      Open Browser To URL
Suite Teardown   Close Browser Session
Test Setup       Go To    ${FORM_URL}
Test Teardown    Run Keyword If Test Failed    Capture Screenshot On Failure

# ── Static test data — edit here to change what gets submitted ────────────────
*** Variables ***
${FIRST_NAME}       John
${LAST_NAME}        Doe
${EMAIL}            john.doe@test.com
${GENDER}           Male
${MOBILE}           0812345678
${DOB_DAY}          15
${DOB_MONTH}        January
${DOB_YEAR}         1990
${SUBJECTS}         Maths
${HOBBIES}          Sports
${ADDRESS}          100 Automation Test Street, Test City
${STATE}            NCR
${CITY}             Delhi

*** Test Cases ***
TC_UI_STATIC_01 - Submit Practice Form With Static Data
    [Documentation]    Fill every field with the variables defined above and verify the success modal.
    [Tags]             UI    SMOKE    FORM    STATIC
    Fill Complete Form
    ...    ${FIRST_NAME}    ${LAST_NAME}    ${EMAIL}    ${GENDER}    ${MOBILE}
    ...    ${DOB_DAY}    ${DOB_MONTH}    ${DOB_YEAR}
    ...    ${SUBJECTS}    ${HOBBIES}
    ...    ${ADDRESS}    ${STATE}    ${CITY}
    Submit Form
    Verify Form Submitted Successfully

TC_UI_STATIC_02 - Submit Form With Multiple Subjects And Hobbies
    [Documentation]    Semicolons separate multiple subjects/hobbies.
    [Tags]             UI    FORM    STATIC
    Fill Complete Form
    ...    Alex    Johnson    alex.j@test.com    Other    0821234567
    ...    5    March    1995
    ...    Computer Science;Physics    Sports;Music
    ...    300 Test Boulevard    Rajasthan    Jaipur
    Submit Form
    Verify Form Submitted Successfully
