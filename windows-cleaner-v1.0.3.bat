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
set "CLEANER_POWERSHELL=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe" set "CLEANER_POWERSHELL=%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe"
call :PrepareConsole

REM Use the same colors and drawing characters throughout the report.
set "RESET="
set "BOLD="
set "DIM="
set "GREEN="
set "YELLOW="
set "CYAN="
set "CLEANER_BOX_GLYPHS=+-+|++"
set "BAR_FILL=#"
set "BAR_EMPTY=-"
set "WORK_MARK=."
set "NO_GAIN=-"
if defined ESC (
    set "RESET=!ESC![0m"
    set "BOLD=!ESC![1m"
    set "DIM=!ESC![90m"
    set "GREEN=!ESC![92m"
    set "YELLOW=!ESC![93m"
    set "CYAN=!ESC![96m"
    set "CLEANER_BOX_GLYPHS=╔═╗║╚╝"
    set "BAR_FILL=█"
    set "BAR_EMPTY=░"
    set "WORK_MARK=●"
    set "NO_GAIN=—"
)
set "BOX_RULE="
for /l %%i in (1,1,66) do set "BOX_RULE=!BOX_RULE!!CLEANER_BOX_GLYPHS:~1,1!"

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

call :ShowDiskHealth
echo.

chcp !OLDCP! >nul

REM It only wait for a key when the script was double-clicked
echo %cmdcmdline% | find /i "/c" >nul && (echo   %DIM%Press any key to close...%RESET% & pause >nul)

endlocal
exit /b

REM ========================================================
REM  Subroutines
REM ========================================================

REM Check capabilities with the same PowerShell used for Disk Health.
:PrepareConsole
set "ESC="
call :InitializeConsole
if "%errorlevel%"=="0" (
    for /f %%a in ('echo prompt $E ^| cmd /d') do set "ESC=%%a"
) else if errorlevel 2 (
    cls 2>nul
)
exit /b 0

:InitializeConsole
setlocal DisableDelayedExpansion
set "CLEANER_BATCH_PATH=%~f0"
"%CLEANER_POWERSHELL%" -NoLogo -NoProfile -NonInteractive -Command "$ErrorActionPreference = 'Stop'; try { $source = Get-Content -LiteralPath $env:CLEANER_BATCH_PATH -Encoding UTF8 | Where-Object { $_.StartsWith('::CONSOLEPS ') } | ForEach-Object { $_.Substring(12) }; exit (& ([scriptblock]::Create($source -join [Environment]::NewLine))) } catch { exit 2 }" 2>nul
endlocal & exit /b %errorlevel%

REM Step start
:Begin
set /a "STEP+=1"
set "SN= !STEP!"
set "SN=!SN:~-2!"
set "TT=%~1                                   "
set "TT=!TT:~0,28!"
call :GetFreeMB STEPSTART
if defined ESC (
    <nul set /p "=%YELLOW%  !WORK_MARK!%RESET% [!SN!/%TOTAL%] !TT! %DIM%working...%RESET%"
)
exit /b

REM Step end
:End
call :GetFreeMB NOWMB
set /a "GAIN=NOWMB-STEPSTART"
if !GAIN! lss 0 set "GAIN=0"
set /a "PCT=STEP*100/TOTAL, FILLED=STEP*BARW/TOTAL"

set "BAR="
for /l %%i in (1,1,%BARW%) do if %%i leq !FILLED! (set "BAR=!BAR!!BAR_FILL!") else (set "BAR=!BAR!!BAR_EMPTY!")

if !GAIN! gtr 0 (
    call :FmtMB FMT !GAIN!
    set "FP=           +!FMT!"
    set "FC=%GREEN%"
) else (
    set "FP=           !NO_GAIN!"
    set "FC=%DIM%"
)
set "FP=!FP:~-10!"
set "PP=    !PCT!"
set "PP=!PP:~-3!"

if defined ESC <nul set /p "=%ESC%[2K%ESC%[1G"
echo %GREEN%  V%RESET% [!SN!/%TOTAL%] !TT! !FC!!FP!%RESET%  %CYAN%!BAR!%RESET% %DIM%!PP!%%%RESET%
exit /b

REM Box drawing
:BoxTop
echo !BC!  !CLEANER_BOX_GLYPHS:~0,1!!BOX_RULE!!CLEANER_BOX_GLYPHS:~2,1!%RESET%
exit /b

:BoxBottom
echo !BC!  !CLEANER_BOX_GLYPHS:~4,1!!BOX_RULE!!CLEANER_BOX_GLYPHS:~5,1!%RESET%
exit /b

:BoxLine
set "BL=%~1                                                                      "
set "BL=!BL:~0,66!"
echo !BC!  !CLEANER_BOX_GLYPHS:~3,1!%RESET%%~2!BL!%RESET%!BC!!CLEANER_BOX_GLYPHS:~3,1!%RESET%
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

REM Show the read-only disk report after cleaning.
:ShowDiskHealth
setlocal DisableDelayedExpansion
set "CLEANER_BATCH_PATH=%~f0"
"%CLEANER_POWERSHELL%" -NoLogo -NoProfile -NonInteractive -Command "$ErrorActionPreference = 'Stop'; $source = Get-Content -LiteralPath $env:CLEANER_BATCH_PATH -Encoding UTF8 | Where-Object { $_.StartsWith('::DISKPS ') } | ForEach-Object { $_.Substring(9) }; & ([scriptblock]::Create($source -join [Environment]::NewLine))" 2>nul
if errorlevel 1 (
    echo.
    echo       Disk health unavailable.
)
endlocal
exit /b 0

