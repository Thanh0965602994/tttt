@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Dang yeu cau quyen Admin...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit
) 

cls
color 07
set T= ThanhAOI Tool
set V= (V1.0.0)
title %T% %V%.

:menu
cls
color 06
echo ************************************
echo *    %T% %V%      *
echo ************************************
echo *        --//-- MENU --//--        *
echo ====================================
echo.

echo 1. On/off Firewall
echo 2. On/off Windows Defender
echo 3. On/off Update Windows
echo 4. About (information)
echo 5. Exit
echo.

set /p choice=(+) Please select an option (1/2/3/4/5): 
if "%choice%"=="1" goto firewall
if "%choice%"=="2" goto defender
if "%choice%"=="3" goto updatewindows
if "%choice%"=="4" goto about
if "%choice%"=="5" exit

:firewall
cls
color 03
echo ************************************
echo *    %T% %V%      *
echo ************************************
echo *        -- MENU FIREWALL --       *
echo ====================================
echo.

echo 1. Turn Off Firewall
echo 2. Turn On Firewall
echo 3. Back to main menu
echo.
set /p firewall_choice=(+) Choose an option (1/2/3): 

if "%firewall_choice%"=="1" goto offfirewall
if "%firewall_choice%"=="2" goto onfirewall
if "%firewall_choice%"=="3" goto menu

:offfirewall
cls
color 04
echo ************************************
echo *          OFF FIREWALL            *
echo ************************************
echo.
echo Loading... (off firewall)
timeout 5
netsh advfirewall set allprofiles state off
echo Success! Firewall is off
echo.
pause
goto firewall

:onfirewall
cls
color 0A
echo ************************************
echo *          ON FIREWALL             *
echo ************************************
echo.
echo Loading... (on firewall)
timeout 5
netsh advfirewall set allprofiles state on
echo  Success! Firewall is on
echo.
pause
goto firewall


:defender
cls
color 03
echo ************************************
echo *    %T% %V%      *
echo ************************************
echo *        -- MENU DEFENDER --       *
echo ====================================
echo.
echo 1. Turn Off Windows Defender
echo 2. Turn On Windows Defender
echo 3. Back to main menu
echo.
set /p defender_choice=(+) Choose an option (1/2/3): 

if "%defender_choice%"=="1" goto offdefender
if "%defender_choice%"=="2" goto onndefender
if "%defender_choice%"=="3" goto menu

:offdefender
cls
color 04
echo ************************************
echo *          OFF DEFENDER            *
echo ************************************
echo.
timeout 5
title Turn off Windows Defender permanently
echo Loading... (off defender)
echo.

:: Vo hieu hoa Windows Defender qua Registry
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f

:: Dung va vo hieu hoa cac dich vu Windows Defender
sc stop WinDefend
sc config WinDefend start= disabled
sc stop WdNisSvc
sc config WdNisSvc start= disabled
sc stop Sense
sc config Sense start= disabled

:: Xoa quyen so huu va doi ten thu muc Windows Defender (Ngan no khoi dong lai)
takeown /f "C:\ProgramData\Microsoft\Windows Defender" /r /d y
icacls "C:\ProgramData\Microsoft\Windows Defender" /grant administrators:F /t /c /q
attrib -h -s -r "C:\ProgramData\Microsoft\Windows Defender" /s /d
rename "C:\ProgramData\Microsoft\Windows Defender" "Windows_Defender_Disabled"
echo.
echo Windows Defender has been permanently disabled.
goto defender


:onndefender
cls
color 0A
echo ************************************
echo *           ON DEFENDER            *
echo ************************************
echo.
timeout 5
echo Loading... (Turn on Windows Defender)

:: Bat lai Windows Defender qua Registry
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /f

:: Bat lai dich vu Windows Defender
sc config WinDefend start= auto
sc start WinDefend
sc config WdNisSvc start= auto
sc start WdNisSvc
sc config Sense start= auto
sc start Sense

:: Khoi phuc thu muc Windows Defender
rename "C:\ProgramData\Microsoft\Windows_Defender_Disabled" "Windows Defender"
echo.
echo Windows Defender is enabled
pause
goto defender

:updatewindows
cls
color 03
echo ************************************
echo *    %T% %V%      *
echo ************************************
echo *    -//MENU UPDATE WINDOWS//-     *
echo ====================================
echo.

echo 1. Turn Off windows update (permanently)
echo 2. Turn on Windows Updates
echo 3. Back to main menu
echo.
set /p updatewindows_choice=(+) Choose an option (1/2/3): 

if "%updatewindows_choice%"=="1" goto offupdate
if "%updatewindows_choice%"=="2" goto onupdate
if "%updatewindows_choice%"=="3" goto menu

:offupdate
cls
color 04
echo ************************************
echo *       OFF UPDATE WINDOWS         *
echo ************************************
echo.
echo Loading... (Turn Off windows update)
timeout 5

:: Dung Windows Update Service
net stop wuauserv

:: Vo hieu hoa Windows Update
sc config wuauserv start= disabled

:: Tat cac dich vu lien quan den update WinDows
sc stop bits
sc config bits start= disabled

sc stop dosvc
sc config dosvc start= disabled
echo.
echo Windows update feature is permanently disabled.
pause
goto updatewindows

:onupdate
cls
color 0A
echo ************************************
echo *        ON UPDATE WINDOWS         *
echo ************************************
echo.
echo Loading...(Turn on windows update again...)
timeout 5
echo.

:: Kich hoat dich vu Windows Update
sc config wuauserv start= demand
net start wuauserv

:: Kich hoat dich vu BITS
sc config bits start= demand
net start bits

:: Kich hoat dich vu Delivery Optimization
sc config dosvc start= demand
net start dosvc
echo.
echo Windows update feature is enabled.
pause
goto updatewindows


:about
cls
color 03
echo ************************************
echo *    %T% %V%      *
echo ************************************
echo * Developed by ThanhAOI (ChatGPT)  *
echo ____________________________________
echo *        -// (2024-2025) //-       *
echo ____________________________________
echo.
pause
goto menu
