@ECHO OFF

rem -= Convenient Variables =-
rem DESCRIPTION: These are the long and/or constantly used variables where I would like to save space.
rem ====================================================================================================================

SET EXEName=DesktopOK_x64.exe
SET EXEPath=C:\EaseOfUse\DesktopOK_x64\DesktopOK_x64.exe
SET DRIVEPath=%~d0%

rem -= Convenient Variables End =-
rem --------------------------------------------------------------------------------------------------------------------

echo + ----------------------------------------------------------------------------- +

echo + Now installing the Ease Of Use Suite, designed for conference center laptops. +

echo + ----------------------------------------------------------------------------- +

rem -= Administrator Privileges =-
rem DESCRIPTION: The Gist of this section: checks for administrator privileges, as they are required for this script.
rem ====================================================================================================================

rem COMMENT: This subsection checks for admin privileges, and if not available moves to the UACPrompt subsection;
rem - otherwise, it simply moves to gotAdmin for already having the correct privileges.
echo Checking for required permissions...
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if "%errorlevel%" NEQ '0' (
	echo Missing required permissions, requesting administrative privileges...
	goto UACPrompt
) else ( goto gotAdmin )

rem COMMENT: This subsection is what elevates the script, but opening a new commandline with admin privileges and
rem - re-executing this script from that new commandline instance. Once the new instance of the script is run, it then
rem - exits out of the initial, non-admin privileges, instance.
:UACPrompt
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	set params = %*:"=""
	echo UAC.ShellExecute "%DRIVEPath%\Work!\Conference Center\Install EaseOfUse Suite.bat", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
    	del "%temp%\getadmin.vbs"
	exit /b

rem COMMENT: This subsection is very simple: it lets the user know that they already had the correct privileges and
rem - continues on with the rest of the script!
:gotAdmin
	echo Correct permissions available!
	rem pushd "%CD%"
	rem cd /D "%dp0"

rem -= Administrator Privileges End=-
rem --------------------------------------------------------------------------------------------------------------------

rem -= Copying files =-
rem DESCRIPTION: The Gist of this section: copy all necessary files for the EOU Suite over to the client computer.
rem ====================================================================================================================

echo Step 1 - Copy over all neccessary files from USB drive.
GOTO validateShortcutPaths

rem COMMENT: This subsection checks the default paths of Adobe Acrobat Reader DC, Firefox, Chrome, VLC Media Player,
rem - and Zoom Conference Client to see if they exist in these locations on the computer. If at least one doesn't, the
rem - keepOpen boolean variable will be set to true.
:validateShortcutPaths
SET keepOpen=false

rem --Check if Acrobat Reader DC exists
if not exist "C:\Program Files (x86)\Adobe\Acrobat Reader DC\" (
	SET ARDCState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET ARDCState=Installation OK!
)

rem --Check if Firefox exists
if not exist "C:\Program Files\Mozilla Firefox\" (
	SET FFState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET FFState=Installation OK!
)

rem --Check if Chrome exists
if not exist "C:\Program Files (x86)\Google\Chrome\Application\" (
	SET CHRState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET CHRState=Installation OK!
)

rem --Check if VLC exists
if not exist "C:\Program Files (x86)\VideoLAN\VLC\" (
	SET VLCState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET VLCState=Installation OK!
)

rem --Check if Zoom exists
if not exist "C:\Users\confctr\AppData\Roaming\Zoom\bin" (
	SET ZMState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET ZMState=Installation OK!
)

rem COMMENT: This subsection, if at least one of the above applications does not exist in their respective default
rem - locations, will display a short report of which applications could not be found. The script then pauses to let
rem - the user take appropriate action.
if %keepOpen% == true (
	echo +----------------------------------------------------------------------------------+
	echo + Adobe Acrobat Reader DC:
	echo 	%ARDCState%
	echo + Mozilla Firefox:
	echo 	%FFState%
	echo + Google Chrome:
	echo 	%CHRState%
	echo + VLC Media Player:
	echo 	%VLCState%
	echo + Zoom Conference Client:
	echo 	%ZMState%
	echo +----------------------------------------------------------------------------------+
	echo.
	pause
)
GOTO copyFiles

