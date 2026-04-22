*** Settings ***
Documentation    Global configuration — edit this file to point at a new project.

*** Variables ***
# --- Target Site ---
${BASE_URL}              https://demoqa.com
${FORM_URL}              ${BASE_URL}/automation-practice-form

# --- Browser ---
${BROWSER}               chrome
${HEADLESS}              False
${WINDOW_WIDTH}          1920
${WINDOW_HEIGHT}         1080

# --- Timeouts ---
${IMPLICIT_WAIT}         10s
${PAGE_LOAD_TIMEOUT}     30s
${ELEMENT_TIMEOUT}       15s

# --- API ---
${API_BASE_URL}          https://restful-booker.herokuapp.com
