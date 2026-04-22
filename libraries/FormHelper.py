"""
FormHelper.py — Python keyword library for complex UI interactions.

Handles elements that SeleniumLibrary keywords cannot manage easily:
  - React-Select dropdowns (State, City)
  - react-datepicker (Date of Birth)
  - Subjects autocomplete input
"""

import time

from robot.api.deco import library, keyword
from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select, WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@library(scope="SUITE")
class FormHelper:

    def __init__(self):
        self._selenium = None

    @property
    def _driver(self):
        if self._selenium is None:
            self._selenium = BuiltIn().get_library_instance("SeleniumLibrary")
        return self._selenium.driver

    # ------------------------------------------------------------------
    # React-Select (State / City dropdowns)
    # ------------------------------------------------------------------

    @keyword
    def select_react_dropdown(self, container_id: str, option_text: str):
        """Click a React-Select dropdown and choose an option by exact text.

        Args:
            container_id: The ID of the wrapper element, e.g. 'state' or '#state'.
            option_text:  The visible text of the option to select, e.g. 'NCR'.
        """
        driver = self._driver
        bare_id = container_id.lstrip("#")

        # Open the dropdown
        driver.find_element(By.ID, bare_id).click()
        time.sleep(0.4)

        # React-Select assigns IDs like "react-select-3-option-0" to option divs.
        # We find the visible option whose text exactly matches.
        option_xpath = (
            "//div["
            "  starts-with(@id,'react-select')"
            "  and contains(@id,'-option')"
            "  and not(contains(@class,'is-disabled'))"
            f" and normalize-space(text())='{option_text}'"
            "]"
        )
        option = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, option_xpath))
        )
        option.click()

    # ------------------------------------------------------------------
    # react-datepicker (Date of Birth)
    # ------------------------------------------------------------------

    @keyword
    def set_date_of_birth(self, day: str, month: str, year: str):
        """Set the Date of Birth field using the react-datepicker calendar.

        Args:
            day:   Day as string, e.g. '15'.
            month: Full month name, e.g. 'January'.
            year:  Four-digit year as string, e.g. '1990'.
        """
        driver = self._driver

        # Open the calendar
        date_input = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "dateOfBirthInput"))
        )
        date_input.click()
        time.sleep(0.3)

        # Select month via the <select> dropdown inside the calendar header
        month_select = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located(
                (By.CLASS_NAME, "react-datepicker__month-select")
            )
        )
        Select(month_select).select_by_visible_text(month)

        # Select year via the <select> dropdown
        year_select = driver.find_element(
            By.CLASS_NAME, "react-datepicker__year-select"
        )
        Select(year_select).select_by_visible_text(str(year))

        # Click the correct day — exclude "outside-month" ghost days
        day_int = int(day)
        day_xpath = (
            f"//div["
            f"  contains(@class,'react-datepicker__day')"
            f"  and not(contains(@class,'outside-month'))"
            f"  and not(contains(@class,'keyboard-selected'))"
            f"  and normalize-space(text())='{day_int}'"
            f"]"
        )
        day_elem = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, day_xpath))
        )
        day_elem.click()
        time.sleep(0.2)

    # ------------------------------------------------------------------
    # Subjects autocomplete
    # ------------------------------------------------------------------

    @keyword
    def add_subject(self, subject_text: str):
        """Type a subject name and select the first matching autocomplete suggestion.

        Args:
            subject_text: Subject to add, e.g. 'Maths' or 'Computer Science'.
        """
        driver = self._driver

        subject_input = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.ID, "subjectsInput"))
        )
        subject_input.send_keys(subject_text)
        time.sleep(0.6)

        option_xpath = (
            f"//div[contains(@class,'subjects-auto-complete__option')"
            f"      and contains(text(),'{subject_text}')]"
        )
        option = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, option_xpath))
        )
        option.click()
        time.sleep(0.2)
