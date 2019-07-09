@ECHO OFF

echo + ----------------------------------------------------------------------------- +
echo + Now installing the Ease Of Use Suite, designed for conference center laptops. +
echo + ----------------------------------------------------------------------------- + & echo.

rem -= Convenient Variables =-
rem ====================================================================================================================
rem DESCRIPTION: These are the long and/or constantly used variables where I would like to save space.
rem ====================================================================================================================

SET "INSTALLATIONPATH=%~dp0..\"
SET LOCALPATH=C:\EaseOFUse\
SET EXEName=DesktopOK_x64.exe
SET EXEFullPath=%LOCALPATH%DesktopOK_x64\DesktopOK_x64.exe
SET "roboSilence=/njh /njs /ndl /nc /ns /np /nfl"

rem -= Copying files =-
rem ====================================================================================================================
rem DESCRIPTION: The Gist of this section: copy all necessary files for the EOU Suite over to the client computer.
rem ====================================================================================================================

echo Step 1 - Copy over all necessary files from USB drive.
echo --------------------------------------------------------------------------------- & echo.
GOTO validateApplicationPaths

rem COMMENT: This subsection checks the default paths of Adobe Acrobat Reader DC, Firefox, Chrome, VLC Media Player,
rem - and Zoom Conference Client to see if they exist in these locations on the computer. If at least one doesn't, the
rem - keepOpen boolean variable will be set to true.
:validateApplicationPaths
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
	echo +-------------------------------------------------------------------------------+
	echo + Adobe Acrobat Reader DC:
	echo + 	%ARDCState%
	echo + Mozilla Firefox:
	echo +	%FFState%
	echo + Google Chrome:
	echo +	%CHRState%
	echo + VLC Media Player:
	echo +	%VLCState%
	echo + Zoom Conference Client:
	echo +	%ZMState%
	echo +-------------------------------------------------------------------------------+
	echo.
	)
	pause
)
GOTO copyFiles

rem COMMENT: This subsection deals with the actual copying over of the various shortcuts, scripts, XML files, etc. that
rem - are necessary for both installation as well as general usage after the fact.
:copyFiles
echo Copied over:
robocopy "%INSTALLATIONPATH%EaseOfUse" "C:\EaseOfUse" /XD "%INSTALLATIONPATH%Scripts" /XF "EOUSful Installation.bat" /s %roboSilence%
echo + EaseOfUse and Desktop Shortcut folders into root directory & echo.
robocopy "%INSTALLATIONPATH%Standardization\Desktop\Shortcuts" "C:\Users\confctr\Desktop" %roboSilence%
echo + Default Desktop application shortcuts & echo.
robocopy "C:\EaseOfUse" "C:\Users\confctr\Desktop" CleanUp!.lnk %roboSilence%
echo + CleanUp! batch script shortcut & echo.

