*** Settings ***
Documentation    Page Object for https://demoqa.com/automation-practice-form.
...              Contains all locators and page-level keywords for the practice form.
Library          SeleniumLibrary
Library          String
Library          ../../libraries/FormHelper.py
Resource         ../../config/settings.robot
Resource         ../keywords/CommonKeywords.robot

*** Variables ***
# ── Personal Info ──────────────────────────────────────────────────────────────
${FLD_FIRST_NAME}           id:firstName
${FLD_LAST_NAME}            id:lastName
${FLD_EMAIL}                id:userEmail
${FLD_MOBILE}               id:userNumber

# ── Date of Birth ──────────────────────────────────────────────────────────────
${FLD_DOB}                  id:dateOfBirthInput

# ── Subjects autocomplete ──────────────────────────────────────────────────────
${FLD_SUBJECTS}             id:subjectsInput

# ── File Upload ────────────────────────────────────────────────────────────────
${BTN_UPLOAD_PICTURE}       id:uploadPicture

# ── Address ────────────────────────────────────────────────────────────────────
${FLD_ADDRESS}              id:currentAddress

# ── State / City React-Select ─────────────────────────────────────────────────
${DDL_STATE_ID}             state
${DDL_CITY_ID}              city

# ── Submit ─────────────────────────────────────────────────────────────────────
${BTN_SUBMIT}               id:submit

# ── Success modal ──────────────────────────────────────────────────────────────
${MDL_TITLE}                id:example-modal-sizes-title-lg
${MDL_SUCCESS_TEXT}         Thanks for submitting the form

*** Keywords ***

# ── Section fillers ────────────────────────────────────────────────────────────

Fill Personal Information
    [Documentation]    Fill Name, Email, Gender radio, and Mobile fields.
    [Arguments]    ${first_name}    ${last_name}    ${email}    ${gender}    ${mobile}
    Input Text To Field    ${FLD_FIRST_NAME}    ${first_name}
    Input Text To Field    ${FLD_LAST_NAME}     ${last_name}
    Input Text To Field    ${FLD_EMAIL}         ${email}
    Select Radio By Label  ${gender}
    Input Text To Field    ${FLD_MOBILE}        ${mobile}

Fill Date Of Birth
    [Documentation]    Set the date-of-birth calendar using the Python helper.
    [Arguments]    ${day}    ${month}    ${year}
    Set Date Of Birth    ${day}    ${month}    ${year}

Fill Subjects
    [Documentation]    Add one or more subjects. Use semicolons to separate multiples: 'Maths;English'.
    [Arguments]    ${subjects}
    IF    '${subjects}' == '${EMPTY}'    RETURN
    @{subject_list}=    Split String    ${subjects}    ;
    FOR    ${subject}    IN    @{subject_list}
        ${subject}=    Strip String    ${subject}
        IF    '${subject}' != '${EMPTY}'
            Add Subject    ${subject}
        END
    END

Fill Hobbies
    [Documentation]    Check one or more hobby checkboxes. Use semicolons to separate multiples: 'Sports;Music'.
    [Arguments]    ${hobbies}
    IF    '${hobbies}' == '${EMPTY}'    RETURN
    @{hobby_list}=    Split String    ${hobbies}    ;
    FOR    ${hobby}    IN    @{hobby_list}
        ${hobby}=    Strip String    ${hobby}
        IF    '${hobby}' != '${EMPTY}'
            Toggle Checkbox By Label    ${hobby}
        END
    END

Upload Picture
    [Documentation]    Upload a file. Leave empty to skip.
    [Arguments]    ${file_path}=${EMPTY}
    IF    '${file_path}' == '${EMPTY}'    RETURN
    Choose File    ${BTN_UPLOAD_PICTURE}    ${file_path}

Fill Address
    [Documentation]    Scroll to the address textarea and type the address.
    [Arguments]    ${address}
    Scroll To Element      ${FLD_ADDRESS}
    Input Text To Field    ${FLD_ADDRESS}    ${address}

Fill State And City
    [Documentation]    Select State then City from React-Select dropdowns.
    [Arguments]    ${state}    ${city}
    Scroll To Element    id:state
    Select React Dropdown    ${DDL_STATE_ID}    ${state}
    Select React Dropdown    ${DDL_CITY_ID}     ${city}

# ── Actions ────────────────────────────────────────────────────────────────────

Submit Form
    [Documentation]    Scroll to submit button and click it.
    Scroll To Element         ${BTN_SUBMIT}
    Click Element With Wait   ${BTN_SUBMIT}

Verify Form Submitted Successfully
    [Documentation]    Assert the success modal appears with the expected title.
    Wait Until Element Is Visible    ${MDL_TITLE}    ${ELEMENT_TIMEOUT}
    Element Should Contain           ${MDL_TITLE}    ${MDL_SUCCESS_TEXT}

# ── Composite ─────────────────────────────────────────────────────────────────

Fill Complete Form
    [Documentation]    Fill every section of the practice form in order.
    [Arguments]
    ...    ${first_name}    ${last_name}    ${email}    ${gender}    ${mobile}
    ...    ${dob_day}    ${dob_month}    ${dob_year}
    ...    ${subjects}    ${hobbies}
    ...    ${address}    ${state}    ${city}
    ...    ${picture}=${EMPTY}
    Fill Personal Information    ${first_name}    ${last_name}    ${email}    ${gender}    ${mobile}
    Fill Date Of Birth           ${dob_day}    ${dob_month}    ${dob_year}
    Fill Subjects                ${subjects}
    Fill Hobbies                 ${hobbies}
    Upload Picture               ${picture}
    Fill Address                 ${address}
    Fill State And City          ${state}    ${city}
