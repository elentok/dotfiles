if (!(Get-Command choco -errorAction SilentlyContinue)) {
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

choco install -y nodejs googlechrome 7zip git vscode keepass telegram doublecmd libreoffice vlc `
  irfanview irfanviewplugins Everything

git config --global user.name 'David Elentok'
git config --global user.email '3david@gmail.com'
git config --global github.user 'elentok'