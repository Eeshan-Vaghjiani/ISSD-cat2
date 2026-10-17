# Run from PowerShell as your regular Windows user.
# VirtualBox/Vagrant should be installed before running this script.
$letter = (Read-Host 'Enter drive letter for your SATA SSD (e.g. E)').Trim().TrimEnd(':')
if ($letter -notmatch '^[A-Za-z]$') { throw 'Enter a single letter, e.g. E' }
$drive = "$($letter.ToUpper()):"
if (-not (Test-Path "$drive\")) { throw "Drive $drive is not accessible" }
$base = Join-Path "$drive\" 'ISSD_CAT2'
$paths = @('VMs','VagrantHome','Downloads','Evidence','SharedExports','LabRepo')
foreach ($p in $paths) { New-Item -ItemType Directory -Path (Join-Path $base $p) -Force | Out-Null }
$env:VAGRANT_HOME = Join-Path $base 'VagrantHome'
[Environment]::SetEnvironmentVariable('VAGRANT_HOME',$env:VAGRANT_HOME,'User')
$env:VAGRANT_DEFAULT_PROVIDER = 'virtualbox'
[Environment]::SetEnvironmentVariable('VAGRANT_DEFAULT_PROVIDER','virtualbox','User')
$vb = Join-Path ${env:ProgramFiles} 'Oracle\VirtualBox\VBoxManage.exe'
if (Test-Path $vb) {
  & $vb setproperty machinefolder (Join-Path $base 'VMs')
  if ($LASTEXITCODE -ne 0) { Write-Warning 'Could not set VirtualBox VM folder; configure it in VirtualBox Preferences/General.' }
} else {
  Write-Warning 'VirtualBox not found at standard path. Set Default Machine Folder in VirtualBox Preferences manually.'
}
Write-Host "Created lab directories under $base"
Write-Host "VAGRANT_HOME: $env:VAGRANT_HOME"
Write-Host 'Restart PowerShell after setup so persistent environment settings take effect.'
Write-Host 'Move/extract this entire repository into the LabRepo directory before running vagrant.'
