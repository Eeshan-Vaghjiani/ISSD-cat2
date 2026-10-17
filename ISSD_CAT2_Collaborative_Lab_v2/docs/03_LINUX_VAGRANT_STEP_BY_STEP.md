# 03. Build Ubuntu and Debian with Vagrant (no ISO needed)

### Step 1: Open PowerShell in the project folder
Should contain: `Vagrantfile`, `scripts/`, `docs/`. Open File Explorer at folder, click address bar, type `powershell`, press Enter.

### Step 2: Verify tools and configuration
```powershell
vagrant --version
& "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" --version
vagrant validate
```
Expect `Vagrantfile validated successfully` or similar. If errors, stop and fix before running VM install.

### Step 3: Start one VM at a time
```powershell
vagrant up ubuntu --provider=virtualbox
vagrant ssh ubuntu -c "hostname; cat /etc/os-release; ip -br -4 addr"
```
The first call downloads `bento/ubuntu-24.04` and creates a VirtualBox VM named `ISSD-CAT2-ubuntu`. Ubuntu should report private IP `192.168.56.11` on the host-only NIC. It should also have an adapter with a NAT private address used for downloads.

Then:
```powershell
vagrant up debian --provider=virtualbox
vagrant ssh debian -c "hostname; cat /etc/os-release; ip -br -4 addr"
vagrant status
```
Debian should report `192.168.56.12`.

### Step 4: Confirm reachable test services (not a vulnerability assessment yet)
Run in the **Windows laptop host** PowerShell:
```powershell
Test-NetConnection 192.168.56.11 -Port 80
Test-NetConnection 192.168.56.12 -Port 80
```
Both should show `TcpTestSucceeded : True` because the project provisions Nginx/Apache. If false, see troubleshooting guide and do NOT fake screenshot.

### Step 5: Capture evidence
- VirtualBox Manager showing both powered-on machines.
- PowerShell `vagrant status`.
- Ubuntu console showing hostname, `/etc/os-release`, `ip -br -4 addr`.
- Debian equivalent.
- Both `Test-NetConnection` successful checks.
- Save to `X:\ISSD_CAT2\Evidence\Member4\` AND group shared evidence folder, with meaningful names.

### Step 6: Save CLEAN snapshots before endpoint agents
```powershell
vagrant snapshot save ubuntu baseline-before-agent
vagrant snapshot save debian baseline-before-agent
```
This baseline can be used by Member 1. Do not clone an agent-registered image into different machines, because identity duplication may occur.

### Useful management commands
```powershell
vagrant status
vagrant ssh ubuntu
vagrant ssh debian
vagrant halt
vagrant up ubuntu
```
`vagrant destroy` removes the local guests; do not use unless you intentionally want to rebuild and have saved evidence.

### Common download issue
If Vagrant picks the wrong CPU architecture or provider, try:
```powershell
vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64
vagrant box add bento/debian-12 --provider=virtualbox --architecture=amd64
```
These require available matching community boxes. HCP box hosting is being shut down at the end of 2026; save locally obtained, appropriately licensed box files for later rebuilding.

### Direct ISO, if you prefer manual Debian installation
Official stable archive Debian 12.15 AMD64 netinst:
https://cloudfront.debian.net/cdimage/archive/latest-oldstable/amd64/iso-cd/debian-12.15.0-amd64-netinst.iso
Optional manual ISO use: create a VM, mount ISO and follow Debian installer. With Vagrant, this download is NOT necessary.
