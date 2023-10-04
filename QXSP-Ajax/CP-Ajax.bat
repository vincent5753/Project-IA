@echo off
@title 複製環境腳本 By VP

:: BatchGotAdmin (Run as Admin code starts)
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:: BatchGotAdmin (Run as Admin code ends)

mkdir "D:\Ajax程式設計\"
xcopy /s "%~dp0Ajax程式設計\" "D:\Ajax程式設計\"
icacls "D:\Ajax程式設計" /reset /T
icacls "D:\Ajax程式設計" /grant "%username%":(OI)(CI)RX
icacls "D:\Ajax程式設計" /inheritance:r
icacls "D:\Ajax程式設計" /deny "%username%:M"

:: attrib +r +s /s "D:\Ajax程式設計"
:: cacls D:\Ajax程式設計 /e /c /d %username%
cls
echo 你可以拔隨身碟了

pause