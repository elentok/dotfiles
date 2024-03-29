Set-ExecutionPolicy RemoteSigned

if (!(Get-Command choco -errorAction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if (!(Get-Command scoop -errorAction SilentlyContinue)) {
  Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
}

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

choco install -y nodejs googlechrome 7zip git vscode keepass telegram doublecmd libreoffice vlc `
  irfanview irfanviewplugins Everything transgui procexp wsltty pandoc

scoop bucket add extras
scoop install neovim fzf ripgrep git firefox

Write-Output 'Enabling SSH Agent'
Set-Service -name "ssh-agent" -startuptype "automatic"
Get-Service ssh-agent | Start-Service

Write-Output 'Installing yarn'
npm i -g yarn

Write-Output 'Setting up git'
$DOTF = Resolve-Path (Join-Path $PSScriptRoot '..')
$gitconfig = Join-Path $DOTF 'core/git/gitconfig'
git config --global include.path $gitconfig
git config --global core.autocrlf false
git config --global user.name 'David Elentok'
git config --global user.email '3david@gmail.com'
git config --global github.user 'elentok'

. powershell\setup.ps1
. nvim.ps1
