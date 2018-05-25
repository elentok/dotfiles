$date = (Get-Date).toString('yyyy-MM-dd')
$target = "D:\Backup\$date"

$documents = [System.Environment]::GetFolderPath('MyDocuments')

mkdir $target -Force

# Compress-Archive -Path $documents `
#   -CompressionLevel Fastest `
#   -DestinationPath $target\Documents.zip

Remove-Item $target\Local.7z
7z a `
  -xr!Packages `
  -xr!INetCache `
  -xr!History `
  -xr!CameraRaw `
  -xr!Caches `
  -xr!D3DSCache `
  -xr!Firefox `
  -xr!Yarn `
  '-xr!Google Chrome' `
  '-xr!Temporary Internet Files' `
  $target\Local.7z `
  $HOME\AppData\Local

Remove-Item $target\LocalLow.7z
7z a $target\LocalLow.7z $HOME\AppData\LocalLow

Remove-Item $target\Roaming.7z
7z a $target\Roaming.7z $HOME\AppData\Roaming

Remove-Item $target\Documents.7z
7z a -r $target\Documents1.7z $documents