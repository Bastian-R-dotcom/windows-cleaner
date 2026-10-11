@echo off
setlocal EnableDelayedExpansion

echo =========================================
echo Windows Cleaner starting ..
echo =========================================

call :GetFree FREE_BEFORE

echo [1/9] Cleaning TEMP Dirs...
call :EmptyDir "%SystemRoot%\Temp"
call :EmptyDir "%TEMP%"
call :EmptyDir "%LOCALAPPDATA%\Temp"

echo [2/9] Cleaning Recycle Bin...
rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1

echo [3/9] Cleaning Windows Update...
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop cryptsvc /y >nul 2>&1
call :EmptyDir "%SystemRoot%\System32\catroot2"
call :EmptyDir "%SystemRoot%\SoftwareDistribution\Download"
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptsvc >nul 2>&1

echo [4/9] Cleaning Windows Dumps...
del /q /f "%SystemRoot%\MEMORY.DMP" >nul 2>&1
del /s /f /q "%SystemRoot%\LiveKernelReports\*.dmp" >nul 2>&1
call :EmptyDir "%SystemRoot%\Minidump"

echo [5/9] Cleaning Windows Extra...
call :EmptyDir "%LOCALAPPDATA%\CrashDumps"
call :EmptyDir "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
for /d %%d in ("%LOCALAPPDATA%\cache\qtshadercache*") do call :EmptyDir "%%d"
call :EmptyDir "%LOCALAPPDATA%\CrashReportClient\Saved\Logs"
del /q /f /s "%LOCALAPPDATA%\CEF\User Data\CrashpadMetrics*.pma" >nul 2>&1
call :EmptyDir "%LOCALAPPDATA%\HD-Player\cache\qmlcache"
for /d %%d in ("%LOCALAPPDATA%\HD-Player\cache\qtpipelinecache-*") do call :EmptyDir "%%d"

del /q /f "%SystemRoot%\debug\WIA\wiatrace.txt" >nul 2>&1
call :EmptyDir "%SystemRoot%\Logs\CBS"
call :EmptyDir "%SystemRoot%\Logs\DISM"
call :EmptyDir "%SystemRoot%\Logs\WindowsUpdate"
call :EmptyDir "%SystemRoot%\Logs\waasmedic"
call :EmptyDir "%SystemRoot%\Logs\SIH"
del /q /f "%SystemRoot%\Logs\WinREAgent\setup*.txt" >nul 2>&1
call :EmptyDir "%SystemRoot%\Logs\MeasuredBoot"
del /q /f "%SystemRoot%\Logs\DirectX.txt" >nul 2>&1
del /q /f "%SystemRoot%\Logs\StorGroupPolicy.txt" >nul 2>&1
call :EmptyDir "%SystemRoot%\Logs\NetSetup"
call :EmptyDir "%SystemRoot%\Logs\MoSetup"
del /q /f "%SystemRoot%\SystemTemp\*.txt" >nul 2>&1
del /q /f "%SystemRoot%\SystemTemp\*.tmp" >nul 2>&1

echo [6/9] Cleaning Web Browsers Cache...
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

echo [7/9] Cleaning Steam Cache...
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

echo [8/9] Cleaning EA Cache...
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

echo [9/9] Cleaning Epic Games ^& Discord Caches...
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

echo =========================================
echo Windows Cleaner did his job !
echo =========================================

call :GetFree FREE_AFTER
set /a "FREED_MB=(%FREE_AFTER:~0,-6%)-(%FREE_BEFORE:~0,-6%)"
if %FREED_MB% lss 0 set "FREED_MB=0"
set /a "GB_INT=FREED_MB/1000"
set /a "GB_DEC=(FREED_MB%%1000)/10"
set "GB_DEC=0%GB_DEC%"
echo Freed : %GB_INT%.%GB_DEC:~-2% GB

endlocal
exit /b

REM --------------------------------------------------------
REM Subroutine: Empties a directory without deleting the root folder itself.
REM --------------------------------------------------------

:EmptyDir
if "%~1"=="" exit /b
if exist "%~1\" (
    del /q /f /s "%~1\*.*" >nul 2>&1
    for /d %%x in ("%~1\*") do rd /s /q "%%x" >nul 2>&1
)

:GetFree
set "%~1="
for /f "tokens=3" %%a in ('dir /-c "%SystemDrive%\" 2^>nul') do set "%~1=%%a"
exit /b