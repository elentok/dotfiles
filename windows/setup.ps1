Set-ExecutionPolicy RemoteSigned

if (!(Get-Command choco -errorAction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

choco install -y nodejs googlechrome 7zip git vscode keepass telegram doublecmd libreoffice vlc `
  irfanview irfanviewplugins Everything

Write-Output 'Installing yarn'
npm i -g yarn

Write-Output 'Setting up git'
$DOTF = Resolve-Path (Join-Path $PSScriptRoot '..')
$gitconfig = Join-Path $DOTF 'plugins/git/gitconfig'
git config --global include.path $gitconfig
git config --global core.autocrlf false
git config --global user.name 'David Elentok'
git config --global user.email '3david@gmail.com'
git config --global github.user 'elentok'

. powershell\setup.ps1