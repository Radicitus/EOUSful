@ECHO OFF

SET EXEName=DesktopOK_x64.exe
SET EXEPath=C:\EaseOfUse\DesktopOK_x64\DesktopOK_x64.exe
SET DRIVEPath=%~d0%

echo -----------------------------------------------------------------------------

echo Now installing the Ease Of Use Suite, designed for conference center laptops.

echo -----------------------------------------------------------------------------
echo.

rem //----------------------------------------------------------------------------

echo Checking for required permissions...
echo.
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if "%errorlevel%" NEQ '0' (
	echo Missing required permissions, requesting administrative privileges...
	goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	set params = %*:"=""
	echo UAC.ShellExecute "%DRIVEPath%\Work!\Conference Center\Install EaseOfUse Suite.bat", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
    	del "%temp%\getadmin.vbs"
	exit /b

:gotAdmin
	echo Correct permissions available!
	rem pushd "%CD%"
	rem cd /D "%dp0"

rem //----------------------------------------------------------------------------

echo Step 1 - Copy over all neccessary files from USB drive.
GOTO validateShortcutPaths

rem //----------------------------------------------------------------------------

:validateShortcutPaths
SET keepOpen=false

rem Check if Acrobat Reader DC exists
if not exist "C:\Program Files (x86)\Adobe\Acrobat Reader DC\" (
	SET ARDCState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET ARDCState=Installation OK!
)

rem Check if Firefox exists
if not exist "C:\Program Files\Mozilla Firefox\" (
	SET FFState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET FFState=Installation OK!
)

rem Check if Chrome exists
if not exist "C:\Program Files (x86)\Google\Chrome\Application\" (
	SET CHRState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET CHRState=Installation OK!
)

rem Check if VLC exists
if not exist "C:\Program Files (x86)\VideoLAN\VLC\" (
	SET VLCState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET VLCState=Installation OK!
)

rem Check if Zoom exists
if not exist "C:\Users\confctr\AppData\Roaming\Zoom\bin" (
	SET ZMState=does not exist in the default location on this machine.
	SET keepOpen=true
) else (
	SET ZMState=Installation OK!
)

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

rem //----------------------------------------------------------------------------

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