# Define variables
$registryKey = "HKCU:\Software\MyApplication"
$registryValueName = "DisableCMD"
$username = "admin"
$password = "admin"

# Function to set registry value
function Set-RegistryValue {
    param (
        [string]$key,
        [string]$valueName,
        [int]$valueData
    )

    try {
        # Check if the registry key exists, if not, create it
        if (-not (Test-Path -Path $key)) {
            New-Item -Path $key -Force | Out-Null
        }

        Set-ItemProperty -Path $key -Name $valueName -Value $valueData -ErrorAction Stop
        Write-Host "Registry value set successfully."
    } catch {
        Write-Host "Error setting registry value: $_"
    }
}

# Function to close the PowerShell window
function Close-PowerShellWindow {
    $host.SetShouldExit(0)
}

# Function to prompt for credentials
function Prompt-ForCredentials {
    # Prompt user for credentials
    $credential = Get-Credential -Message "Enter your credentials"

    # Check if the user canceled the prompt
    if ($credential -eq $null) {
        Write-Host "Credential prompt canceled. PowerShell remains usable."
        Close-PowerShellWindow
    }

    # Validate user credentials
    elseif ($credential.UserName -eq $username -and $credential.GetNetworkCredential().Password -eq $password) {
        Write-Host "Authentication successful. Access granted."
        return $true
    } else {
        Write-Host "Authentication failed. Access denied."
        return $false
    }
}

# Enable command prompt and PowerShell with user authentication
try {
    # Set registry value to enable command prompt
    Set-RegistryValue -Key $registryKey -ValueName $registryValueName -ValueData 0

    $authenticated = $false
    $attempts = 0

    while (-not $authenticated) {
        $authenticated = Prompt-ForCredentials

        # Increment attempt count if authentication fails
        if (-not $authenticated) {
            $attempts++
            if ($attempts -ge 3) {
                Write-Host "Maximum attempts reached. Exiting script."
                Close-PowerShellWindow
            }
        }
    }

    # Additional operations can be performed here if needed after successful authentication

} catch {
    Write-Host "Error occurred: $_"
}
