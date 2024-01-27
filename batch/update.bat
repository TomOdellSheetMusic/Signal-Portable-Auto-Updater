@echo off
setlocal

REM Kill Signal processes and child processes if they are running
echo Killing Signal processes...
for /f "tokens=2 delims==;" %%P in ('wmic process where "name='Signal.exe'" get ProcessId /value') do (
    wmic process where "processid=%%P" call terminate >nul 2>nul
)

REM Wait for a moment to allow the processes to terminate
timeout /t 1 /nobreak >nul

REM Check if Signal processes are still running
tasklist /FI "IMAGENAME eq Signal.exe" | find /I "Signal.exe" >nul
if "%ERRORLEVEL%"=="0" (
    echo Signal processes are still running. 
    echo Updater will now terminate.
    pause
    exit
)

REM Download the latest version YAML file
echo Downloading latest.yml...
curl -o "%~dp0latest.yml" "https://updates.signal.org/desktop/latest.yml"

REM Make a version variable for the yml and one for the lastChecked.txt
set "version="
set "lastChecked="

REM Write the version information from the lastChecked.txt file to the lastChecked variable
for /f "tokens=*" %%A in ('type "%~dp0lastChecked.txt"') do set "lastChecked=%%A"

REM Echo it
echo Last Checked was: %lastChecked%

REM Set the version to the latest version from the latest.yaml file
for /f "tokens=2 delims=: " %%A in ('findstr "version:" "%~dp0latest.yml"') do (
    set "version=%%A"
)
echo Latest version is: %version%

REM Compare the strings
if /I "%version: =%"=="%lastChecked: =%" (
    echo Signal is up to date.
    pause
    exit
)

REM Construct the download URL
set "downloadURL=https://updates.signal.org/desktop/signal-desktop-win-%version%.exe"

REM Download SignalSetup.exe using curl
echo Downloading SignalSetup.exe...
curl -o "%~dp0SignalSetup.exe" "%downloadURL%"

REM Check if download was successful
if not exist "%~dp0SignalSetup.exe" (
    echo Failed to download SignalSetup.exe.
    pause
    exit
)
REM Unzip SignalSetup.exe
echo Unzipping SignalSetup.exe...
%~dp07z.exe x -aoa "%~dp0SignalSetup.exe" -o"%~dp0"

REM Go to "$PLUGINSDIR" folder
cd "%~dp0$PLUGINSDIR"

REM Copy "app-64.7z" to "app/" folder
echo Copying app-64.7z to app/ folder...
copy /Y "%~dp0$PLUGINSDIR\app-64.7z" "%~dp0..\app\"

REM Go to "app/" folder
cd "%~dp0..\app"

REM Unzip "app-64.7z" in "app/" folder
echo Unzipping app-64.7z in app/ folder...
%~dp07z.exe x -aoa "%~dp0..\app\app-64.7z"

REM Start Signal application
echo Starting Signal...
start "" "%~dp0..\signal-portable.exe"

echo File extraction completed.
echo Cleanup...
REM Delete any existing SignalSetup.exe
if exist "%~dp0SignalSetup.exe" (
    del "%~dp0SignalSetup.exe"
	del "%~dp0latest.yml"
)
endlocal