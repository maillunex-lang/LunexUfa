$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent
$Toolchain = Join-Path $Root 'Toolchain\Unity2017.4.30f1'
$Editor = Join-Path $Toolchain 'Editor\Unity.exe'
$Project = Join-Path $PSScriptRoot 'Darklord-Android'
$Log = Join-Path $PSScriptRoot 'Unity-Android-Scenes.log'
$InspectSrc = Join-Path $PSScriptRoot 'InspectBaselineScenes.cs'
$InspectDstDir = Join-Path $Project 'Assets\Editor\LunexUfa'
$InspectDst = Join-Path $InspectDstDir 'InspectBaselineScenes.cs'

if (!(Test-Path -LiteralPath $Editor -PathType Leaf)) {
    throw "Unity editor missing: $Editor"
}
if (Get-Process Unity -ErrorAction SilentlyContinue) {
    throw 'Unity is still running. Wait for the current import/editor session to exit.'
}

New-Item -ItemType Directory -Force -Path $InspectDstDir | Out-Null
Copy-Item -LiteralPath $InspectSrc -Destination $InspectDst -Force

$UnityArguments = @(
    '-batchmode',
    '-nographics',
    '-quit',
    '-buildTarget', 'Android',
    '-projectPath', $Project,
    '-logFile', $Log,
    '-executeMethod', 'LunexUfa.Baseline.InspectBaselineScenes.Run'
)
Write-Output "Starting scene inspect. Log $Log"
$Process = Start-Process -FilePath $Editor -ArgumentList $UnityArguments -Wait -PassThru
Write-Output "Unity exit code $($Process.ExitCode). Log $Log"
exit $Process.ExitCode
