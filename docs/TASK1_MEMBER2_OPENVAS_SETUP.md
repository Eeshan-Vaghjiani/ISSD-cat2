# Task 1 — Member 2: Greenbone Community Edition (OpenVAS)

**Purpose:** Independent, authorized network scanner for the three existing endpoints. **Status (27 October evidence review):** Installed; targets/tasks and three completed scans are captured. The final dashboard still shows feeds syncing, so current new-scan readiness is **not established**. Commands below document the original build path, not instructions to reinstall the existing scanner.

## Final explanation for Member 2

Greenbone Community Edition runs in Docker Compose on `ISSD-CAT2-scanner` (`192.168.56.20`). OpenVAS executes remote vulnerability tests; feeds supply those tests and supporting security data. `gvmd` manages targets, tasks, stored findings and consolidated reports; PostgreSQL persists management data; the web interface presents them. This is the network VA management/correlation role, not Wazuh agent collection.

The recorded workflow used separate tasks `ISSD-Scan-Ubuntu`, `ISSD-Scan-Debian` and `ISSD-Scan-Windows` for `.11`, `.12` and `.13`, with the documented `OpenVAS Default` scanner / `Full and fast` policy. Show actual task details during rehearsal to verify that policy; task names alone do not prove it. Access the web UI through the existing SSH tunnel at `https://localhost:8443`, not a public listener. Scope is only the three authorized endpoints; do not disable Windows Firewall globally.

`M2-10_Final_Scanner_Storage.png` shows a **140G root filesystem**. `M2-11_Greenbone_Containers_Healthy.png` shows services Up and health checks where configured. `M2-12_Final_Greenbone_Dashboard.png` shows three Done tasks **but also a feed-sync/scans-unavailable warning**. Keep early dashboards as setup history; capture a ready feed/dashboard state before the live demonstration. See `CURRENT_STATUS.md` for filenames and required views.

## Lecturer deliverables
- Network VA scanner / management interface initialized and running.
- Scan targets and policy configured for all three endpoints.
- Working vulnerability test feeds.
- Screenshots demonstrating scanner dashboard, targets, configuration and scan readiness.
- Task 1 wording about endpoint-specific agents should be clarified with lecturer. OpenVAS network scan is agentless.

## Existing lab (do not reinstall)
| VM | Address | Role |
|---|---|---|
| ISSD-CAT2-ubuntu | 192.168.56.11 | Nginx + Wazuh endpoint |
| ISSD-CAT2-debian | 192.168.56.12 | Apache + Wazuh endpoint |
| ISSD-CAT2-windows | 192.168.56.13 | Windows + Wazuh endpoint |
| ISSD-CAT2-scanner (NEW) | 192.168.56.20 | Network scanner |

All addresses use the existing VirtualBox host-only `192.168.56.0/24` network; a separate NAT adapter provides outbound feed downloads. The scanner must reach each VM; preserve all existing snapshots.

## Phase 1: Add scanner VM (from HOST CMD)

Place `scanner/Vagrantfile` next to this document under `E:\ISSD_CAT2`. Open CMD:

```cmd
cd /d E:\ISSD_CAT2\scanner
vagrant validate
vagrant up --provider=virtualbox
vagrant status
vagrant ssh -c "hostname; ip -br -4 addr; free -h; df -h /"
```

**Resource note:** Scanner recipe allocates 6 GiB RAM / 1 vCPU, a compromise on a physical 16-GB laptop. Official Greenbone documentation gives a 4-GB minimum and recommends 8 GB (20 GB minimum storage, 60 GB recommended). Scan one target at a time if needed; close unnecessary apps; shut down VMs not involved in the current scan. Do not change existing VM allocations.

On your Windows HOST, check the scanner's SSH reachability:

```cmd
powershell -NoProfile -Command "Test-NetConnection 192.168.56.20 -Port 22 | Select-Object ComputerName,RemotePort,TcpTestSucceeded"
```

Start the Ubuntu and Debian targets only if necessary, in a **different CMD window at E:\ISSD_CAT2**:

```cmd
cd /d E:\ISSD_CAT2
vagrant up ubuntu
vagrant up debian
```

Then from the scanner directory:

```cmd
cd /d E:\ISSD_CAT2\scanner
vagrant ssh -c "curl -I --max-time 8 http://192.168.56.11/; curl -I --max-time 8 http://192.168.56.12/"
```

A 200/3xx/4xx HTTP response still proves a reachable web service; timeout or network-unreachable means networking needs diagnosis. Windows will be checked after it is started.

## Phase 2: Original Greenbone installation plan (historical)

**Official source:** https://greenbone.github.io/docs/latest/22.4/container/

Use official Greenbone Community Containers on this dedicated Ubuntu scanner. Install Docker Engine and Compose from Docker's current Ubuntu guidance, download the official `compose.yaml`, run the containers, secure the admin password, wait for feed loading, then access the dashboard over an SSH tunnel rather than exposing the management interface to the LAN. Do not claim this phase is done until commands and UI prove it.

## Original proposed evidence filenames (historical; actual names above)
| Proposed filename in Evidence\\Member2 | Screenshot subject | Status |
|---|---|---|
| M2-01_Scanner_VM_IP.png | Dedicated VM hostname, RAM and 192.168.56.20 | Pending |
| M2-02_Target_Network_Reachability.png | Scanner reaching all three targets | Pending |
| M2-03_Greenbone_Dashboard.png | Working dashboard | Pending |
| M2-04_Feeds_Ready.png | Loaded, current vulnerability feeds | Pending |
| M2-05_Three_Targets.png | Targets .11, .12, .13 configured | Pending |
| M2-06_Scan_Configuration.png | Scan policy and task ready | Pending |

**Member 3 only begins actual vulnerability scans once Member 2's scanner and feed checks pass.** Keep raw findings and scan exports for the final Task 1 report. Never invent scan results.

## Sources
- Original lecturer assignment: *BICS ISSD CAT 2 2026.docx*, Task 1.
- Group allocation: *ISSD_CAT2_6_Member_Task_Allocation.pdf*, Member 2.
- Greenbone official community container docs: https://greenbone.github.io/docs/latest/22.4/container/
