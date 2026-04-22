*** Settings ***
Documentation    UI test — fills the DemoQA Practice Form with data from form_data.csv.
...
...              When to use this approach:
...                - Run the same form flow with many different data combinations
...                - Each row in the CSV becomes one test case automatically
...                - Add a row to the CSV to add a new test — no code change needed
...
...              Run command (from DemoQA_Boilerplate folder):
...                robot --outputdir results tests/ui/test_form_datadriven.robot

Library          SeleniumLibrary
Library          DataDriver
...              file=${CURDIR}/../../resources/testdata/form_data.csv
...              encoding=utf-8
...              dialect=unix
Resource         ../../resources/keywords/CommonKeywords.robot
Resource         ../../resources/page_objects/PracticeFormPage.robot

Suite Setup      Open Browser To URL
Suite Teardown   Close Browser Session
Test Setup       Go To    ${FORM_URL}
Test Teardown    Run Keyword If Test Failed    Capture Screenshot On Failure
Test Template    Submit Form From CSV Row

# DataDriver reads form_data.csv and turns every data row into a test case.
# The template keyword below is called once per row with that row's values.
*** Test Cases ***
Practice Form Data Driven

*** Keywords ***
Submit Form From CSV Row
    [Arguments]
    ...    ${first_name}=${EMPTY}    ${last_name}=${EMPTY}    ${email}=${EMPTY}
    ...    ${gender}=${EMPTY}        ${mobile}=${EMPTY}
    ...    ${dob_day}=${EMPTY}       ${dob_month}=${EMPTY}    ${dob_year}=${EMPTY}
    ...    ${subjects}=${EMPTY}      ${hobbies}=${EMPTY}
    ...    ${address}=${EMPTY}       ${state}=${EMPTY}        ${city}=${EMPTY}
    Fill Complete Form
    ...    ${first_name}    ${last_name}    ${email}    ${gender}    ${mobile}
    ...    ${dob_day}    ${dob_month}    ${dob_year}
    ...    ${subjects}    ${hobbies}
    ...    ${address}    ${state}    ${city}
    Submit Form
    Verify Form Submitted Successfully
