if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadLine
  Set-PSReadlineOption -EditMode Vi

  Set-Alias g git
}