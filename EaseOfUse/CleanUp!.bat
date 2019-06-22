@echo off
ForFiles /p "C:\Users\confctr\Desktop" /d -2 /c "cmd /c if /i not @ext==\"ini\" if /i not @ext==\"lnk\" rmdir @path /s/q || del @path /s/q"

msg "%username%" Successfully deleted all files on the Desktop older than 2 days!