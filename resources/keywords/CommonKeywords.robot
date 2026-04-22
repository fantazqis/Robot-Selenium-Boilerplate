*** Settings ***
Documentation    Generic browser and UI helpers reusable across all page objects.
Library          SeleniumLibrary
Library          String
Library          OperatingSystem
Library          DateTime
Resource         ../../config/settings.robot

*** Keywords ***

# ── Browser lifecycle ──────────────────────────────────────────────────────────

Open Browser To URL
    [Documentation]    Open Chrome (headless optional) and navigate to the given URL.
    [Arguments]    ${url}=${FORM_URL}
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-popup-blocking
    IF    '${HEADLESS}' == 'True'
        Call Method    ${options}    add_argument    --headless=new
    END
    Open Browser    ${url}    ${BROWSER}    options=${options}
    Set Window Size              ${WINDOW_WIDTH}    ${WINDOW_HEIGHT}
    Set Selenium Implicit Wait   ${IMPLICIT_WAIT}
    Set Selenium Page Load Timeout    ${PAGE_LOAD_TIMEOUT}
    Set Selenium Timeout         ${ELEMENT_TIMEOUT}

Close Browser Session
    [Documentation]    Close the browser. Screenshot on failure is handled by Test Teardown in each test file.
    Close Browser

# ── Basic interactions ─────────────────────────────────────────────────────────

Input Text To Field
    [Documentation]    Clear the field then type text.
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    ${ELEMENT_TIMEOUT}
    Clear Element Text               ${locator}
    Input Text                       ${locator}    ${text}

Click Element With Wait
    [Documentation]    Wait for visibility and enabled state, then click.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${ELEMENT_TIMEOUT}
    Wait Until Element Is Enabled    ${locator}    ${ELEMENT_TIMEOUT}
    Click Element                    ${locator}

Select Radio By Label
    [Documentation]    Click a radio button by clicking its visible label text.
    [Arguments]    ${label_text}
    Click Element    xpath://label[normalize-space(text())='${label_text}']

Toggle Checkbox By Label
    [Documentation]    Click a checkbox by clicking its visible label text.
    [Arguments]    ${label_text}
    Click Element    xpath://label[normalize-space(text())='${label_text}']

Scroll To Element
    [Documentation]    Scroll element into the viewport.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${ELEMENT_TIMEOUT}
    Scroll Element Into View         ${locator}

# ── Assertions ─────────────────────────────────────────────────────────────────

Page Should Show Text
    [Documentation]    Assert that a text string is visible anywhere on the page.
    [Arguments]    ${text}
    Page Should Contain    ${text}

Element Text Should Be
    [Documentation]    Assert that an element contains an exact text value.
    [Arguments]    ${locator}    ${expected_text}
    Element Should Contain    ${locator}    ${expected_text}

# ── Failure handling ───────────────────────────────────────────────────────────

Capture Screenshot On Failure
    [Documentation]    Save a timestamped screenshot into the results/screenshots folder.
    ${timestamp}=      Get Current Date    result_format=%Y%m%d_%H%M%S
    ${clean_name}=     Replace String    ${TEST NAME}    ${SPACE}    _
    ${screenshot_dir}=    Set Variable    ${OUTPUT DIR}/screenshots
    Create Directory      ${screenshot_dir}
    Capture Page Screenshot    ${screenshot_dir}/FAIL_${clean_name}_${timestamp}.png
