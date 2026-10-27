# Task 1 — Member 1: Virtual Lab, Three Endpoints and Connectivity

**Status (27 October review):** Endpoint identity and scanner-to-all-three connectivity screenshots exist. Windows hostname is `ISSD-CAT2-windo`; direct Ubuntu identity is in `M1-11_Ubuntu_OS_and_IP_LIVE.png`. This is captured evidence, not a live health check.  
**Assessment:** Network-based distributed vulnerability assessment, Member 1 section.  
**Source:** Six-member allocation and the lecturer's original 2026 brief.  
**Do not rebuild the virtual machines.** Use `E:\ISSD_CAT2` on the physical Windows laptop. No `vagrant init`, `vagrant destroy`, snapshot restoration, agent reinstall or new VM export is required.

## 1. Existing topology — verified historical baseline

```text
               Physical Windows laptop (16 GB RAM)
                   Oracle VirtualBox
                  /                 \
       Adapter 1 NAT          Host-only network
       (outbound access)      192.168.56.0/24
                                    |
                     +--------------+----------------+
                     |              |                |
           Ubuntu 24.04.3        Debian 12       Windows 11 Eval
           issd-ubuntu          issd-debian      ISSD-CAT2-windo
           192.168.56.11        192.168.56.12   192.168.56.13
           Nginx TCP 80         Apache TCP 80    Wazuh installed
                     |              |                |
                Task 1 scanner 192.168.56.20 (same host-only LAN)
```

**Why this network:** VirtualBox isolates the three lab endpoints on one laptop. Host-only networking lets the scanner reach `.11`, `.12` and `.13` without exposing intentionally weak services to the public LAN; NAT separately supports updates. Both tasks reuse these three endpoints. Reused Member4 screenshots are credited in `PROVENANCE.md`, not presented as new captures. The current combined topology is `NETWORK_TOPOLOGY.md`.

## 2. Evidence that already exists — do not retake without reason

| Requirement | Already available evidence | Use |
|---|---|---|
| Hypervisor plus three endpoint VMs | `Evidence\Member4\M4-01_VirtualBox_3VMs.png` | Reference in Member 1 demonstration |
| Ubuntu OS and private IP | `Evidence\Member4\M4-02_Ubuntu_OS_IP.png` | Reference |
| Debian OS and private IP | `Evidence\Member4\M4-03_Debian_OS_IP.png` | Reference |
| Windows OS and private IP | `Evidence\Member4\M4-04_Windows_OS_IP.png` | Reference; check whether guest hostname visible |
| Reachable Linux test services | `Evidence\Member4\M4-08_Linux_Connectivity.png` | Reference; earlier connectivity proof |
| Topology | `Evidence\Member4\M4-09_Topology.png` | Reference; update later only if scanner placement absent/incorrect |
| Endpoint inventory | `docs\ENDPOINT_INVENTORY.csv`; also `Evidence\Member4\M4-10_Endpoint_Inventory.csv` | Correct actual Windows hostname |

**Later scanner proof:** `Evidence/Member1/M1_Scanner_to_Ubuntu_Connectivity.png`, `M1_Scanner_to_Debian_Connectivity.png`, and `M1_Scanner_to_Windows_Connectivity.png` show scanner-origin checks. Earlier host-to-target captures alone do not prove scanner reachability. `M4-02_Ubuntu_OS_IP.png` is a host TCP test, not Ubuntu identity; use `M1-11` instead.

## 3. Quick no-change state check — physical Windows CMD

Commands below are on the **physical host**, not inside a VM:

```cmd
cd /d E:\ISSD_CAT2
vagrant status
"%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" list vms
```

These show which VMs are registered and their current Vagrant status. If powered off following recent OVA exports, that's expected; **do not start all three merely to repeat existing screenshots**.

If the Windows VM is available and on, verify its hostname directly *inside Windows guest PowerShell*:

```powershell
hostname
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias,IPAddress,PrefixLength
```

Record the real guest hostname; avoid guessing from its VirtualBox VM name. Screenshot only if not already captured. Update the inventory's `Actual_Hostname` field and correct `Expected_Hostname` if it was mistyped. Do not alter the proven static host-only IP unless the guest itself shows a genuine problem.

## 4. If historical TCP reachability screenshot is inadequate (optional retest)

Start the Linux VMs **only if required** using physical Windows CMD in `E:\ISSD_CAT2`:

```cmd
vagrant up ubuntu
vagrant up debian
```

Then physical Windows PowerShell:

```powershell
Test-NetConnection 192.168.56.11 -Port 80
Test-NetConnection 192.168.56.12 -Port 80
```

Expected evidence: `TcpTestSucceeded : True` only when the services are actually running. Do not assume any Windows inbound port must be open; Windows firewall may block pings or particular services without implying the VM is absent.

**Evidence path only if retested:** `E:\ISSD_CAT2\Evidence\Member1\M1-05_Host_to_Linux_TCP_Connectivity.png`.

## 5. Deferred but mandatory: scanner-to-all-three reachability

After Member 2 creates a network scanner, capture proof *from the scanner environment* that it can address all three in-scope hosts. A host-only network is local to one physical laptop. Scanner VLAN/host-only interface must be correctly attached. Use safe host-discovery and service information; do not disable Windows Firewall globally to force a successful result.

Record actual scanner IP/interface, targets detected, scan policy, and whether the Windows target's ports appear filtered. Link to Member 2 evidence and capture `M1-07_Scanner_To_All_Endpoints.png` once verified. A scan completing against three targets is stronger evidence than a ping alone.

## 6. Final explanation for lecturer (after verifying facts)

> For the network-based vulnerability assessment, we used Oracle VirtualBox to run three separate endpoints: Ubuntu, Debian and Windows 11. All are connected to a host-only network in the `192.168.56.0/24` subnet, with `.11`, `.12` and `.13` assigned respectively. A separate NAT adapter permits operating-system updates without making our lab depend on an exposed bridged network. We first checked the operating systems, IP addresses and reachability. We then attached the network vulnerability scanner to the same assessment network so it could assess the three hosts remotely. The next part of the demonstration shows our scanner and its results.

Only use the scanner sentence after that step is actually complete.

## 7. Member 1 closeout

- [x] Three operating systems installed and configured.
- [x] NAT and host-only adapter design established.
- [x] Historical test-service connectivity evidence captured.
- [x] Existing topology diagram and inventory.
- [x] Windows guest hostname reconfirmed and inventory corrected.
- [x] Member 1 screenshot references and provenance documented.
- [x] Scanner-to-three-endpoint connectivity captures present (historical evidence).

**Next phase:** Rehearse using the current topology; Member2 must refresh Greenbone readiness as described in `CURRENT_STATUS.md`.
