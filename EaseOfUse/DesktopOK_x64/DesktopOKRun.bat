@ECHO OFF

SET EXEName=DesktopOK_x64.exe
SET EXEFullPath=C:\EaseOfUse\DesktopOK_x64\DesktopOK_x64.exe

TASKLIST | FINDSTR /I "%EXEName%"
IF ERRORLEVEL 1 GOTO :StartDesktopOK
GOTO EOF

:StartDesktopOK
START "" "%EXEFullPath%"
GOTO EOF