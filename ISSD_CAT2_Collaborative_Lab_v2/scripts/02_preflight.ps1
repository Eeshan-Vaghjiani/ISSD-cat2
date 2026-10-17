Write-Host '=== ISSD CAT2 Preflight ==='
Write-Host 'Computer architecture:' $env:PROCESSOR_ARCHITECTURE
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 Name,VirtualizationFirmwareEnabled
$cpu | Format-List
Write-Host 'RAM (GB):' ([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB,1))
Write-Host 'VAGRANT_HOME:' $env:VAGRANT_HOME
Get-PSDrive -PSProvider FileSystem | Select-Object Name,Root,@{N='FreeGB';E={[math]::Round($_.Free/1GB,1)}} | Format-Table
if (Get-Command vagrant -ErrorAction SilentlyContinue) { & vagrant --version } else { Write-Warning 'Vagrant missing or not in PATH' }
$vb = Join-Path ${env:ProgramFiles} 'Oracle\VirtualBox\VBoxManage.exe'
if (Test-Path $vb) { & $vb --version } else { Write-Warning 'VirtualBox not found at standard path' }
Write-Host 'If virtualization is False, enable Intel VT-x/AMD-V in BIOS/UEFI. Confirm VirtualBox can boot a VM.'
