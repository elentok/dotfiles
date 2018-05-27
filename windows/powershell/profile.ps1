if (($host.Name -eq 'ConsoleHost') -Or ($host.Name -eq 'Visual Studio Code Host')) {
  Import-Module PSReadLine
  Set-PSReadlineOption -EditMode Vi

  Set-Alias g git
}