# Run as PowerShell on your Windows 11 evaluation VM.
Write-Host '===== Windows endpoint ====='
hostname
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike '169.254*'} |
  Select-Object InterfaceAlias,IPAddress,PrefixLength | Format-Table
Get-Service -Name WazuhSvc -ErrorAction SilentlyContinue | Select-Object Name,Status,DisplayName
Write-Host 'Connectivity from Windows to Linux endpoints:'
Test-NetConnection 192.168.56.11 -Port 80 | Select-Object ComputerName,TcpTestSucceeded
Test-NetConnection 192.168.56.12 -Port 80 | Select-Object ComputerName,TcpTestSucceeded
Write-Host 'No agent service output means no Wazuh agent was found. Only install after group platform approval.'
