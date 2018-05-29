if (($host.Name -eq 'ConsoleHost') -Or ($host.Name -eq 'Visual Studio Code Host')) {
  Write-Output 'Loading dotfiles profile.ps1'

  Import-Module PSReadLine
  Set-PSReadlineOption -EditMode Vi
  Set-PSReadlineKeyHandler -Chord Ctrl+R -Function ReverseSearchHistory

  Set-Alias g git
  Set-Alias chi 'choco install -y'
  Set-Alias chs 'choco search'
  Set-Alias grep Select-String
}