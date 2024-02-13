@echo off
setlocal

:: Define the path to the PowerShell script
set "ps_script_path=C:\Users\Abishek\Desktop\powershell project\popup.ps1"

:: Ensure the directory structure exists for PowerShell profile script
mkdir "%USERPROFILE%\Documents\WindowsPowerShell" 2>nul

:: Set the PowerShell profile script path
set "profile_script=%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

:: Add the command to run the PowerShell script to the profile script
echo . '%ps_script_path%' >> "%profile_script%"

:: Notify user about the setup
echo PowerShell startup script has been configured.
echo Your PowerShell profile script is located at: %profile_script%

:: Pause to allow the user to see the message
pause
