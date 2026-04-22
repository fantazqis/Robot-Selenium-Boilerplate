@echo off
REM =============================================================================
REM run.bat — Jalankan Robot Framework tests lalu generate semua reports.
REM
REM Usage (dari folder DemoQA_Boilerplate):
REM   scripts\run.bat                         -> jalankan semua tests
REM   scripts\run.bat tests\ui\               -> hanya UI tests
REM   scripts\run.bat tests\api\              -> hanya API tests
REM   scripts\run.bat tests\ui\ --include SMOKE
REM =============================================================================

SET TEST_PATH=%1
IF "%TEST_PATH%"=="" SET TEST_PATH=tests/

echo.
echo ==============================================
echo  Robot Framework Test Runner
echo ==============================================
echo  Target : %TEST_PATH%
echo ==============================================
echo.

REM --- 1. Jalankan robot -----------------------------------------------------
robot --outputdir results %TEST_PATH% %2 %3 %4 %5
SET ROBOT_EXIT=%ERRORLEVEL%

echo.
echo ==============================================
echo  Generating reports...
echo ==============================================

REM --- 2. RF Metrics ---------------------------------------------------------
echo.
echo [1/2] RF Metrics...
cd results && robotmetrics && cd ..
echo       ^-^> metrics.html (di folder results/)

REM --- 3. RF Dashboard -------------------------------------------------------
echo.
echo [2/2] RF Dashboard...
robotdashboard -o results/output.xml
echo       ^-^> robot_dashboard_*.html (di folder project)

REM --- 4. Ringkasan ----------------------------------------------------------
echo.
echo ==============================================
echo  Selesai! Reports tersedia di:
echo    Built-in   : results\report.html
echo    Built-in   : results\log.html
echo    RF Metrics : results\metrics.html
echo    RF Dashboard: robot_dashboard_*.html
echo ==============================================
echo.

EXIT /B %ROBOT_EXIT%
