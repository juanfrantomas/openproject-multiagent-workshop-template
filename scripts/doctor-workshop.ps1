$ErrorActionPreference = "Continue"

$OpenProjectUrl = "https://ianegociosocios.openproject.com"

$Ok = 0
$Warn = 0
$Fail = 0

function Result {
    param(
        [string]$Name,
        [string]$Status,
        [string]$Detail = ""
    )

    $dots = "." * [Math]::Max(2, 28 - $Name.Length)

    switch ($Status) {

        "OK" {
            Write-Host "$Name $dots OK"
            $script:Ok++
        }

        "AVISO" {
            Write-Host "$Name $dots AVISO"
            $script:Warn++
        }

        "ERROR" {
            Write-Host "$Name $dots ERROR"
            $script:Fail++
        }
    }

    if ($Detail) {
        Write-Host "   $Detail"
    }
}

function Exists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

Clear-Host

Write-Host ""
Write-Host "============================================================"
Write-Host " DIAGNOSTICO OPENPROJECT + CODEX WORKSHOP"
Write-Host "============================================================"
Write-Host ""

# Repo

if (Test-Path ".codex\config.toml") {
    Result "Repositorio workshop" "OK"
} else {
    Result "Repositorio workshop" "ERROR" `
        "Ejecuta el doctor desde la raiz del repositorio."
}

# Git

if (Exists "git") {
    Result "Git" "OK" ((git --version) -join " ")
} else {
    Result "Git" "ERROR"
}

# GitHub CLI

if (Exists "gh") {

    Result "GitHub CLI" "OK" ((gh --version | Select-Object -First 1) -join " ")

    gh auth status *> $null

    if ($LASTEXITCODE -eq 0) {
        Result "GitHub autenticado" "OK"
    } else {
        Result "GitHub autenticado" "AVISO" "Ejecuta: gh auth login"
    }

} else {

    Result "GitHub CLI" "ERROR"

}

# Codex

if (Exists "codex") {

    Result "Codex" "OK" ((codex --version) -join " ")

    try {

        $doctorRaw = codex doctor --json 2>$null

        if ($LASTEXITCODE -eq 0) {

            $doctor = $doctorRaw | ConvertFrom-Json

            if ($doctor.overallStatus -eq "ok") {
                Result "Codex Doctor" "OK"
            } else {
                Result "Codex Doctor" "AVISO" "overallStatus=$($doctor.overallStatus)"
            }

            if (
                $doctor.checks."auth.credentials".status -eq "ok"
            ) {
                Result "Codex autenticado" "OK"
            } else {
                Result "Codex autenticado" "AVISO" `
                    "Ejecuta codex e inicia sesion con ChatGPT."
            }

            if (
                $doctor.checks."mcp.config".status -eq "ok"
            ) {
                Result "Configuracion MCP" "OK"
            } else {
                Result "Configuracion MCP" "ERROR"
            }

        } else {

            Result "Codex Doctor" "AVISO" `
                "No se pudo ejecutar codex doctor --json."

        }

    }
    catch {

        Result "Codex Doctor" "AVISO" $_.Exception.Message

    }

} else {

    Result "Codex" "ERROR"

}

# uv

if (Exists "uv") {
    Result "uv" "OK" ((uv --version) -join " ")
} else {
    Result "uv" "ERROR"
}

# MCP

if (Exists "openproject-ce-mcp") {

    Result "OpenProject MCP" "OK" `
        ((openproject-ce-mcp --version) -join " ")

} else {

    Result "OpenProject MCP" "ERROR"

}

# Token

$token = [Environment]::GetEnvironmentVariable(
    "OPENPROJECT_API_TOKEN",
    "User"
)

if ([string]::IsNullOrWhiteSpace($token)) {

    Result "Token OpenProject" "ERROR" `
        "Ejecuta .\scripts\setup-workshop.ps1"

} else {

    Result "Token OpenProject" "OK"

    # API
    try {

        $pair = "apikey:$token"
        $bytes = [Text.Encoding]::ASCII.GetBytes($pair)
        $basic = [Convert]::ToBase64String($bytes)

        $me = Invoke-RestMethod `
            -Uri "$OpenProjectUrl/api/v3/users/me" `
            -Headers @{
                Authorization = "Basic $basic"
                Accept = "application/hal+json"
            } `
            -Method GET `
            -TimeoutSec 15

        Result "OpenProject API" "OK" `
            "$($me.name) [$($me.login)]"

    }
    catch {

        Result "OpenProject API" "ERROR" `
            "No se puede autenticar contra $OpenProjectUrl"

    }

}

# Agentes

if (Test-Path ".codex\agents\planner.toml") {
    Result "Agente planner" "OK"
} else {
    Result "Agente planner" "ERROR"
}

if (Test-Path ".codex\agents\reviewer.toml") {
    Result "Agente reviewer" "OK"
} else {
    Result "Agente reviewer" "ERROR"
}

# AGENTS.md

if (Test-Path "AGENTS.md") {
    Result "Instrucciones AGENTS.md" "OK"
} else {
    Result "Instrucciones AGENTS.md" "ERROR"
}

Write-Host ""
Write-Host "------------------------------------------------------------"
Write-Host "OK:     $Ok"
Write-Host "Avisos: $Warn"
Write-Host "Errores:$Fail"
Write-Host "------------------------------------------------------------"
Write-Host ""

if ($Fail -eq 0) {

    Write-Host "LISTO PARA EL WORKSHOP"
    Write-Host ""
    Write-Host "Puedes abrir este repositorio en Orca"
    Write-Host "y lanzar Codex."

} else {

    Write-Host "ENTORNO TODAVIA NO PREPARADO"
    Write-Host ""
    Write-Host "Corrige los errores indicados y vuelve a ejecutar:"
    Write-Host ""
    Write-Host "    .\scripts\doctor-workshop.ps1"

}

Write-Host ""
