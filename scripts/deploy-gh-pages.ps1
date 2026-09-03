Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$buildDir = Join-Path $repoRoot "build\web"
$webDir = Join-Path $repoRoot "web"
$cnameSource = Join-Path $webDir "CNAME"
$cnameValue = "pomodoro.estribado.com.br"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$tempDeployDir = Join-Path ([System.IO.Path]::GetTempPath()) ("pomodoro-gh-pages-" + [System.Guid]::NewGuid().ToString("N"))

function Require-Command {
  param([string]$Name)

  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Command not found: $Name"
  }
}

Require-Command git
Require-Command fvm

Push-Location $repoRoot

try {
  $remoteUrl = git remote get-url origin
  if (-not $remoteUrl) {
    throw "Git remote 'origin' is not configured."
  }

  Write-Host "Running tests..."
  & fvm flutter test

  Write-Host "Building web app..."
  & fvm flutter build web --release --base-href /

  if (-not (Test-Path $buildDir)) {
    throw "Build output not found at '$buildDir'."
  }

  if (-not (Test-Path $cnameSource)) {
    Set-Content -LiteralPath $cnameSource -Value $cnameValue -NoNewline
  }

  Copy-Item -LiteralPath $cnameSource -Destination (Join-Path $buildDir "CNAME") -Force
  Set-Content -LiteralPath (Join-Path $buildDir ".nojekyll") -Value "" -NoNewline

  New-Item -ItemType Directory -Path $tempDeployDir | Out-Null
  Get-ChildItem -LiteralPath $buildDir -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $tempDeployDir -Recurse -Force
  }

  Push-Location $tempDeployDir
  try {
    git init --initial-branch=gh-pages | Out-Null
    git add --all
    git commit -m "Deploy manual $timestamp" | Out-Null
    git remote add origin $remoteUrl
    git push --force origin gh-pages
  }
  finally {
    Pop-Location
  }

  Write-Host "Deploy complete: https://$cnameValue/"
}
finally {
  Pop-Location

  if (Test-Path $tempDeployDir) {
    Remove-Item -LiteralPath $tempDeployDir -Recurse -Force
  }
}
