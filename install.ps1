# Claude Code 通知音インストーラ (Windows)
# 使い方: powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = 'Stop'

$claudeDir = Join-Path $env:USERPROFILE '.claude'
$soundDir = Join-Path $claudeDir 'sounds'
$settingsPath = Join-Path $claudeDir 'settings.json'

New-Item -ItemType Directory -Force $soundDir | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'sounds\*.wav') $soundDir -Force

function New-SoundHook($wav) {
    $path = (Join-Path $soundDir $wav) -replace '\\', '/'
    @{
        hooks = @(@{
            type    = 'command'
            async   = $true
            timeout = 10
            command = "powershell.exe -NoProfile -Command `"(New-Object Media.SoundPlayer '$path').PlaySync()`""
        })
    }
}

if (Test-Path $settingsPath) {
    Copy-Item $settingsPath "$settingsPath.bak" -Force
    $settings = Get-Content $settingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
} else {
    $settings = New-Object PSObject
}
if (-not $settings.PSObject.Properties['hooks']) {
    $settings | Add-Member -NotePropertyName hooks -NotePropertyValue (New-Object PSObject)
}

foreach ($pair in @(@('Stop', 'done.wav'), @('Notification', 'attention.wav'))) {
    $event, $wav = $pair
    # 以前このスクリプトで入れたフック (.claude/sounds を鳴らすもの) だけ取り除き、他のフックは残す
    $kept = @()
    if ($settings.hooks.PSObject.Properties[$event]) {
        $kept = @($settings.hooks.$event | Where-Object {
            -not ($_.hooks | Where-Object { $_.command -like '*.claude/sounds/*' })
        })
    }
    $settings.hooks | Add-Member -NotePropertyName $event -NotePropertyValue (@($kept) + (New-SoundHook $wav)) -Force
}

$json = $settings | ConvertTo-Json -Depth 32
[System.IO.File]::WriteAllText($settingsPath, $json, (New-Object System.Text.UTF8Encoding $false))

Write-Host "インストールしました: $settingsPath"
(New-Object Media.SoundPlayer (Join-Path $soundDir 'done.wav')).PlaySync()
