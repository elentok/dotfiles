if (($host.Name -eq 'ConsoleHost') -Or ($host.Name -eq 'Visual Studio Code Host')) {
  Write-Output 'Loading dotfiles profile.ps1'

  Import-Module PSReadLine
  # Set-PSReadlineOption -EditMode Vi
  # Set-PSReadlineKeyHandler -Chord Ctrl+R -Function ReverseSearchHistory
  # Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  # Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  # Set-PSReadLineKeyHandler -Key Tab -Function Complete
  #
  function QuitReplacement{
    Invoke-command -ScriptBlock {exit}
  }

  function TigStatus{
    Invoke-command -ScriptBlock {tig status}
  }

  Set-Alias x QuitReplacement
  Set-Alias g git
  Set-Alias ts TigStatus
  Set-Alias chi 'choco install -y'
  Set-Alias chs 'choco search'
  Set-Alias grep Select-String
  Set-Alias head 'select -first 10'
  Set-Alias tail 'select -last 10'
}