if "%keepOpen%" EQU "true" (
    choice /c ACN /m "Would you like to download [A] All, [C] Choose, or [N] None of the core applications for installation?"
    if ERRORLEVEL EQU 3 goto cleanDesktop
    if ERRORLEVEL EQU 2 goto chooseApps
    if ERRORLEVEL EQU 1 goto installAll

:installAll
echo Now downloading... & echo.

rem --Acrobat
del %INSTALLATIONPATH%Standardization\Applications\ARDC.exe /q
powershell -Command "Invoke-WebRequest https://admdownload.adobe.com/bin/live/readerdc_en_fa_crd_install.exe -Outfile %INSTALLATIONPATH%Standardization\Applications\ARDC.exe"
echo Now installing Adobe Acrobat...
%INSTALLATIONPATH%Standardization\Applications\ARDC.exe /s
echo Installation complete! & echo.


rem --Firefox
del %INSTALLATIONPATH%Standardization\Applications\FF.msi /q
powershell -Command "Invoke-WebRequest https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US -Outfile %INSTALLATIONPATH%Standardization\Applications\FF.msi"
echo Now installing Firefox...
%INSTALLATIONPATH%Standardization\Applications\FF.msi /qn
echo Installation complete! & echo.

rem --Chrome
del %INSTALLATIONPATH%Standardization\Applications\CHR.msi /q
powershell -Command "Invoke-WebRequest https://cloud.google.com/chrome-enterprise/browser/download/thankyou?platform=WIN64_BUNDLE&channel=stable&usagestats=0 -Outfile %INSTALLATIONPATH%\Standardization\Applications\CHR.zip"
powershell -Command "Expand-Archive -LiteralPath %INSTALLATIONPATH%\Standardization\Applications\CHR.zip -DestinationPath %INSTALLATIONPATH%\Standardization\Applications\CHR"
del %INSTALLATIONPATH%\Standardization\Applications\CHR.zip
move "%INSTALLATIONPATH%\Standardization\Applications\CHR\Installers\GoogleChromeStandaloneEnterprise64.msi" "%INSTALLATIONPATH%\Standardization\Applications\CHR.msi"
del %INSTALLATIONPATH%\Standardization\Applications\CHR\ /q
echo Now installing Chrome...
%INSTALLATIONPATH%Standardization\Applications\CHR.msi /qn
echo Installation complete! & echo.

rem --VLC
del %INSTALLATIONPATH%Standardization\Applications\VLC.exe /q
powershell -Command "Invoke-WebRequest ((Invoke-WebRequest –Uri ‘https://www.opera.com/pcappshub/vlc’).Links | Where-Object {$_.title -eq “VLC Download Link”}).href -Outfile %INSTALLATIONPATH%Standardization\Applications\VLC.exe"
echo Now installing VLC...
%INSTALLATIONPATH%Standardization\Applications\VLC.exe /s
echo Installation complete! & echo.

rem --Zoom
del %INSTALLATIONPATH%Standardization\Applications\ZM.msi /q
powershell -Command "Invoke-WebRequest https://www.zoom.us/client/latest/ZoomInstallerFull.msi -Outfile %INSTALLATIONPATH%Standardization\Applications\ZM.msi"
echo Now installing Zoom...
%INSTALLATIONPATH%Standardization\Applications\ZM.msi /qn
echo Installation complete! & echo.

echo All applications downloaded successfully. & echo.
goto cleanDesktop

:chooseApps
if "%ARDCState%" EQU "does not exist in the default location on this machine." (
    choice /c YN /m "Would you like to download Adobe Acrobat Reader DC for later installation?"
	if ERRORLEVEL EQU 1 (
	    del %INSTALLATIONPATH%Standardization\Applications\ARDC.exe /q
	    echo Now downloading...
        powershell -Command "Invoke-WebRequest https://admdownload.adobe.com/bin/live/readerdc_en_fa_crd_install.exe -Outfile %INSTALLATIONPATH%Standardization\Applications\ARDC.exe"
        echo Application downloaded successfully.
        echo Now installing...
        %INSTALLATIONPATH%Standardization\Applications\ARDC.exe /s
        echo Installation successful! & echo.
	)
)

if "%FFState%" EQU "does not exist in the default location on this machine." (
    choice /c YN /m "Would you like to download Firefox for later installation?"
    if %ERRORLEVEL% EQU 1 (
        del %INSTALLATIONPATH%Standardization\Applications\FF.msi /q
        echo Now downloading...
        powershell -Command "Invoke-WebRequest https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US -Outfile %INSTALLATIONPATH%Standardization\Applications\FF.msi"
        echo Application downloaded successfully.
        echo Now installing...
        %INSTALLATIONPATH%Standardization\Applications\FF.msi /qn
        echo Installation successful! & echo.
    )
)

if "%CHRState%" EQU "does not exist in the default location on this machine." (
    choice /c YN /m "Would you like to download Chrome for later installation?"
    if %ERRORLEVEL% EQU 1 (
        del %INSTALLATIONPATH%Standardization\Applications\CHR.msi /q
        echo Now downloading...
        powershell -Command "Invoke-WebRequest https://cloud.google.com/chrome-enterprise/browser/download/thankyou?platform=WIN64_BUNDLE&channel=stable&usagestats=0 -Outfile %INSTALLATIONPATH%\Standardization\Applications\CHR.zip"
        powershell -Command "Expand-Archive -LiteralPath %INSTALLATIONPATH%\Standardization\Applications\CHR.zip -DestinationPath %INSTALLATIONPATH%\Standardization\Applications\CHR"
        del %INSTALLATIONPATH%\Standardization\Applications\CHR.zip
        move "%INSTALLATIONPATH%\Standardization\Applications\CHR\Installers\GoogleChromeStandaloneEnterprise64.msi" "%INSTALLATIONPATH%\Standardization\Applications\CHR.msi"
        del %INSTALLATIONPATH%\Standardization\Applications\CHR\ /q
        echo Application downloaded successfully.
        echo Now installing...
        %INSTALLATIONPATH%Standardization\Applications\CHR.msi /qn
        echo Installation successful! & echo.
    )

if "%VLCState%" EQU "does not exist in the default location on this machine." (
    choice /c YN /m "Would you like to download VLC Media Player for later installation?"
    if %ERRORLEVEL% EQU 1 (
        del %INSTALLATIONPATH%Standardization\Applications\VLC.exe /q
        echo Now downloading...
        powershell -Command "Invoke-WebRequest ((Invoke-WebRequest –Uri ‘https://www.opera.com/pcappshub/vlc’).Links | Where-Object {$_.title -eq “VLC Download Link”}).href -Outfile %INSTALLATIONPATH%Standardization\Applications\VLC.exe"
        echo Application downloaded successfully.
        echo Now installing...
        %INSTALLATIONPATH%Standardization\Applications\VLC.exe /s
        echo Installation successful! & echo.
    )

if "%ZMState%" EQU "does not exist in the default location on this machine." (
    choice /c YN /m "Would you like to download Zoom for later installation?"
    if %ERRORLEVEL% EQU 1 (
        del %INSTALLATIONPATH%Standardization\Applications\ZM.msi /q
        echo Now downloading...
        powershell -Command "Invoke-WebRequest https://www.zoom.us/client/latest/ZoomInstallerFull.msi -Outfile %INSTALLATIONPATH%Standardization\Applications\ZM.msi"
        echo Application downloaded successfully.
        echo Now installing...
        %INSTALLATIONPATH%Standardization\Applications\ZM.msi /qn
        echo Installation successful! & echo.
    )

GOTO cleanDesktop

rem -= Desktop CleanUp =-
rem ====================================================================================================================
rem DESCRIPTION: This section is simple, making use of the very cleanup file that will be installed on this computer!
rem ~ Its purpose is to remove the majority of the unnecessary files on the desktop, likely leftover from past
rem ~ conferences. It only deletes files older than 2 days, excluding "ini" and "lnk" files.
rem ====================================================================================================================

:cleanDesktop
echo Step 2 - Clean desktop using the CleanUp! script.
echo ---------------------------------------------------------------------------------
ForFiles /p "C:\Users\confctr\Desktop" /c "cmd /c if /i not @ext==\"ini\" if /i not @ext==\"lnk\" rmdir @path /s/q || del @path /s/q"
echo Desktop cleaned^^! & echo.
GOTO createSchedTask

rem -= DesktopOK Scheduled Task =-
rem ====================================================================================================================
rem DESCRIPTION: This section is pretty straightforward, but more complex than meets the eye. To put it simply, it takes
rem ~ an XML file with the required settings for the task, then customizes it to work with this specific client and
rem ~ imports it.
rem ====================================================================================================================

:createSchedTask
echo Step 3 - Create scheduled task to start DesktopOK on logon.
echo --------------------------------------------------------------------------------- & echo.

rem COMMENT: This subsection runs a Powershell script in a special way, to get around the fact that Windows is moody
rem - when to comes to running unsigned scripts. The script itself modifies the XML file that was copied over, which
rem - contains the information for importing the scheduled task, to run the DesktopOK application at logon of the
rem - confctr user on this specific computer. Otherwise, it wouldn't work as the computer specified in the XML is
rem - incorrect.
Powershell.exe -executionpolicy remotesigned -File "%INSTALLATIONPATH%Scripts\modXML.ps1"

rem COMMENT: This subsection is what creates/imports the actual scheduled task on this computer. It provides a task name
rem - and the path to the XML file we modified earlier, forcing the creation of the task even if one with the same name
rem - existed already (this helps when it comes to updating code).
schtasks /create /f /tn "DesktopOK" /xml "%LOCALPATH%DesktopOK_x64\DesktopOK.xml"
GOTO startDesktopOK

rem -= Start DesktopOK =-
rem ====================================================================================================================
rem DESCRIPTION: This section simply starts the DesktopOK application if not already running.
rem ====================================================================================================================

:startDesktopOK
echo.
echo Step 4 - Run DesktopOK application.
echo --------------------------------------------------------------------------------- & echo.

rem COMMENT: This subsection looks at the list of currently running apps to see if DesktopOK.exe is currently running.
rem - If it is, it moves on to the next task; if it isn't, it will run the application and then move on.
TASKLIST | FINDSTR /I "%EXEName%"
IF ERRORLEVEL 1 GOTO :StartDesktopOK
echo.
GOTO cleanTaskbar

rem COMMENT: This subsection runs the DesktopOK.exe application.
:StartDesktopOK
START "" "%EXEFullPath%"
GOTO cleanTaskbar

rem -= Taskbar CleanUp =-
rem ====================================================================================================================
rem DESCRIPTION: This section is complex. It seeks to accomplish the task of deleting all icons on the taskbar
rem ~ and replacing them with a handful of predetermined ones in a specified order.
rem ====================================================================================================================

rem TODO: THIS IS NOT WORKING FOR SOME REASON, REGISTRY COMMANDS ARE BROKEEEEEEEN!
:cleanTaskbar
echo Step 5 - Clean up the taskbar.
echo --------------------------------------------------------------------------------- & echo.

rem COMMENT: This subsection aims to:
rem     1.) Delete the initial icons on the taskbar.
del /f /s /q /a "C:\Users\confctr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" 1>nul
rem     2.) Copy over the predetermined icons.
robocopy "%INSTALLATIONPATH%Standardization\Taskbar\Shortcuts" "C:\Users\confctr\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" /XF "%INSTALLATIONPATH%Standardization\Taskbar\Shortcuts\desktop.ini" %roboSilence%
rem     3.) Delete the registry values that store the organization and ordering data for the taskbar.
Powershell.exe -executionpolicy remotesigned -File "%INSTALLATIONPATH%\Scripts\modReg.ps1"
rem     4.) Copy over the registry file storing the desired taskbar icon ordering to the confctr user Desktop.
robocopy "%INSTALLATIONPATH%Standardization\Taskbar" "C:\Users\confctr\Desktop" Taskbar.reg %roboSilence%
rem     5.) Import the desired ordering to the registry of this computer.
reg import "C:\Users\confctr\Desktop\Taskbar.reg"
rem     6.) Finally, delete the registry file once the desired data has been imported into this computer's registry.
del "C:\Users\confctr\Desktop\Taskbar.reg"
GOTO groupPolicy

rem -= Group Policy =-
rem ====================================================================================================================
rem DESCRIPTION:
rem ====================================================================================================================

:groupPolicy
echo Step 6 - Apply Group Policy.
echo --------------------------------------------------------------------------------- & echo.

"%INSTALLATIONPATH%Group Policy\LGPO.exe" /q /g "%INSTALLATIONPATH%Group Policy\gpoconf"
echo Group policy applied^^! & echo.
GOTO Complete

:Complete
echo    + ========================================================================= +
echo    +               Successfully installed the EaseOfUse Suite!                 +
echo    +            Developed by yours truly, CamCam "Shrimp" Cherry.              +
echo    + ========================================================================= +
pause
shutdown.exe /r /t 00

rem Developed by Cameron Sherry, June 2019.