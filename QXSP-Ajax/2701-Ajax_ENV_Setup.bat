@echo off
@title 環境安裝腳本 By VP

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

echo [安裝資訊] 總安裝時間約 4 ~ 5 分，建議於隨身碟內直接執行
echo.

:: 01-VSCode
echo [安裝軟體 (1/9)] IDE: VSCode (約 10 ~ 15 秒)
%~dp001-VSCodeSetup-x64-1.82.2.exe /verysilent /suppressmsgboxes /mergetasks="!runCode, desktopicon, quicklaunchicon, addcontextmenufiles, addcontextmenufolders, associatewithfiles, addtopath"
echo   [安裝擴充功能] VSCode 擴充功能 (約 10 秒)
echo   [安裝擴充功能 (1/6)] VSCode 擴充功能 - Golang
call "C:\Program Files\Microsoft VS Code\bin\code" "--install-extension" "%~dp0VSCode_Extentions\1.1-golang.Go-0.39.1.vsix" > nul
echo   [安裝擴充功能 (2/6)] VSCode 擴充功能 - Docker
call "C:\Program Files\Microsoft VS Code\bin\code" "--install-extension" "%~dp0VSCode_Extentions\1.2-ms-azuretools.vscode-docker-1.26.0.vsix" > nul
echo   [安裝擴充功能 (3/6)] VSCode 擴充功能 - Copilot
call "C:\Program Files\Microsoft VS Code\bin\code" "--install-extension" "%~dp0VSCode_Extentions\1.3-GitHub.copilot-1.112.420.vsix" > nul
echo   [安裝擴充功能 (4/6)] VSCode 擴充功能 - Copilot Chat
call "C:\Program Files\Microsoft VS Code\bin\code" "--install-extension" "%~dp0VSCode_Extentions\1.4-GitHub.copilot-chat-0.7.1.vsix" > nul
echo   [安裝擴充功能 (5/6)] VSCode 擴充功能 - Google Cloud Code
call "C:\Program Files\Microsoft VS Code\bin\code" "--install-extension" "%~dp0VSCode_Extentions\1.5-GoogleCloudTools.cloudcode-2.0.0.vsix" > nul
echo   [安裝擴充功能 (6/6)] VSCode 擴充功能 - ReactJs Code Snippets
call "C:\Program Files\Microsoft VS Code\bin\code" "--install-extension" "%~dp0VSCode_Extentions\1.6-xabikos.ReactSnippets-2.4.0.vsix" > nul

:: 02-Golang
echo [安裝軟體 (2/9)] 程式語言: Golang (背景安裝約 15 秒)
msiexec /i "%~dp002-go1.21.1.windows-amd64.msi" /qn /norestart
echo   [解壓縮套件] gin、gorm、postgres
"C:\Program Files\7-Zip\7z.exe" x "%~dp0Go\go(128,64).7z" "-oC:\Users\%username%\"
echo   [複製模組設定檔] 將 go.mod、go.sum 複製至桌面
copy "%~dp0Go\go.mod" "C:\Users\%username%\Desktop\"
copy "%~dp0Go\go.sum" "C:\Users\%username%\Desktop\"

:: 04-NodeJS
echo [安裝軟體 (3/9)] 程式語言: NodeJS (背景安裝約 10 秒)
msiexec /i "%~dp004-node-v18.17.1-x64.msi" /qn
echo   [解壓並複製 npm 套件] create-react-app
"C:\Program Files\7-Zip\7z.exe" x "%~dp004-npm(64,64).7z" "-oC:\Users\%username%\AppData\Roaming\"

:: 05-Postman
echo [安裝軟體 (4/9)] 開發工具: Postman (背景安裝約 5 秒)
call "%~dp005-Postman-win64-Setup.exe" -s

:: 06-Git
echo [安裝軟體 (5/9)] 版控工具: Git (背景安裝約 5 秒)
call "%~dp006-Git-2.42.0.2-64-bit.exe" /VERYSILENT /NORESTART

:: 07-SourceTree
echo [安裝軟體 (6/9)] 圖形介面版控工具: SourceTree (背景安裝約 10 秒)
call "%~dp007-SourceTreeSetup-3.4.14.exe" -s

:: 08-PostgreSQL
echo [安裝軟體 (7/9)] 資料庫: PostgreSQL (背景安裝約 2 分 30 秒)
call "%~dp008-postgresql-16.0-1-windows-x64.exe" --unattendedmodeui none --mode unattended

:: 09-PGAdmin
echo [安裝軟體 (8/9)] 資料庫管理軟體: PGAdmin4 (背景安裝約 1 分)
"%~dp009-pgadmin4-7.6-x64.exe" /VERYSILENT /NORESTART /ALLUSERS

:: 10-GoogleCloudSDK
echo [安裝軟體 (9/9)] 雲端開發套件: Google Cloud SDK (背景安裝約 30 秒)
:: call "%~dp010-GoogleCloudSDKInstaller.exe" /S /allusers /reporting
"C:\Program Files\7-Zip\7z.exe" x "%~dp010-GCP_SDK(1024,64).7z" "-oC:\Program Files (x86)\Google\"
setx path "%path%;C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin"

echo.
echo [自我推銷] 安裝內容壓縮部分 Powered by vincent5753/HBFS/Win/compress (using 7-Zip)
echo [自我推銷] 如果你覺得這份腳本不錯或是喜歡自動化，不妨參觀一下作者的 Github
echo [自我推銷] 傳送門: https://github.com/vincent5753

pause