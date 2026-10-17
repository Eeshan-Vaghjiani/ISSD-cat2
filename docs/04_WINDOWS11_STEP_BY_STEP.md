# 04. Build Windows 11 Enterprise Evaluation in VirtualBox

Windows is optional in the original brief's wording (`may use`) but deliberately included for a mixed-OS demo. Unlike Linux, Windows evaluation is installed from Microsoft's original licensed ISO and not redistributed through the GitHub repository.

### Step 1: Download Windows Evaluation ISO from Microsoft
Open https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
Select **English (United States), 64-bit ISO**, complete Microsoft's registration if required and save the file to `X:\ISSD_CAT2\Downloads\` (X is your SATA SSD). Trial normally 90 days; confirm it spans your assessment date. A direct ISO download URL may expire or require registration, which is why we link Microsoft's actual download selector.

### Step 2: Create VM
Open VirtualBox. Click **New**.
- Name: `ISSD-CAT2-windows`.
- Folder: `X:\ISSD_CAT2\VMs`.
- Type: Microsoft Windows; Version: Windows 11 (64-bit).
- Select the ISO you downloaded.
- To follow a predictable guided install, choose the option to skip unattended installation if presented.
- Memory: **4096 MB**; CPUs: **2** (reduce to 1 if host is struggling).
- Virtual hard disk: **64 GB**, dynamically allocated (VDI) on SATA SSD.
- Before installing: Settings > System > Motherboard, ensure UEFI/EFI and TPM 2.0 are configured where available; configure Secure Boot if installation requires it. In VirtualBox 7.x, options may be under System > Motherboard or Security depending on build.
- Settings > Network > Adapter 1: **NAT**. This enables legitimate internet activation/downloads as required during install. Do not attach Windows to bridged network for scanning.

Start VM, use Microsoft's guided installer, and finish Windows setup/updates. Do NOT skip product requirements by bypassing checks. The 90-day evaluation may require a Microsoft account per Microsoft's current instructions.

### Step 3: Add a host-only adapter AFTER Linux VMs have been created
Shut down Windows guest fully. VirtualBox > Windows VM > Settings > Network > Adapter 2:
- Enable Network Adapter.
- Attached to: **Host-only Adapter** (naming may appear as `Host-only Network` in your VirtualBox version).
- Name: Select the VirtualBox host-only network already used by Ubuntu/Debian on **192.168.56.0/24**.
- Ensure `Cable connected` checked.
Boot Windows.

### Step 4: Assign a static Windows lab IP on ONLY the host-only NIC
Inside Windows VM press `Win+R`, enter `ncpa.cpl`. Identify the newly added Ethernet interface. Usually it is `Ethernet 2`, but verify adapter details.
Right-click that *host-only* adapter > Properties > Internet Protocol Version 4 (TCP/IPv4) > Properties:
- IP address: `192.168.56.13`
- Subnet mask: `255.255.255.0`
- Default gateway: **blank**
- DNS: **blank**
Do not overwrite the NAT adapter's DHCP settings. This isolates local test traffic and retains NAT for downloads.

### Step 5: Verify
In Windows guest PowerShell:
```powershell
hostname
Get-CimInstance Win32_OperatingSystem | Select Caption,Version
Get-NetIPAddress -AddressFamily IPv4 | Select InterfaceAlias,IPAddress,PrefixLength
Test-NetConnection 192.168.56.11 -Port 80
Test-NetConnection 192.168.56.12 -Port 80
```
The two TCP tests should be true. The Windows guest should show 192.168.56.13.

Optional Windows inbound ICMP reply for your own lab only: elevated PowerShell:
```powershell
New-NetFirewallRule -DisplayName 'ISSD lab only IPv4 ping' -Direction Inbound -Action Allow -Protocol ICMPv4 -IcmpType 8 -RemoteAddress 192.168.56.0/24
```
Use this only if you need ping FROM Linux to Windows and confirm firewall scope. Do not disable Windows Firewall entirely.

### Step 6: Clean snapshot and evidence
Shut down Windows or create a VirtualBox Snapshot named `baseline-before-agent`. Capture `winver`, hostname, IP, Linux connectivity and VirtualBox screenshot. Windows agent install/verification comes AFTER management platform approval.

### Group sharing considerations
The written steps and PowerShell verification script can go on GitHub. DO NOT upload Microsoft's ISO or Windows VM disk to GitHub. If sharing an entire Windows VM with others, first ensure evaluation license/redistribution conditions permit it; the safest group method is other students installing their own evaluation copy using these instructions. One authoritative demo computer can reduce installations.