REM PowerShell embedded in this batch so the report needs no companion file.
::DISKPS $reportCyan = $reportYellowBold = $reportReset = ''
::DISKPS if (-not [Console]::IsOutputRedirected -and $env:ESC) {
::DISKPS     $reportCyan = $env:CYAN
::DISKPS     $reportYellowBold = $env:BOLD + $env:YELLOW
::DISKPS     $reportReset = $env:RESET
::DISKPS }
::DISKPS 
::DISKPS $boxCharacters = $env:CLEANER_BOX_GLYPHS
::DISKPS $reportEncoding = [Console]::OutputEncoding
::DISKPS if ($boxCharacters.Length -ne 6 -or
::DISKPS     $reportEncoding.GetString($reportEncoding.GetBytes($boxCharacters)) -ne $boxCharacters) {
::DISKPS     $boxCharacters = '+-+|++'
::DISKPS }
::DISKPS $diskTopLeft, $diskHorizontal, $diskTopRight, $diskVertical, $diskBottomLeft, $diskBottomRight = $boxCharacters.ToCharArray()
::DISKPS 
::DISKPS function Get-UniqueDiskMatch {
::DISKPS     param($Disk, $Inventory, $Candidates)
::DISKPS 
::DISKPS     foreach ($property in 'UniqueId', 'SerialNumber') {
::DISKPS         $value = ([string]($Disk.$property)).Trim()
::DISKPS         if (-not $value) { continue }
::DISKPS         $owners = @($Inventory | Where-Object { ([string]($_.$property)).Trim() -eq $value })
::DISKPS         if ($owners.Count -ne 1) { continue }
::DISKPS         $candidatesById = @($Candidates | Where-Object { ([string]($_.$property)).Trim() -eq $value })
::DISKPS         if ($candidatesById.Count -eq 1) { return $candidatesById[0] }
::DISKPS     }
::DISKPS }
::DISKPS 
::DISKPS function Get-AtaWmiRow {
::DISKPS     param($Device, $Win32Disks, $Rows)
::DISKPS 
::DISKPS     $deviceId = $Device.PNPDeviceID
::DISKPS     if (-not $deviceId) { return }
::DISKPS 
::DISKPS     $indexedDevice = '^{0}_\d+$' -f [regex]::Escape($deviceId)
::DISKPS     $deviceRows = @($Rows | Where-Object {
::DISKPS         $_.InstanceName -eq $deviceId -or
::DISKPS         ($_.InstanceName -match $indexedDevice -and $_.InstanceName -notin $Win32Disks.PNPDeviceID)
::DISKPS     })
::DISKPS     if ($deviceRows.Count -eq 1) { return $deviceRows[0] }
::DISKPS }
::DISKPS 
::DISKPS function Write-DiskHeader {
::DISKPS     param([string]$Description)
::DISKPS 
::DISKPS     $contentWidth = 63
::DISKPS     $border = [string]$diskHorizontal * ($contentWidth + 3)
::DISKPS     $leftEdge = '{0}  {1}{2}   ' -f $reportCyan, $diskVertical, $reportReset
::DISKPS     $rightEdge = '{0}{1}{2}' -f $reportCyan, $diskVertical, $reportReset
::DISKPS 
::DISKPS     Write-Output ''
::DISKPS     Write-Output ('{0}  {1}{2}{3}{4}' -f $reportCyan, $diskTopLeft, $border, $diskTopRight, $reportReset)
::DISKPS     Write-Output ($leftEdge + $reportYellowBold + 'Disk Health:'.PadRight($contentWidth) + $reportReset + $rightEdge)
::DISKPS     for ($offset = 0; $offset -lt $Description.Length; $offset += $length) {
::DISKPS         $length = [Math]::Min($contentWidth, $Description.Length - $offset)
::DISKPS         if ($offset + $length -lt $Description.Length -and [char]::IsHighSurrogate($Description[$offset + $length - 1])) {
::DISKPS             $length--
::DISKPS         }
::DISKPS         $line = $Description.Substring($offset, $length).PadRight($contentWidth)
::DISKPS         Write-Output ($leftEdge + $line + $rightEdge)
::DISKPS     }
::DISKPS     Write-Output ('{0}  {1}{2}{3}{4}' -f $reportCyan, $diskBottomLeft, $border, $diskBottomRight, $reportReset)
::DISKPS }
::DISKPS 
::DISKPS function Write-DiskSectionTitle {
::DISKPS     param([string]$Title)
::DISKPS 
::DISKPS     Write-Output ''
::DISKPS     Write-Output ('        {0}' -f $Title)
::DISKPS }
::DISKPS 
::DISKPS function Write-DiskFields {
::DISKPS     param([string]$Title, $Fields)
::DISKPS 
::DISKPS     $available = @($Fields.GetEnumerator() | Where-Object {
::DISKPS         -not [string]::IsNullOrWhiteSpace([string]$_.Value)
::DISKPS     })
::DISKPS     if ($available.Count -eq 0) {
::DISKPS         Write-DiskSectionTitle -Title ('{0}: unavailable' -f $Title)
::DISKPS         return
::DISKPS     }
::DISKPS 
::DISKPS     Write-DiskSectionTitle -Title $Title
::DISKPS     Write-Output ''
::DISKPS     foreach ($field in $available) {
::DISKPS         Write-Output ('          {0,-32} {1}' -f $field.Key, $field.Value)
::DISKPS     }
::DISKPS }
::DISKPS 
::DISKPS function Write-AtaSmart {
::DISKPS     param($DataRow, $ThresholdRow, $StatusRow, [bool]$Rotating)
::DISKPS 
::DISKPS     [byte[]]$page = $DataRow.VendorSpecific
::DISKPS     if ($page.Length -ne 512 -or [BitConverter]::ToUInt16($page, 0) -in 0, 65535) {
::DISKPS         Write-DiskSectionTitle -Title 'ATA S.M.A.R.T. attributes: unavailable'
::DISKPS         if ($null -ne $StatusRow.PredictFailure) {
::DISKPS             Write-Output ''
::DISKPS             Write-Output ('          Device failure predicted: {0}' -f $StatusRow.PredictFailure)
::DISKPS         }
::DISKPS         return
::DISKPS     }
::DISKPS 
::DISKPS     [byte[]]$thresholdPage = $ThresholdRow.VendorSpecific
::DISKPS     $thresholds = @{}
::DISKPS     if ($thresholdPage.Length -eq 512) {
::DISKPS         for ($offset = 2; $offset -lt 362; $offset += 12) {
::DISKPS             $id = [int]$thresholdPage[$offset]
::DISKPS             if ($id) { $thresholds[$id] = $thresholdPage[$offset + 1] }
::DISKPS         }
::DISKPS     }
::DISKPS 
::DISKPS     # ATA raw values and vendor-specific IDs vary by model.
::DISKPS     $labels = @{
::DISKPS         '05' = 'Reallocation count'
::DISKPS         '09' = 'Power-on time'
::DISKPS         '0C' = 'Power cycle count'
::DISKPS         'BB' = 'Uncorrectable errors'
::DISKPS         'C2' = 'Temperature data'
::DISKPS         'C7' = 'Interface CRC errors'
::DISKPS     }
::DISKPS     if ($Rotating) {
::DISKPS         $labels['03'] = 'Spin-up time'
::DISKPS         $labels['04'] = 'Start-stop count'
::DISKPS         $labels['05'] = 'Reallocated sectors'
::DISKPS         $labels['07'] = 'Seek error rate'
::DISKPS         $labels['0A'] = 'Spin retry count'
::DISKPS         $labels['C1'] = 'Load-unload count'
::DISKPS         $labels['C4'] = 'Reallocation events'
::DISKPS         $labels['C5'] = 'Pending sectors'
::DISKPS         $labels['C6'] = 'Uncorrectable sectors'
::DISKPS     }
::DISKPS 
::DISKPS     Write-DiskSectionTitle -Title 'ATA S.M.A.R.T. (common attribute names)'
::DISKPS     Write-Output ''
::DISKPS     if ($null -ne $StatusRow.PredictFailure) {
::DISKPS         Write-Output ('          Failure predicted: {0}' -f $StatusRow.PredictFailure)
::DISKPS     }
::DISKPS     $tableRow = '        {0,-2} {1,-21} {2,3} {3,5} {4,3} {5,4} {6,15} {7,12}'
::DISKPS     Write-Output ($tableRow -f 'ID', 'Name', 'Now', 'Worst', 'Thr', 'Flag', 'Raw dec', 'Raw hex')
::DISKPS     $attributeCount = 0
::DISKPS     for ($offset = 2; $offset -lt 362; $offset += 12) {
::DISKPS         $id = [int]$page[$offset]
::DISKPS         if (-not $id) { continue }
::DISKPS         $attributeCount++
::DISKPS 
::DISKPS         $hexId = '{0:X2}' -f $id
::DISKPS         $name = $labels[$hexId]
::DISKPS         if (-not $name) { $name = 'Vendor-specific' }
::DISKPS 
::DISKPS         $raw = [uint64]0
::DISKPS         for ($byte = 5; $byte -ge 0; $byte--) {
::DISKPS             $raw = ($raw -shl 8) -bor [uint64]($page[$offset + 5 + $byte])
::DISKPS         }
::DISKPS 
::DISKPS         $threshold = '-'
::DISKPS         if ($thresholds.ContainsKey($id)) { $threshold = $thresholds[$id] }
::DISKPS         $flags = [BitConverter]::ToUInt16($page, $offset + 1)
::DISKPS         Write-Output ($tableRow -f $hexId, $name, $page[$offset + 3], $page[$offset + 4], $threshold,
::DISKPS             ('{0:X4}' -f $flags), $raw, ('{0:X12}' -f $raw))
::DISKPS     }
::DISKPS     if ($attributeCount -eq 0) { Write-Output '          Attributes: unavailable' }
::DISKPS }
::DISKPS 
::DISKPS function Get-NvmePage {
::DISKPS     param($DiskNumber)
::DISKPS 
::DISKPS     if ($null -eq $DiskNumber -or $DiskNumber -eq [uint32]::MaxValue) { return }
::DISKPS     try {
::DISKPS         if (-not ('Tweaksys.NvmeHealthReader' -as [type])) {
::DISKPS             Add-Type -AssemblyName System.Numerics
::DISKPS             Add-Type -TypeDefinition $nvmeInterop
::DISKPS         }
::DISKPS         $page = [Tweaksys.NvmeHealthReader]::Read([uint32]$DiskNumber)
::DISKPS         if ($null -ne $page) { return ,$page }
::DISKPS     } catch {
::DISKPS         # An inaccessible device or restricted PowerShell can reject this query.
::DISKPS     }
::DISKPS }
::DISKPS 
::DISKPS function Read-NvmeCounter {
::DISKPS     param([byte[]]$Page, [int]$Offset)
::DISKPS 
::DISKPS     # NVMe counters are unsigned 128-bit values. The extra byte keeps BigInteger positive.
::DISKPS     $bytes = New-Object byte[] 17
::DISKPS     [Array]::Copy($Page, $Offset, $bytes, 0, 16)
::DISKPS     return [System.Numerics.BigInteger]::new($bytes)
::DISKPS }
::DISKPS 
::DISKPS function Write-NvmeSmart {
::DISKPS     param([byte[]]$Page)
::DISKPS 
::DISKPS     if ($Page.Length -ne 512) {
::DISKPS         Write-DiskSectionTitle -Title 'NVMe S.M.A.R.T. log: unavailable'
::DISKPS         return
::DISKPS     }
::DISKPS 
::DISKPS     $warningFlags = @(
::DISKPS         'spare below threshold', 'temperature threshold', 'degraded reliability',
::DISKPS         'media read-only', 'volatile backup failure', 'persistent memory region issue'
::DISKPS     )
::DISKPS     $activeWarnings = @(for ($bit = 0; $bit -lt $warningFlags.Count; $bit++) {
::DISKPS         if ($Page[0] -band (1 -shl $bit)) { $warningFlags[$bit] }
::DISKPS     })
::DISKPS     $temperature = [BitConverter]::ToUInt16($Page, 1)
::DISKPS     $dataRead = Read-NvmeCounter -Page $Page -Offset 32
::DISKPS     $dataWritten = Read-NvmeCounter -Page $Page -Offset 48
::DISKPS     $health = [ordered]@{
::DISKPS         'Critical warning flags' = ('0x{0:X2}' -f $Page[0])
::DISKPS         'Critical warnings' = ($activeWarnings -join ', ')
::DISKPS         'Composite temperature' = $(if ($temperature) { '{0} C' -f ($temperature - 273) })
::DISKPS         'Available spare' = ('{0}%' -f $Page[3])
::DISKPS         'Spare threshold' = ('{0}%' -f $Page[4])
::DISKPS         'Endurance used' = ('{0}%' -f $Page[5])
::DISKPS         'Endurance remaining' = ('{0}%' -f [Math]::Max(0, 100 - [int]$Page[5]))
::DISKPS         'Endurance group warning flags' = ('0x{0:X2}' -f $Page[6])
::DISKPS         'Host bytes read (rounded)' = $(if ($dataRead -gt 0) { [System.Numerics.BigInteger]::Multiply($dataRead, 512000).ToString() })
::DISKPS         'Host bytes written (rounded)' = $(if ($dataWritten -gt 0) { [System.Numerics.BigInteger]::Multiply($dataWritten, 512000).ToString() })
::DISKPS         'Host read commands' = (Read-NvmeCounter -Page $Page -Offset 64)
::DISKPS         'Host write commands' = (Read-NvmeCounter -Page $Page -Offset 80)
::DISKPS         'Controller busy time (min)' = (Read-NvmeCounter -Page $Page -Offset 96)
::DISKPS         'Power cycles' = (Read-NvmeCounter -Page $Page -Offset 112)
::DISKPS         'Power-on hours' = (Read-NvmeCounter -Page $Page -Offset 128)
::DISKPS         'Unsafe shutdowns' = (Read-NvmeCounter -Page $Page -Offset 144)
::DISKPS         'Media and integrity errors' = (Read-NvmeCounter -Page $Page -Offset 160)
::DISKPS         'Error log entries' = (Read-NvmeCounter -Page $Page -Offset 176)
::DISKPS         'Warning temperature time (min)' = [BitConverter]::ToUInt32($Page, 192)
::DISKPS         'Critical temperature time (min)' = [BitConverter]::ToUInt32($Page, 196)
::DISKPS     }
::DISKPS     for ($sensor = 1; $sensor -le 8; $sensor++) {
::DISKPS         $kelvin = [BitConverter]::ToUInt16($Page, 200 + 2 * ($sensor - 1))
::DISKPS         if ($kelvin) { $health["Temperature sensor $sensor"] = '{0} C' -f ($kelvin - 273) }
::DISKPS     }
::DISKPS     Write-DiskFields -Title 'NVMe S.M.A.R.T. / Health Information' -Fields $health
::DISKPS }
::DISKPS 
::DISKPS function Write-SmartmontoolsDetails {
::DISKPS     param($DiskNumbers)
::DISKPS 
::DISKPS     if ($DiskNumbers.Count -eq 0) { return }
::DISKPS 
::DISKPS     $locations = @($env:ProgramW6432, $env:ProgramFiles, [Environment]::GetEnvironmentVariable('ProgramFiles(x86)'))
::DISKPS     $smartctl = $null
::DISKPS     foreach ($location in ($locations | Where-Object { $_ } | Select-Object -Unique)) {
::DISKPS         $candidate = Join-Path $location 'smartmontools\bin\smartctl.exe'
::DISKPS         if (Test-Path -LiteralPath $candidate -PathType Leaf) {
::DISKPS             $smartctl = $candidate
::DISKPS             break
::DISKPS         }
::DISKPS     }
::DISKPS     if (-not $smartctl) {
::DISKPS         $smartctl = (Get-Command 'smartctl.exe' -CommandType Application -ErrorAction SilentlyContinue |
::DISKPS             Select-Object -First 1).Source
::DISKPS     }
::DISKPS     if (-not $smartctl) { return }
::DISKPS 
::DISKPS     Write-Output ''
::DISKPS     Write-Output ('      {0}Extended S.M.A.R.T. (Smartmontools){1}' -f $reportCyan, $reportReset)
::DISKPS     foreach ($diskNumber in ($DiskNumbers | Sort-Object -Unique)) {
::DISKPS         Write-DiskSectionTitle -Title ('PhysicalDrive{0}' -f $diskNumber)
::DISKPS         Write-Output ''
::DISKPS         try {
::DISKPS             $report = @(& $smartctl -x ('/dev/pd{0}' -f $diskNumber))
::DISKPS             if ($report.Count -eq 0) {
::DISKPS                 Write-Output '          Extended S.M.A.R.T. unavailable.'
::DISKPS             } else {
::DISKPS                 $report | Where-Object { $_ -notmatch '^\s*Thermal Temp\. [12] (?:Transition Count|Total Time):' } |
::DISKPS                     ForEach-Object { '          ' + $_ }
::DISKPS             }
::DISKPS         } catch {
::DISKPS             Write-Output '          Extended S.M.A.R.T. unavailable.'
::DISKPS         }
::DISKPS     }
::DISKPS }
::DISKPS 
::DISKPS $nvmeInterop = @'
::DISKPS using System;
::DISKPS using System.Runtime.InteropServices;
::DISKPS using Microsoft.Win32.SafeHandles;
::DISKPS 
::DISKPS namespace Tweaksys
::DISKPS {
::DISKPS     public static class NvmeHealthReader
::DISKPS     {
::DISKPS         private const uint IoctlStorageQueryProperty = 0x002d1400;
::DISKPS         private const int DeviceProtocolProperty = 50;
::DISKPS         private const int AdapterProtocolProperty = 49;
::DISKPS         private const int ProtocolNvme = 3;
::DISKPS         private const int NvmeLogPage = 2;
::DISKPS         private const int HealthLog = 2;
::DISKPS         private const int HeaderSize = 8;
::DISKPS         private const int ProtocolSize = 40;
::DISKPS         private const int PageSize = 512;
::DISKPS         private const int BufferSize = HeaderSize + ProtocolSize + PageSize;
::DISKPS 
::DISKPS         [DllImport("kernel32.dll", EntryPoint = "CreateFileW", CharSet = CharSet.Unicode, ExactSpelling = true, SetLastError = true)]
::DISKPS         private static extern SafeFileHandle Open(string path, uint access, uint share,
::DISKPS             IntPtr security, uint creation, uint flags, IntPtr template);
::DISKPS 
::DISKPS         [DllImport("kernel32.dll", SetLastError = true)]
::DISKPS         [return: MarshalAs(UnmanagedType.Bool)]
::DISKPS         private static extern bool DeviceIoControl(SafeFileHandle disk, uint control,
::DISKPS             IntPtr input, int inputSize, IntPtr output, int outputSize,
::DISKPS             out int returnedBytes, IntPtr overlapped);
::DISKPS 
::DISKPS         public static byte[] Read(uint diskNumber)
::DISKPS         {
::DISKPS             string path = @"\\.\PhysicalDrive" + diskNumber;
::DISKPS             const uint readAccess = 0x80000000;
::DISKPS             const uint shareReadWrite = 3;
::DISKPS             const uint openExisting = 3;
::DISKPS 
::DISKPS             using (SafeFileHandle disk = Open(path, readAccess, shareReadWrite, IntPtr.Zero, openExisting, 0, IntPtr.Zero))
::DISKPS             {
::DISKPS                 if (!disk.IsInvalid)
::DISKPS                 {
::DISKPS                     byte[] page = Query(disk, DeviceProtocolProperty) ?? Query(disk, AdapterProtocolProperty);
::DISKPS                     if (page != null)
::DISKPS                         return page;
::DISKPS                 }
::DISKPS             }
::DISKPS             using (SafeFileHandle disk = Open(path, 0, shareReadWrite, IntPtr.Zero, openExisting, 0, IntPtr.Zero))
::DISKPS             {
::DISKPS                 return disk.IsInvalid ? null : (Query(disk, DeviceProtocolProperty) ?? Query(disk, AdapterProtocolProperty));
::DISKPS             }
::DISKPS         }
::DISKPS 
::DISKPS         private static byte[] Query(SafeFileHandle disk, int property)
::DISKPS         {
::DISKPS             IntPtr buffer = Marshal.AllocHGlobal(BufferSize);
::DISKPS             try
::DISKPS             {
::DISKPS                 Marshal.Copy(new byte[BufferSize], 0, buffer, BufferSize);
::DISKPS                 Marshal.WriteInt32(buffer, 0, property);
::DISKPS                 Marshal.WriteInt32(buffer, HeaderSize, ProtocolNvme);
::DISKPS                 Marshal.WriteInt32(buffer, HeaderSize + 4, NvmeLogPage);
::DISKPS                 Marshal.WriteInt32(buffer, HeaderSize + 8, HealthLog);
::DISKPS                 Marshal.WriteInt32(buffer, HeaderSize + 16, ProtocolSize);
::DISKPS                 Marshal.WriteInt32(buffer, HeaderSize + 20, PageSize);
::DISKPS 
::DISKPS                 int returned;
::DISKPS                 if (!DeviceIoControl(disk, IoctlStorageQueryProperty, buffer, BufferSize,
::DISKPS                     buffer, BufferSize, out returned, IntPtr.Zero) ||
::DISKPS                     returned < HeaderSize + ProtocolSize || returned > BufferSize)
::DISKPS                     return null;
::DISKPS 
::DISKPS                 int dataOffset = Marshal.ReadInt32(buffer, HeaderSize + 16);
::DISKPS                 int dataLength = Marshal.ReadInt32(buffer, HeaderSize + 20);
::DISKPS                 if (Marshal.ReadInt32(buffer, 0) < HeaderSize + ProtocolSize ||
::DISKPS                     Marshal.ReadInt32(buffer, 4) < HeaderSize + ProtocolSize ||
::DISKPS                     Marshal.ReadInt32(buffer, HeaderSize) != ProtocolNvme ||
::DISKPS                     Marshal.ReadInt32(buffer, HeaderSize + 4) != NvmeLogPage ||
::DISKPS                     dataOffset < ProtocolSize || dataOffset > returned - HeaderSize - PageSize ||
::DISKPS                     dataLength < PageSize || dataLength > returned - HeaderSize - dataOffset)
::DISKPS                     return null;
::DISKPS 
::DISKPS                 byte[] page = new byte[PageSize];
::DISKPS                 Marshal.Copy(IntPtr.Add(buffer, HeaderSize + dataOffset), page, 0, PageSize);
::DISKPS                 return Array.Exists(page, value => value != 0) ? page : null;
::DISKPS             }
::DISKPS             finally
::DISKPS             {
::DISKPS                 Marshal.FreeHGlobal(buffer);
::DISKPS             }
::DISKPS         }
::DISKPS     }
::DISKPS }
::DISKPS '@
::DISKPS 
::DISKPS $disks = @(Get-PhysicalDisk -WarningAction SilentlyContinue -ErrorAction SilentlyContinue)
::DISKPS $windowsDisks = @(Get-Disk -WarningAction SilentlyContinue -ErrorAction SilentlyContinue)
::DISKPS $win32Disks = @(Get-CimInstance -ClassName Win32_DiskDrive -Property Index, PNPDeviceID, SerialNumber, Model, Size, FirmwareRevision, InterfaceType, Status, BytesPerSector -ErrorAction SilentlyContinue)
::DISKPS 
::DISKPS $reliabilityFields = [ordered]@{
::DISKPS     'Temperature' = 'Temperature (C)'
::DISKPS     'TemperatureMax' = 'Operating temperature max (C)'
::DISKPS     'Wear' = 'Endurance used (%)'
::DISKPS     'PowerOnHours' = 'Power-on hours'
::DISKPS     'ManufactureDate' = 'Manufacture date'
::DISKPS     'StartStopCycleCount' = 'Start-stop cycles'
::DISKPS     'StartStopCycleCountMax' = 'Start-stop cycle max'
::DISKPS     'LoadUnloadCycleCount' = 'Load-unload cycles'
::DISKPS     'LoadUnloadCycleCountMax' = 'Load-unload cycle max'
::DISKPS     'ReadErrorsTotal' = 'Read errors, total'
::DISKPS     'ReadErrorsCorrected' = 'Read errors, corrected'
::DISKPS     'ReadErrorsUncorrected' = 'Read errors, uncorrected'
::DISKPS     'WriteErrorsTotal' = 'Write errors, total'
::DISKPS     'WriteErrorsCorrected' = 'Write errors, corrected'
::DISKPS     'WriteErrorsUncorrected' = 'Write errors, uncorrected'
::DISKPS     'ReadLatencyMax' = 'Read latency max (ms)'
::DISKPS     'WriteLatencyMax' = 'Write latency max (ms)'
::DISKPS     'FlushLatencyMax' = 'Flush latency max (ms)'
::DISKPS }
::DISKPS 
::DISKPS $busNames = @{
::DISKPS     '0' = 'Unknown'; '1' = 'SCSI'; '2' = 'ATAPI'; '3' = 'ATA'; '4' = 'IEEE 1394'
::DISKPS     '5' = 'SSA'; '6' = 'Fibre Channel'; '9' = 'iSCSI'
::DISKPS     '11' = 'SATA'; '12' = 'SD'; '13' = 'MMC'; '14' = 'Virtual'
::DISKPS     '15' = 'File-backed virtual'; '16' = 'Storage Spaces'; '17' = 'NVMe'
::DISKPS     '18' = 'SCM'; '19' = 'UFS'
::DISKPS }
::DISKPS 
::DISKPS $entries = [System.Collections.Generic.List[object]]::new()
::DISKPS $reportedNumbers = @{}
::DISKPS foreach ($disk in $disks) {
::DISKPS     $osDisk = Get-UniqueDiskMatch -Disk $disk -Inventory $disks -Candidates $windowsDisks
::DISKPS     $device = $null
::DISKPS     if ($osDisk) {
::DISKPS         $deviceMatches = @($win32Disks | Where-Object { $_.Index -eq $osDisk.Number })
::DISKPS         if ($deviceMatches.Count -eq 1) { $device = $deviceMatches[0] }
::DISKPS     }
::DISKPS     if (-not $device) {
::DISKPS         $serialMatch = Get-UniqueDiskMatch -Disk $disk -Inventory $disks -Candidates $win32Disks
::DISKPS         if ($serialMatch -and (-not $osDisk -or $serialMatch.Index -eq $osDisk.Number)) {
::DISKPS             $device = $serialMatch
::DISKPS         }
::DISKPS     }
::DISKPS     if ($device -and -not $osDisk) {
::DISKPS         $osMatches = @($windowsDisks | Where-Object { $_.Number -eq $device.Index })
::DISKPS         if ($osMatches.Count -eq 1) { $osDisk = $osMatches[0] }
::DISKPS     }
::DISKPS 
::DISKPS     $entries.Add([pscustomobject]@{ Physical = $disk; OsDisk = $osDisk; Device = $device })
::DISKPS     if ($osDisk) { $reportedNumbers[[uint32]$osDisk.Number] = $true }
::DISKPS     if ($device -and $device.Index -ne [uint32]::MaxValue) {
::DISKPS         $reportedNumbers[[uint32]$device.Index] = $true
::DISKPS     }
::DISKPS }
::DISKPS foreach ($osDisk in $windowsDisks) {
::DISKPS     if ($reportedNumbers.ContainsKey([uint32]$osDisk.Number)) { continue }
::DISKPS     $deviceMatches = @($win32Disks | Where-Object { $_.Index -eq $osDisk.Number })
::DISKPS     $device = $null
::DISKPS     if ($deviceMatches.Count -eq 1) { $device = $deviceMatches[0] }
::DISKPS     $entries.Add([pscustomobject]@{ Physical = $null; OsDisk = $osDisk; Device = $device })
::DISKPS     $reportedNumbers[[uint32]$osDisk.Number] = $true
::DISKPS }
::DISKPS foreach ($device in $win32Disks) {
::DISKPS     if ($device.Index -eq [uint32]::MaxValue -or $reportedNumbers.ContainsKey([uint32]$device.Index)) { continue }
::DISKPS     $entries.Add([pscustomobject]@{ Physical = $null; OsDisk = $null; Device = $device })
::DISKPS     $reportedNumbers[[uint32]$device.Index] = $true
::DISKPS }
::DISKPS 
::DISKPS # Filter after matching Windows inventories so excluded disks cannot
::DISKPS # reappear as fallback entries for the same Windows disk number.
::DISKPS $excludedBuses = '7', 'USB', '8', 'RAID', '10', 'SAS'
::DISKPS $entries = @($entries | Where-Object {
::DISKPS     ([string]$_.Physical.BusType -notin $excludedBuses) -and
::DISKPS     ([string]$_.OsDisk.BusType -notin $excludedBuses) -and
::DISKPS     ([string]$_.Device.InterfaceType -notin $excludedBuses) -and
::DISKPS     ([string]$_.Device.PNPDeviceID -notmatch '^USBSTOR\\')
::DISKPS })
::DISKPS if ($entries.Count -eq 0) {
::DISKPS     Write-DiskHeader -Description 'No supported disks to report.'
::DISKPS     return
::DISKPS }
::DISKPS 
::DISKPS $deviceIds = @($entries | ForEach-Object { $_.Device.PNPDeviceID } | Where-Object { $_ } | Sort-Object -Unique)
::DISKPS $ataData = @()
::DISKPS $ataThresholds = @()
::DISKPS $ataStatus = @()
::DISKPS if ($deviceIds.Count -gt 0) {
::DISKPS     $ataFilter = @(foreach ($deviceId in $deviceIds) {
::DISKPS         $literal = $deviceId.Replace('\', '\\').Replace("'", "\'").Replace('"', '\"')
::DISKPS         $pattern = $literal.Replace('[', '[[]').Replace('%', '[%]').Replace('_', '[_]')
::DISKPS         "InstanceName = '$literal' OR InstanceName LIKE '$($pattern)[_][0-9]%'"
::DISKPS     }) -join ' OR '
::DISKPS 
::DISKPS     $ataData = @(Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictData -Filter $ataFilter -ErrorAction SilentlyContinue)
::DISKPS     $ataThresholds = @(Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictThresholds -Filter $ataFilter -ErrorAction SilentlyContinue)
::DISKPS     $ataStatus = @(Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictStatus -Filter $ataFilter -ErrorAction SilentlyContinue)
::DISKPS }
::DISKPS 
::DISKPS $smartmontoolsDiskNumbers = [System.Collections.Generic.List[uint32]]::new()
::DISKPS foreach ($entry in $entries) {
::DISKPS     $disk = $entry.Physical
::DISKPS     $osDisk = $entry.OsDisk
::DISKPS     $device = $entry.Device
::DISKPS     $diskNumber = if ($osDisk) { $osDisk.Number } elseif ($device -and $device.Index -ne [uint32]::MaxValue) { $device.Index }
::DISKPS     if ($null -ne $diskNumber) { $smartmontoolsDiskNumbers.Add([uint32]$diskNumber) }
::DISKPS     $storageDisk = if ($disk) { $disk } else { $osDisk }
::DISKPS     $names = $disk.FriendlyName, $disk.Model, $osDisk.FriendlyName, $device.Model, 'Unnamed disk'
::DISKPS     $name = $names | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Select-Object -First 1
::DISKPS     $bus = if ($storageDisk.BusType) { [string]$storageDisk.BusType } else { [string]$device.InterfaceType }
::DISKPS     if ($busNames.ContainsKey($bus)) { $bus = $busNames[$bus] }
::DISKPS     if ($bus -eq 'Unknown' -and $osDisk.BusType) {
::DISKPS         $bus = [string]$osDisk.BusType
::DISKPS         if ($busNames.ContainsKey($bus)) { $bus = $busNames[$bus] }
::DISKPS     }
::DISKPS     $type = switch ([string]$disk.MediaType) {
::DISKPS         { $_ -in '3', 'HDD' } { 'HDD'; break }
::DISKPS         { $_ -in '4', 'SSD' } { 'SSD'; break }
::DISKPS         { $_ -in '5', 'SCM' } { 'SCM'; break }
::DISKPS         default { 'Unknown media' }
::DISKPS     }
::DISKPS     if ($bus -eq 'NVMe') {
::DISKPS         $type = 'NVMe SSD'
::DISKPS     } elseif ($type -eq 'Unknown media' -and $disk.SpindleSpeed -gt 0) {
::DISKPS         $type = 'HDD'
::DISKPS     }
::DISKPS 
::DISKPS     $healthStatus = switch ([string]$storageDisk.HealthStatus) {
::DISKPS         { $_ -in '0', 'Healthy' } { 'Healthy'; break }
::DISKPS         { $_ -in '1', 'Warning' } { 'Warning'; break }
::DISKPS         { $_ -in '2', 'Unhealthy' } { 'Unhealthy'; break }
::DISKPS         default { 'Unknown' }
::DISKPS     }
::DISKPS     $size = if ($storageDisk.Size) { $storageDisk.Size } else { $device.Size }
::DISKPS     $sectorSize = if ($storageDisk.LogicalSectorSize) { $storageDisk.LogicalSectorSize } else { $device.BytesPerSector }
::DISKPS     $serial = if ($storageDisk.SerialNumber) { $storageDisk.SerialNumber } else { $device.SerialNumber }
::DISKPS     $firmwareVersions = $disk.FirmwareVersion, $osDisk.FirmwareVersion, $device.FirmwareRevision
::DISKPS     $firmware = $firmwareVersions | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Select-Object -First 1
::DISKPS 
::DISKPS     Write-DiskHeader -Description ('{0} [{1}]' -f $name, $type)
::DISKPS     Write-DiskFields -Title 'Windows device' -Fields ([ordered]@{
::DISKPS         'Windows disk number' = $diskNumber
::DISKPS         'Windows health status' = $healthStatus
::DISKPS         'Operational status' = ($storageDisk.OperationalStatus -join ', ')
::DISKPS         'CIM device status' = $device.Status
::DISKPS         'Bus' = $bus
::DISKPS         'Serial number' = ([string]$serial).Trim()
::DISKPS         'Firmware' = ([string]$firmware).Trim()
::DISKPS         'Capacity' = $(if ($size) { '{0:N2} GiB ({1} bytes)' -f ($size / 1GB), $size })
::DISKPS         'Logical sector bytes' = $sectorSize
::DISKPS         'Physical sector bytes' = $storageDisk.PhysicalSectorSize
::DISKPS         'Partition style' = $osDisk.PartitionStyle
::DISKPS         'Read only' = $osDisk.IsReadOnly
::DISKPS         'Offline' = $osDisk.IsOffline
::DISKPS         'Spindle speed (RPM)' = $(if ($disk.SpindleSpeed -gt 0 -and $disk.SpindleSpeed -lt [uint32]::MaxValue) { $disk.SpindleSpeed })
::DISKPS     })
::DISKPS 
::DISKPS     $reliability = $null
::DISKPS     try {
::DISKPS         if ($disk) {
::DISKPS             $reliability = Get-StorageReliabilityCounter -PhysicalDisk $disk -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
::DISKPS         }
::DISKPS         if (-not $reliability -and $osDisk) {
::DISKPS             $reliability = Get-StorageReliabilityCounter -Disk $osDisk -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
::DISKPS         }
::DISKPS     } catch {
::DISKPS         # A provider may be unavailable while the underlying protocol is readable.
::DISKPS     }
::DISKPS 
::DISKPS     $windowsFields = [ordered]@{}
::DISKPS     foreach ($property in $reliabilityFields.Keys) {
::DISKPS         $windowsFields[$reliabilityFields[$property]] = $reliability.$property
::DISKPS     }
::DISKPS     if ($type -in 'SSD', 'NVMe SSD' -and $null -ne $reliability.Wear) {
::DISKPS         $windowsFields['Endurance remaining (%)'] = [Math]::Max(0, 100 - [int]$reliability.Wear)
::DISKPS     }
::DISKPS     Write-DiskFields -Title 'Windows reliability counters' -Fields $windowsFields
::DISKPS 
::DISKPS     if ($type -eq 'NVMe SSD') {
::DISKPS         Write-NvmeSmart -Page (Get-NvmePage -DiskNumber $diskNumber)
::DISKPS     } else {
::DISKPS         $dataRow = Get-AtaWmiRow -Device $device -Win32Disks $win32Disks -Rows $ataData
::DISKPS         $thresholdRow = Get-AtaWmiRow -Device $device -Win32Disks $win32Disks -Rows $ataThresholds
::DISKPS         $statusRow = Get-AtaWmiRow -Device $device -Win32Disks $win32Disks -Rows $ataStatus
::DISKPS         Write-AtaSmart -DataRow $dataRow -ThresholdRow $thresholdRow -StatusRow $statusRow -Rotating ($type -eq 'HDD')
::DISKPS     }
::DISKPS }
::DISKPS 
::DISKPS Write-SmartmontoolsDetails -DiskNumbers $smartmontoolsDiskNumbers

REM PowerShell used to initialize the shared console.
::CONSOLEPS if ([Console]::IsOutputRedirected) { return 1 }
::CONSOLEPS 
::CONSOLEPS try {
::CONSOLEPS     Add-Type -TypeDefinition @'
::CONSOLEPS using System;
::CONSOLEPS using System.Runtime.InteropServices;
::CONSOLEPS 
::CONSOLEPS namespace Tweaksys
::CONSOLEPS {
::CONSOLEPS     public static class ConsoleOutput
::CONSOLEPS     {
::CONSOLEPS         [DllImport("kernel32.dll")]
::CONSOLEPS         private static extern IntPtr GetStdHandle(int standardHandle);
::CONSOLEPS 
::CONSOLEPS         [DllImport("kernel32.dll")]
::CONSOLEPS         private static extern bool GetConsoleMode(IntPtr handle, out uint mode);
::CONSOLEPS 
::CONSOLEPS         [DllImport("kernel32.dll")]
::CONSOLEPS         private static extern bool SetConsoleMode(IntPtr handle, uint mode);
::CONSOLEPS 
::CONSOLEPS         public static bool EnableVirtualTerminal()
::CONSOLEPS         {
::CONSOLEPS             const int standardOutput = -11;
::CONSOLEPS             const uint processedOutput = 0x0001;
::CONSOLEPS             const uint virtualTerminalProcessing = 0x0004;
::CONSOLEPS             const uint flags = processedOutput | virtualTerminalProcessing;
::CONSOLEPS 
::CONSOLEPS             IntPtr handle = GetStdHandle(standardOutput);
::CONSOLEPS             uint mode;
::CONSOLEPS             if (!GetConsoleMode(handle, out mode))
::CONSOLEPS                 return false;
::CONSOLEPS             if ((mode & flags) == flags)
::CONSOLEPS                 return true;
::CONSOLEPS             return SetConsoleMode(handle, mode | flags) &&
::CONSOLEPS                 GetConsoleMode(handle, out mode) && (mode & flags) == flags;
::CONSOLEPS         }
::CONSOLEPS     }
::CONSOLEPS }
::CONSOLEPS '@
::CONSOLEPS     $ansi = [Tweaksys.ConsoleOutput]::EnableVirtualTerminal()
::CONSOLEPS } catch {
::CONSOLEPS     $ansi = [bool]$Host.UI.SupportsVirtualTerminal
::CONSOLEPS }
::CONSOLEPS 
::CONSOLEPS if ($env:WT_SESSION -and $ansi) {
::CONSOLEPS     [Console]::Write(('{0}[2J{0}[H{0}[3J' -f [char]27))
::CONSOLEPS } else {
::CONSOLEPS     [Console]::Clear()
::CONSOLEPS     try {
::CONSOLEPS         if ([Console]::BufferHeight -lt 9001) {
::CONSOLEPS             [Console]::SetBufferSize([Console]::BufferWidth, 9001)
::CONSOLEPS         }
::CONSOLEPS     } catch {}
::CONSOLEPS }
::CONSOLEPS return [int](-not $ansi)
