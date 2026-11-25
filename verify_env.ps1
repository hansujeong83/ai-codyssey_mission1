$ErrorActionPreference = "Continue"
Write-Host "=== Codyssey Mission 1 environment check ==="
Write-Host "[OS]"
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsArchitecture
Write-Host "[Python]"; python --version
Write-Host "[Git]"; git --version
Write-Host "[WSL]"; wsl --list --verbose
Write-Host "[Docker CLI]"; docker --version
Write-Host "[Docker daemon]"
docker info
