[CmdletBinding()]
param(
    [string]$UnityProjectPath = 'C:\Users\max\Documents\Projects\IndependentAgentUnitySpike\IndependentAgentUnitySpike',
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
$DocsRepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$filesToSync = @(
    'AGENTS.md',
    'docs\ARCHITECTURE.md',
    'docs\DECISIONS.md',
    'docs\PROGRESS.md',
    'docs\architecture\android_integration_architecture_v0.1.md'
)

if (-not (Test-Path -LiteralPath $UnityProjectPath -PathType Container)) {
    throw "Unity project folder not found: $UnityProjectPath"
}

Write-Host "Documentation source: $DocsRepoRoot"
Write-Host "Unity project target: $UnityProjectPath"
if (-not $Apply) {
    Write-Host 'DRY RUN: no files will be written. Re-run with -Apply to perform the sync.' -ForegroundColor Yellow
}

foreach ($relativePath in $filesToSync) {
    $source = Join-Path $DocsRepoRoot $relativePath
    $destination = Join-Path $UnityProjectPath $relativePath

    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Required source file is missing: $source"
    }

    $destinationDirectory = Split-Path -Parent $destination
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash

    if (Test-Path -LiteralPath $destination -PathType Leaf) {
        $destinationHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
        if ($sourceHash -eq $destinationHash) {
            Write-Host "[UNCHANGED] $relativePath"
            continue
        }

        if (-not $Apply) {
            Write-Host "[WOULD UPDATE] $relativePath"
            continue
        }

        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backup = "$destination.bak-$timestamp"
        Copy-Item -LiteralPath $destination -Destination $backup
        Write-Host "[BACKUP] $backup"
    }
    elseif (-not $Apply) {
        Write-Host "[WOULD CREATE] $relativePath"
        continue
    }

    if ($Apply) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $destination -Force
        Write-Host "[SYNCED] $relativePath"
    }
}

if ($Apply) {
    Write-Host 'Documentation sync completed. No files were deleted.' -ForegroundColor Green
} else {
    Write-Host 'Dry run completed. Review the list above before running with -Apply.'
}
