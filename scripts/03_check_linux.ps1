# Run from the repo folder after both Linux VMs are started.
$checks = @(
  @{vm='ubuntu'; service='nginx'},
  @{vm='debian'; service='apache2'}
)
foreach ($item in $checks) {
  $vm = $item.vm; $svc = $item.service
  Write-Host "===== $vm ====="
  & vagrant ssh $vm -c "hostname; cat /etc/os-release | head -6; ip -br -4 addr; systemctl is-active $svc; systemctl is-active wazuh-agent 2>/dev/null || true"
}
Write-Host 'Host checks. Failed ICMP may indicate a firewall issue or misconfigured host-only NIC:'
foreach ($ip in @('192.168.56.11','192.168.56.12')) {
  Test-NetConnection -ComputerName $ip -Port 80 -InformationLevel Detailed | Select-Object ComputerName,RemotePort,TcpTestSucceeded
}
