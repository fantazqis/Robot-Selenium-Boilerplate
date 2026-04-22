*** Settings ***
Documentation    API tests — Restful Booker (https://restful-booker.herokuapp.com).
...
...              Covers full CRUD flow: Create → Read → Update → Delete → Verify deleted.
...              Auth token is fetched once in Suite Setup and reused for write operations.
...
...              Fixed credentials: admin / password123 (provided by the practice site).
...
...              Run command (from DemoQA_Boilerplate folder):
...                robot --outputdir results tests/api/test_bookstore_api.robot

Library          RequestsLibrary
Library          Collections
Resource         ../../config/settings.robot

Suite Setup      Setup Booking Suite
Suite Teardown   Delete All Sessions

*** Variables ***
${AUTH_USERNAME}        admin
${AUTH_PASSWORD}        password123
${BOOKING_ENDPOINT}     /booking
${AUTH_ENDPOINT}        /auth

# Placeholder — filled by Suite Setup
${AUTH_TOKEN}           ${EMPTY}
${BOOKING_ID}           ${EMPTY}

*** Test Cases ***
TC_API_01 - Get All Bookings Returns HTTP 200
    [Documentation]    Smoke check: the bookings endpoint is reachable and returns a list.
    [Tags]             API    SMOKE
    ${response}=    GET On Session    booker    ${BOOKING_ENDPOINT}
    Should Be Equal As Integers    ${response.status_code}    200
    ${bookings}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${bookings}

TC_API_02 - Create New Booking Returns Booking ID
    [Documentation]    POST a new booking and store the returned bookingid for later tests.
    [Tags]             API    CRUD
    ${payload}=    Create Dictionary
    ...    firstname=John
    ...    lastname=Doe
    ...    totalprice=${150}
    ...    depositpaid=${True}
    ...    additionalneeds=Breakfast
    ${dates}=    Create Dictionary    checkin=2025-06-01    checkout=2025-06-10
    Set To Dictionary    ${payload}    bookingdates=${dates}
    ${response}=    POST On Session    booker    ${BOOKING_ENDPOINT}
    ...    json=${payload}
    ...    headers=${JSON_HEADERS}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    bookingid
    Set Suite Variable    ${BOOKING_ID}    ${body}[bookingid]
    Log    Created booking with ID: ${BOOKING_ID}

TC_API_03 - Get Created Booking Returns Correct Data
    [Documentation]    GET the booking created in TC_02 and verify its fields.
    [Tags]             API    CRUD
    ${response}=    GET On Session    booker    ${BOOKING_ENDPOINT}/${BOOKING_ID}
    Should Be Equal As Integers    ${response.status_code}    200
    ${booking}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${booking}[firstname]    John
    Should Be Equal As Strings    ${booking}[lastname]     Doe
    Should Be Equal As Numbers    ${booking}[totalprice]   150

TC_API_04 - Update Booking Returns Updated Data
    [Documentation]    PUT updated data to the booking and verify the response reflects the change.
    [Tags]             API    CRUD
    ${payload}=    Create Dictionary
    ...    firstname=Jane
    ...    lastname=Smith
    ...    totalprice=${200}
    ...    depositpaid=${False}
    ...    additionalneeds=Lunch
    ${dates}=    Create Dictionary    checkin=2025-07-01    checkout=2025-07-05
    Set To Dictionary    ${payload}    bookingdates=${dates}
    ${auth_headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${AUTH_TOKEN}
    ${response}=    PUT On Session    booker    ${BOOKING_ENDPOINT}/${BOOKING_ID}
    ...    json=${payload}
    ...    headers=${auth_headers}
    Should Be Equal As Integers    ${response.status_code}    200
    ${updated}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${updated}[firstname]    Jane
    Should Be Equal As Strings    ${updated}[lastname]     Smith

TC_API_05 - Delete Booking Returns HTTP 201
    [Documentation]    DELETE the booking created in TC_02. Restful Booker returns 201 on success.
    [Tags]             API    CRUD
    ${auth_headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Cookie=token=${AUTH_TOKEN}
    ${response}=    DELETE On Session    booker    ${BOOKING_ENDPOINT}/${BOOKING_ID}
    ...    headers=${auth_headers}
    Should Be Equal As Integers    ${response.status_code}    201

TC_API_06 - Deleted Booking Returns HTTP 404
    [Documentation]    Verify the deleted booking is no longer accessible.
    [Tags]             API    NEGATIVE
    ${response}=    GET On Session    booker    ${BOOKING_ENDPOINT}/${BOOKING_ID}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    404

*** Keywords ***
Setup Booking Suite
    [Documentation]    Create HTTP session and fetch auth token used in write operations.
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    Create Session    booker    ${API_BASE_URL}    headers=${headers}    verify=True
    Set Suite Variable    ${JSON_HEADERS}    ${headers}
    # Fetch token
    ${auth_payload}=    Create Dictionary
    ...    username=${AUTH_USERNAME}
    ...    password=${AUTH_PASSWORD}
    ${response}=    POST On Session    booker    ${AUTH_ENDPOINT}    json=${auth_payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Set Suite Variable    ${AUTH_TOKEN}    ${response.json()['token']}
    Log    Auth token acquired: ${AUTH_TOKEN}
