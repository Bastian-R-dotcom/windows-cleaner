@echo off
setlocal EnableDelayedExpansion

REM ========================================================
REM  Windows Cleaner
REM  IMPORTANT: save this file as UTF-8 so the
REM  box characters and symbols display correctly.
REM ========================================================

for /f "tokens=2 delims=:." %%c in ('chcp') do set "OLDCP=%%c"
chcp 65001 >nul
title Windows Cleaner by @Tweaksys
mode con: cols=80 lines=40 >nul 2>&1

REM ANSI colors ( Windows 10 and 11 )
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RESET=%ESC%[0m"
set "BOLD=%ESC%[1m"
set "DIM=%ESC%[90m"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"

set "TOTAL=11"
set "BARW=12"
set "STEP=0"

echo.
set "BC=%CYAN%"
call :BoxTop
call :BoxLine "   WINDOWS CLEANER by @Tweaksys" "%BOLD%"
call :BoxLine "   AGPL-3.0 license"

call :BoxBottom
echo.

call :GetFreeMB FREE_BEFORE

REM ========================================================
call :Begin "Temporary files"
call :EmptyDir "%SystemRoot%\Temp"
call :EmptyDir "%SystemRoot%\SystemTemp"
call :EmptyDir "%TEMP%"
call :EmptyDir "%LOCALAPPDATA%\Temp"
call :End

REM ========================================================
call :Begin "Recycle Bin"
rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1
call :End

REM ========================================================
call :Begin "Windows Update cache"
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop cryptsvc /y >nul 2>&1
call :EmptyDir "%SystemRoot%\System32\catroot2"
call :EmptyDir "%SystemRoot%\SoftwareDistribution\Download"
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptsvc >nul 2>&1
call :End

REM ========================================================
call :Begin "Windows Crash dumps"
del /q /f "%SystemRoot%\MEMORY.DMP" >nul 2>&1
del /s /f /q "%SystemRoot%\LiveKernelReports\*.dmp" >nul 2>&1
call :EmptyDir "%SystemRoot%\Minidump"
call :EmptyDir "%SystemRoot%\LiveKernelReports\WATCHDOG"
call :EmptyDir "%SystemRoot%\LiveKernelReports\WHEA"
call :EmptyDir "%LOCALAPPDATA%\CrashDumps"
call :End

REM ========================================================
call :Begin "Windows logs"
call :EmptyDir "%SystemRoot%\debug\WIA"
call :EmptyDir "%SystemRoot%\Logs\CBS"
call :EmptyDir "%SystemRoot%\Logs\DISM"
call :EmptyDir "%SystemRoot%\Logs\WindowsUpdate"
call :EmptyDir "%SystemRoot%\Logs\waasmedic"
call :EmptyDir "%SystemRoot%\Logs\SIH"
call :EmptyDir "%SystemRoot%\Logs\MeasuredBoot"
call :EmptyDir "%SystemRoot%\Logs\NetSetup"
call :EmptyDir "%SystemRoot%\Logs\MoSetup"
call :EmptyDir "%ProgramData%\USOShared\Logs\System"
call :EmptyDir "%ProgramData%\USOShared\Logs\User"
call :EmptyDir "%LOCALAPPDATA%\CrashReportClient\Saved\Logs"
call :EmptyDir "%USERPROFILE%\.copilot\logs"

del /q /f "%SystemRoot%\Logs\DirectX.txt" >nul 2>&1
del /q /f "%SystemRoot%\Logs\StorGroupPolicy.txt" >nul 2>&1
del /q /f "%SystemRoot%\Logs\WinREAgent\setup*.txt" >nul 2>&1
del /q /f "%SystemRoot%\debug\WIA\wiatrace.txt" >nul 2>&1
call :End

REM ========================================================
call :Begin "Windows extras"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
for /d %%d in ("%LOCALAPPDATA%\cache\qtshadercache*") do call :EmptyDir "%%d"
del /q /f /s "%LOCALAPPDATA%\CEF\User Data\CrashpadMetrics*.pma" >nul 2>&1
call :EmptyDir "%LOCALAPPDATA%\HD-Player\cache\qmlcache"
for /d %%d in ("%LOCALAPPDATA%\HD-Player\cache\qtpipelinecache-*") do call :EmptyDir "%%d"
call :End

REM ========================================================
call :Begin "Web browsers cache"
taskkill /F /IM chrome.exe /T >nul 2>&1
taskkill /F /IM msedge.exe /T >nul 2>&1
taskkill /F /IM brave.exe /T >nul 2>&1

REM 1.1 Google Chrome Root Folder
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Crashpad"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\component_crx_cache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\GraphiteDawnCache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\GrShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\optimization_guide_model_store"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\screen_ai"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\ShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\WasmTtsEngine"

REM 1.2 Google Chrome Default Profile Cache
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\DawnGraphiteCache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\DawnWebGPUCache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GPUCache"
call :EmptyDir "%LOCALAPPDATA%\Google\Chrome\User Data\Default\image_cache"

REM 1.3 Google Chrome Other Profiles Cache
for /d %%p in ("%LOCALAPPDATA%\Google\Chrome\User Data\Profile*") do (
    call :EmptyDir "%%p\Cache"
    call :EmptyDir "%%p\Code Cache"
    call :EmptyDir "%%p\DawnGraphiteCache"
    call :EmptyDir "%%p\DawnWebGPUCache"
    call :EmptyDir "%%p\GPUCache"
    call :EmptyDir "%%p\image_cache"
)

REM 2.1 Microsoft Edge Root Folder
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\component_crx_cache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Crashpad"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\GPUPersistentCache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\GraphiteDawnCache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\GrShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\ProvenanceData"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\ProvenanceDataAllowList"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\ProvenanceDataTensors"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\ShaderCache"

REM 2.2 Microsoft Edge Default Profile Cache
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\DawnGraphiteCache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\DawnWebGPUCache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\GPUCache"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\image_cache"

REM 3.1 Brave Root Folder
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\component_crx_cache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Crashpad"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\GPUPersistentCache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\GrShaderCache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\ShaderCache"

REM 3.2 Brave Default Profile Cache
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\DawnGraphiteCache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\DawnWebGPUCache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\GPUCache"
call :EmptyDir "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\JumpListIconsRecentClosed"
call :End

REM ========================================================
call :Begin "Steam cache"
taskkill /F /IM steam.exe /T >nul 2>&1
taskkill /F /IM steamwebhelper.exe /T >nul 2>&1
taskkill /F /IM GameOverlayUI.exe /T >nul 2>&1

call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\GraphiteDawnCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\GrShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\ShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\blob_storage"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\Cache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\Code Cache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\DawnGraphiteCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\DawnWebGPUCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\GPUCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\GraphiteDawnCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\GrShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\ShaderCache"
call :EmptyDir "%LOCALAPPDATA%\Steam\htmlcache\Default\VideoDecodeStats"

del /q /f "%LOCALAPPDATA%\Steam\htmlcache\Default\History.*" >nul 2>&1
del /q /f "%LOCALAPPDATA%\Steam\htmlcache\Default\InterestGroups.*" >nul 2>&1
del /q /f "%LOCALAPPDATA%\Steam\htmlcache\Default\Visited Links.*" >nul 2>&1
del /q /f "%LOCALAPPDATA%\Steam\htmlcache\Default\Web Data.*" >nul 2>&1
call :End

REM ========================================================
call :Begin "EA desktop cache"
taskkill /F /IM EADesktop.exe /T >nul 2>&1
taskkill /F /IM EABackgroundService.exe /T >nul 2>&1
taskkill /F /IM EACefSubProcess.exe /T >nul 2>&1
taskkill /F /IM EALocalHostSvc.exe /T >nul 2>&1

call :EmptyDir "%LOCALAPPDATA%\EALaunchHelper\cache\qmlcache"
call :EmptyDir "%LOCALAPPDATA%\EADesktop\cache\qmlcache"
call :EmptyDir "%LOCALAPPDATA%\Electronic Arts\EA Desktop\CEF"
call :EmptyDir "%LOCALAPPDATA%\Electronic Arts\EA Desktop\Logs"
call :EmptyDir "%LOCALAPPDATA%\Electronic Arts\EA Desktop\IGOCache"
call :EmptyDir "%LOCALAPPDATA%\Electronic Arts\EA Desktop\UIC"
del /q /f "%LOCALAPPDATA%\Electronic Arts\EA Desktop\telemetry.ini" >nul 2>&1
call :End

REM ========================================================
call :Begin "Epic Games + Discord caches"
taskkill /F /IM EpicGamesLauncher.exe /T >nul 2>&1
taskkill /F /IM EpicOnlineServicesUserHelper.exe /T >nul 2>&1
taskkill /F /IM EpicWebHelper.exe /T >nul 2>&1
taskkill /F /IM Discord.exe /T >nul 2>&1
taskkill /F /IM DiscordSystemHelper.exe /T >nul 2>&1

REM Epic Games
call :EmptyDir "%LOCALAPPDATA%\Epic Games\Epic Online Services\Bootstrapper\Logs"
call :EmptyDir "%LOCALAPPDATA%\Epic Games\Epic Online Services\EpicOnlineServicesHost\Logs"
call :EmptyDir "%LOCALAPPDATA%\Epic Games\Epic Online Services\InstallHelper\Logs"
call :EmptyDir "%LOCALAPPDATA%\Epic Games\Epic Online Services\InstallHelper\CrashLogs\Saved\Logs"
call :EmptyDir "%LOCALAPPDATA%\Epic Games\Epic Online Services\MainService\Logs"
call :EmptyDir "%LOCALAPPDATA%\Epic Games\Epic Online Services\MainService\Crashes"
call :EmptyDir "%LOCALAPPDATA%\EpicGamesLauncher\Saved\Logs"

for /d %%p in ("%LOCALAPPDATA%\EpicGamesLauncher\Saved\webcache_*") do (
    call :EmptyDir "%%p\Cache"
    call :EmptyDir "%%p\Code Cache"
    call :EmptyDir "%%p\blob_storage"
    call :EmptyDir "%%p\VideoDecodeStats"
    call :EmptyDir "%%p\shared_proto_db"
)

REM Discord
del /q /f "%LOCALAPPDATA%\Discord\packages\Discord-*.nupkg" >nul 2>&1
call :EmptyDir "%APPDATA%\discord\Cache\Cache_Data"
call :EmptyDir "%APPDATA%\discord\component_crx_cache"
call :EmptyDir "%APPDATA%\discord\blob_storage"
call :EmptyDir "%APPDATA%\discord\Code Cache"
call :EmptyDir "%APPDATA%\discord\Crashpad\attachments"
call :EmptyDir "%APPDATA%\discord\Crashpad\reports"
call :EmptyDir "%APPDATA%\discord\DawnGraphiteCache"
call :EmptyDir "%APPDATA%\discord\DawnWebGPUCache"
call :EmptyDir "%APPDATA%\discord\GPUCache"
call :EmptyDir "%APPDATA%\discord\logs"
call :End

REM ========================================================
call :Begin "Visual Studio Code cache"
call :EmptyDir "%APPDATA%\Code\Crashpad\reports"
call :EmptyDir "%APPDATA%\Code\User\History"
call :EmptyDir "%APPDATA%\Code\logs"
call :EmptyDir "%APPDATA%\Code\CachedData"
call :EmptyDir "%APPDATA%\Code\Cache\Cache_Data"
call :End

REM ========================================================
REM  Summary
REM ========================================================

call :GetFreeMB FREE_AFTER
set /a "FREED=FREE_AFTER-FREE_BEFORE"
if !FREED! lss 0 set "FREED=0"
call :FmtMB F_FREED !FREED!
call :FmtMB F_BEFORE !FREE_BEFORE!
call :FmtMB F_AFTER !FREE_AFTER!

echo.
set "BC=%GREEN%"
call :BoxTop
call :BoxLine "   Cleaning Complete." "%BOLD%"
call :BoxLine ""
call :BoxLine "   Space freed : !F_FREED!"
call :BoxLine "   Free space  : !F_BEFORE!  to  !F_AFTER!"
call :BoxBottom
echo.

chcp !OLDCP! >nul

REM It only wait for a key when the script was double-clicked
echo %cmdcmdline% | find /i "/c" >nul && (echo   %DIM%Press any key to close...%RESET% & pause >nul)

endlocal
exit /b

REM ========================================================
REM  Subroutines
REM ========================================================

REM Step start
:Begin
set /a "STEP+=1"
set "SN= !STEP!"
set "SN=!SN:~-2!"
set "TT=%~1                                   "
set "TT=!TT:~0,28!"
call :GetFreeMB STEPSTART
<nul set /p "=%ESC%[93m  ●%RESET% [!SN!/%TOTAL%] !TT! %DIM%working...%RESET%"
exit /b

REM Step end
:End
call :GetFreeMB NOWMB
set /a "GAIN=NOWMB-STEPSTART"
if !GAIN! lss 0 set "GAIN=0"
set /a "PCT=STEP*100/TOTAL, FILLED=STEP*BARW/TOTAL"

set "BAR="
for /l %%i in (1,1,%BARW%) do if %%i leq !FILLED! (set "BAR=!BAR!█") else (set "BAR=!BAR!░")

if !GAIN! gtr 0 (
    call :FmtMB FMT !GAIN!
    set "FP=           +!FMT!"
    set "FC=%GREEN%"
) else (
    set "FP=           —"
    set "FC=%DIM%"
)
set "FP=!FP:~-10!"
set "PP=    !PCT!"
set "PP=!PP:~-3!"

<nul set /p "=%ESC%[2K%ESC%[1G"
echo %GREEN%  ✔%RESET% [!SN!/%TOTAL%] !TT! !FC!!FP!%RESET%  %CYAN%!BAR!%RESET% %DIM%!PP!%%%RESET%
exit /b

REM Box drawing
:BoxTop
echo !BC!  ╔══════════════════════════════════════════════════════════════════╗%RESET%
exit /b

:BoxBottom
echo !BC!  ╚══════════════════════════════════════════════════════════════════╝%RESET%
exit /b

:BoxLine
set "BL=%~1                                                                      "
set "BL=!BL:~0,66!"
echo !BC!  ║%RESET%%~2!BL!%RESET%!BC!║%RESET%
exit /b

REM Free space of the system drive, in Mo 1024-based, like Windows, returned in %1
:GetFreeMB
set "_b=0"
for /f "tokens=3" %%a in ('dir /-c "%SystemDrive%\" 2^>nul') do set "_b=%%a"
if "!_b:~6,1!"=="" (
    set /a "%~1=0"
    exit /b
)
set "_h=!_b:~0,-6!"
set "_l=1!_b:~-6!"
set /a "_l-=1000000"
set /a "_q=_h/16384, _r=_h%%16384, _t=_r*15625+_l/64"
set /a "%~1=_q*15625+_t/16384"
exit /b

REM Formats a size in Mo as "123 Mo" or "1.23 Go", returned in %1
:FmtMB
if %~2 geq 1024 (
    set /a "_g=%~2/1024, _d=(%~2%%1024)*100/1024"
    if !_d! lss 10 set "_d=0!_d!"
    set "%~1=!_g!.!_d! Go"
) else (
    set "%~1=%~2 Mo"
)
exit /b

REM Empties a directory without deleting the folder itself
:EmptyDir
if "%~1"=="" exit /b
if exist "%~1\" (
    del /q /f /s "%~1\*.*" >nul 2>&1
    for /d %%x in ("%~1\*") do rd /s /q "%%x" >nul 2>&1
)
exit /b
