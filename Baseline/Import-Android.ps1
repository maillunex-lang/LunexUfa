$ErrorActionPreference = 'Stop'
$Toolchain = Join-Path (Split-Path $PSScriptRoot -Parent) 'Toolchain\Unity2017.4.30f1'
$Editor = Join-Path $Toolchain 'Editor\Unity.exe'
$AndroidPlayer = Join-Path $Toolchain 'Editor\Data\PlaybackEngines\AndroidPlayer'
$Project = Join-Path $PSScriptRoot 'Darklord-Android'
$Log = Join-Path $PSScriptRoot 'Unity-Android-Import.log'

if (!(Test-Path -LiteralPath $Editor -PathType Leaf) -or !(Test-Path -LiteralPath $AndroidPlayer -PathType Container)) {
    throw 'Unity 2017.4.30f1 and Android Build Support are required.'
}
$ProjectVersion = Get-Content -LiteralPath (Join-Path $Project 'ProjectSettings\ProjectVersion.txt')
if ($ProjectVersion -notcontains 'm_EditorVersion: 2017.4.30f1') {
    throw 'Unexpected baseline project version.'
}

$UnityArguments = "-batchmode -nographics -quit -buildTarget Android -projectPath `"$Project`" -logFile `"$Log`""
$Process = Start-Process -FilePath $Editor -ArgumentList $UnityArguments -Wait -PassThru
Write-Output "Unity exit code $($Process.ExitCode). Log $Log"
exit $Process.ExitCode
