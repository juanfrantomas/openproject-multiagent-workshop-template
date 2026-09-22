$ErrorActionPreference = "Stop"

$token = [Environment]::GetEnvironmentVariable(
    "OPENPROJECT_API_TOKEN",
    "User"
)

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "ERROR: no existe OPENPROJECT_API_TOKEN."
    Write-Host "Ejecuta primero:"
    Write-Host ""
    Write-Host "    .\scripts\setup-workshop.ps1"
    exit 1
}

$env:OPENPROJECT_API_TOKEN = $token

$RepoDir = Split-Path -Parent $PSScriptRoot
Set-Location $RepoDir

codex
