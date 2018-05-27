$DOTF = Resolve-Path (Join-Path $PSScriptRoot '../..')
$script = Join-Path $PSScriptRoot 'profile.ps1'

if (!(Get-Module -ListAvailable -Name PSReadline)) {
  Write-Output 'Installing readline for powershell'
  Install-Module PSReadLine
}

Write-Output 'Installing powershell profile.ps1'
$script = Join-Path $PSScriptRoot 'profile.ps1'
$output = Join-Path ([System.Environment]::GetFolderPath('MyDocuments')) 'WindowsPowerShell/profile.ps1'
Write-Output ". $script" | Out-File -FilePath $output