rem COMMENT: This subsection
:copyFiles
robocopy "%DRIVEPath%\Work!\Conference Center\EaseOfUse" "C:\EaseOfUse" /XD "%DRIVEPath%\Work!\Conference Center\Scripts" /XF "Install EaseOfUse Suite.bat" /s /njh /njs /ndl /nc /ns /np
echo.
echo Copied over EaseOfUse and Desktop Shortcut folders into root directory.
robocopy "%DRIVEPath%\Work!\Conference Center\Desktop Shortcuts" "C:\Users\confctr\Desktop" /njh /njs /ndl /nc /ns /np
echo.
echo Copied over default application shortcuts to the Desktop.
robocopy "C:\EaseOfUse" "C:\Users\confctr\Desktop" CleanUp!.lnk /njh /njs /ndl /nc /ns /np
echo.
echo Copied over the CleanUp! batch script shortcut.

PAUSE

GOTO cleanDesktop

rem //----------------------------------------------------------------------------

:cleanDesktop

echo.
echo Step 2 - Clean desktop using the CleanUp! script.
echo -----------------------------------------------------------------------------

ForFiles /p "C:\Users\confctr\Desktop" /c "cmd /c if /i not @ext==\"ini\" if /i not @ext==\"lnk\" rmdir @path /s/q || del @path /s/q"

GOTO createSchedTask

rem //----------------------------------------------------------------------------

:createSchedTask

echo.
echo Step 3 - Create scheduled task to start DesktopOK on logon.
echo -----------------------------------------------------------------------------
echo.

Powershell.exe -executionpolicy remotesigned -File "%DRIVEPath%\Work!\Conference Center\Scripts\modXML.ps1"

schtasks /create /f /tn "DesktopOK" /xml "C:\EaseOfUse\DesktopOK_x64\DesktopOK.xml"

GOTO startDesktopOK

rem //----------------------------------------------------------------------------

:startDesktopOK

echo.
echo Step 4 - Run DesktopOK application.
echo -----------------------------------------------------------------------------

SET EXEName=DesktopOK_x64.exe
SET EXEFullPath=C:\EaseOfUse\DesktopOK_x64\DesktopOK_x64.exe

TASKLIST | FINDSTR /I "%EXEName%"
IF ERRORLEVEL 1 GOTO :StartDesktopOK
GOTO cleanTaskbar

:StartDesktopOK
START "" "%EXEFullPath%"
GOTO cleanTaskbar

rem //----------------------------------------------------------------------------

:cleanTaskbar
echo Step 5 - Clean up the taskbar.
echo -----------------------------------------------------------------------------


del /f /s /q /a "C:\Users\confctr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
robocopy "%DRIVEPath%\Work!\Conference Center\Taskbar\Shortcuts" "C:\Users\confctr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" /XD "%DRIVEPath%\Work!\Conference Center\Taskbar\Shortcuts\desktop.ini"
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"

pause

robocopy "%DRIVEPath%\Work!\Conference Center\Taskbar" "C:\Users\confctr\Desktop" /XD "%DRIVEPath%\Work!\Conference Center\Taskbar\Shortcuts"
reg import "C:\Users\confctr\Desktop\Taskbar.reg"

pause

del "C:\Users\confctr\Desktop\Taskbar.reg"

pause

GOTO Complete

rem //----------------------------------------------------------------------------

:Complete

echo.
echo -----------------------------------------------------------------------------
echo.
echo Successfully installed the EaseOfUse Suite!
echo.
echo -----------------------------------------------------------------------------
pause
shutdown.exe /r /t 00

rem Developed by Cameron Sherry, June 2019.