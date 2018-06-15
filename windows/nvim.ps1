$DOTF = Resolve-Path (Join-Path $PSScriptRoot '..')
$mainInitVim = Join-Path $DOTF 'nvim/init.vim'

$nvimConfigDir = Join-Path $env:LOCALAPPDATA 'nvim'
if (!(Test-Path -Path $nvimConfigDir)) {
  mkdir $nvimConfigDir
}

$localInitVim = Join-Path $nvimConfigDir 'init.vim'

Write-Output "source $mainInitVim" | Out-File -FilePath $localInitVim