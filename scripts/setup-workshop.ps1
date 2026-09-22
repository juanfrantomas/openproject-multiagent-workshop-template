$ErrorActionPreference = "Stop"

$OpenProjectUrl = "https://ianegociosocios.openproject.com"

function Write-Step {
    param([string]$Text)
    Write-Host ""
    Write-Host "============================================================"
    Write-Host $Text
    Write-Host "============================================================"
}

function Command-Exists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}

Write-Host ""
Write-Host "OPENPROJECT + CODEX MULTIAGENT WORKSHOP"
Write-Host "Configuracion automatica del participante"
Write-Host ""

# ------------------------------------------------------------
# WINGET
# ------------------------------------------------------------

Write-Step "1. Comprobando winget"

if (-not (Command-Exists "winget")) {
    Write-Host "ERROR: winget no esta disponible."
    Write-Host "Actualiza App Installer desde Microsoft Store y vuelve a ejecutar."
    exit 1
}

Write-Host "OK: winget disponible"

# ------------------------------------------------------------
# GIT
# ------------------------------------------------------------

Write-Step "2. Comprobando Git"

if (-not (Command-Exists "git")) {
    Write-Host "Instalando Git..."
    winget install --id Git.Git -e --source winget `
        --accept-source-agreements `
        --accept-package-agreements

    Refresh-Path
}

if (-not (Command-Exists "git")) {
    Write-Host "Git ha sido instalado pero Windows aun no lo encuentra."
    Write-Host "Cierra PowerShell, abrelo de nuevo y vuelve a ejecutar este script."
    exit 0
}

git --version

# ------------------------------------------------------------
# GITHUB CLI
# ------------------------------------------------------------

Write-Step "3. Comprobando GitHub CLI"

if (-not (Command-Exists "gh")) {
    Write-Host "Instalando GitHub CLI..."
    winget install --id GitHub.cli -e --source winget `
        --accept-source-agreements `
        --accept-package-agreements

    Refresh-Path
}

if (Command-Exists "gh") {
    gh --version | Select-Object -First 1
} else {
    Write-Host "AVISO: reinicia PowerShell para activar GitHub CLI."
}

# ------------------------------------------------------------
# CODEX
# ------------------------------------------------------------

Write-Step "4. Comprobando Codex"

if (-not (Command-Exists "codex")) {
    Write-Host "Instalando Codex CLI oficial..."

    $env:CODEX_NON_INTERACTIVE = "1"
    irm https://chatgpt.com/codex/install.ps1 | iex

    Refresh-Path
}

if (Command-Exists "codex") {
    codex --version
} else {
    Write-Host ""
    Write-Host "Codex ha sido instalado pero aun no aparece en PATH."
    Write-Host "Cierra PowerShell, vuelve a abrirlo y ejecuta otra vez este script."
    exit 0
}

# ------------------------------------------------------------
# UV
# ------------------------------------------------------------

Write-Step "5. Comprobando uv"

if (-not (Command-Exists "uv")) {
    Write-Host "Instalando uv..."

    winget install --id astral-sh.uv -e --source winget `
        --accept-source-agreements `
        --accept-package-agreements

    Refresh-Path
}

if (-not (Command-Exists "uv")) {
    Write-Host "uv ha sido instalado pero aun no aparece en PATH."
    Write-Host "Cierra PowerShell, abrelo de nuevo y vuelve a ejecutar este script."
    exit 0
}

uv --version

# ------------------------------------------------------------
# OPENPROJECT CE MCP
# ------------------------------------------------------------

Write-Step "6. Comprobando OpenProject CE MCP"

if (-not (Command-Exists "openproject-ce-mcp")) {
    Write-Host "Instalando openproject-ce-mcp 0.3.8..."

    uv tool install "openproject-ce-mcp==0.3.8"

    Refresh-Path
}

if (-not (Command-Exists "openproject-ce-mcp")) {
    Write-Host ""
    Write-Host "Intentando añadir el directorio de herramientas uv al PATH..."
    uv tool update-shell

    Write-Host ""
    Write-Host "Cierra PowerShell, vuelve a abrirlo y ejecuta otra vez:"
    Write-Host ""
    Write-Host "    .\scripts\setup-workshop.ps1"
    exit 0
}

openproject-ce-mcp --version

# ------------------------------------------------------------
# TOKEN OPENPROJECT
# ------------------------------------------------------------

Write-Step "7. Configurando tu token personal de OpenProject"

Write-Host "Instancia:"
Write-Host "  $OpenProjectUrl"
Write-Host ""
Write-Host "Tu token NO se guardara dentro del repositorio."
Write-Host ""

$secureToken = Read-Host "Pega tu API token personal de OpenProject" -AsSecureString

$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)

try {
    $token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
}
finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
}

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "ERROR: token vacio."
    exit 1
}

# Variable persistente del usuario Windows.
[Environment]::SetEnvironmentVariable(
    "OPENPROJECT_API_TOKEN",
    $token,
    "User"
)

# Tambien disponible inmediatamente en esta sesion.
$env:OPENPROJECT_API_TOKEN = $token

# ------------------------------------------------------------
# VALIDAR TOKEN
# ------------------------------------------------------------

Write-Step "8. Probando conexion con OpenProject"

$pair = "apikey:$token"
$bytes = [Text.Encoding]::ASCII.GetBytes($pair)
$basic = [Convert]::ToBase64String($bytes)

try {

    $me = Invoke-RestMethod `
        -Uri "$OpenProjectUrl/api/v3/users/me" `
        -Headers @{
            Authorization = "Basic $basic"
            Accept = "application/hal+json"
        } `
        -Method GET

    Write-Host ""
    Write-Host "Conexion correcta."
    Write-Host ""
    Write-Host "Usuario OpenProject:"
    Write-Host "  ID:    $($me.id)"
    Write-Host "  Login: $($me.login)"
    Write-Host "  Nombre:$($me.name)"

}
catch {

    Write-Host ""
    Write-Host "ERROR: no se pudo autenticar contra OpenProject."
    Write-Host "Comprueba el token y vuelve a ejecutar el script."

    [Environment]::SetEnvironmentVariable(
        "OPENPROJECT_API_TOKEN",
        $null,
        "User"
    )

    exit 1
}

# ------------------------------------------------------------
# GITHUB
# ------------------------------------------------------------

Write-Step "9. Comprobando autenticacion GitHub"

if (Command-Exists "gh") {

    gh auth status 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "Todavia no has iniciado sesion en GitHub."
        Write-Host ""
        Write-Host "Ejecuta despues:"
        Write-Host ""
        Write-Host "    gh auth login"
    }

}

# ------------------------------------------------------------
# CODEX LOGIN
# ------------------------------------------------------------

Write-Step "10. Comprobando Codex"

Write-Host "Codex esta instalado."
Write-Host ""
Write-Host "Si aun no has iniciado sesion con ChatGPT, ejecuta:"
Write-Host ""
Write-Host "    codex"
Write-Host ""
Write-Host "y selecciona 'Sign in with ChatGPT'."

# ------------------------------------------------------------
# FINAL
# ------------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host " CONFIGURACION DEL WORKSHOP COMPLETADA"
Write-Host "============================================================"
Write-Host ""
Write-Host "IMPORTANTE:"
Write-Host ""
Write-Host "Si Orca estaba abierto, cierralo y vuelve a abrirlo."
Write-Host "Windows necesita iniciar nuevos procesos para que vean el token."
Write-Host ""
Write-Host "Ahora ejecuta:"
Write-Host ""
Write-Host "    .\scripts\doctor-workshop.ps1"
Write-Host ""
