$DOTF = Resolve-Path (Join-Path $PSScriptRoot '..')

$nvimConfigDir = Join-Path $env:LOCALAPPDATA 'nvim'

New-Item -Path $nvimConfigDir -ItemType SymbolicLink -Value $DOTF\nvim
