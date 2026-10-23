# Member 4 — Wazuh Endpoint Installation Handover

**Project:** ISSD CAT 2, Task 2 (agent-based distributed vulnerability assessment)  
**Recorded:** 23 October 2026  
**Status:** Endpoint installations completed; manager integration and service-running evidence pending.

## 1. Installed endpoint inventory

| VM | Verified hostname | OS | Host-only address | Agent package | Installation | Service status |
|---|---|---|---|---|---|---|
| ISSD-CAT2-ubuntu | `issd-ubuntu` | Ubuntu Server 24.04.3 LTS | `192.168.56.11` | Wazuh Agent `4.14.9-1` | Installed; enabled; apt hold | Failed when started: invalid `MANAGER_IP` placeholder |
| ISSD-CAT2-debian | `issd-debian` | Debian 12 (Bookworm) | `192.168.56.12` | Wazuh Agent `4.14.9-1` | Installed; enabled; apt hold | Not yet verified as running |
| ISSD-CAT2-windows | **Confirm actual hostname in Windows** | Windows 11 Enterprise Evaluation | `192.168.56.13` | Wazuh Agent `4.14.9` | Installed; version verified | `wazuhsvc` stopped at last check |

Ubuntu and Debian are managed by Vagrant from `E:\ISSD_CAT2` on the host. Windows runs as a manually created VirtualBox VM. Each endpoint has a host-only adapter in `192.168.56.0/24` and a NAT adapter for outbound traffic.

## 2. Existing recovery snapshots

- Ubuntu: `clean-network-baseline`; `wazuh-installed-before-manager`.
- Debian: `clean-network-baseline`; `wazuh-installed-before-manager`.
- Windows: `baseline-before-agent`; `wazuh-installed-before-manager`.

Do not restore or overwrite these snapshots as part of routine installation or service checks. Snapshots taken before enrollment cannot be used to clone already enrolled identities.

## 3. Member 4 evidence

The last supplied folder listing confirmed these files (verify if more were added afterward):

- `M4-02_Ubuntu_OS_IP.png.png` (possibly subsequently renamed to `.png`)
- `M4-05_Ubuntu_Agent_Installed.png`
- `M4-06_Debian_Agent_Installed.png`
- `M4-07_Windows_Agent_Installed_Version.png`
- `M4-07B_Windows_Agent_Service_Status.png`
- `M4-08_Linux_Connectivity.png`

Additional evidence to retain:

- `M4-01_VirtualBox_3VMs.png` — three VM list
- `M4-03_Debian_OS_IP.png` — OS/IP proof
- `M4-04_Windows_OS_IP.png` — OS/IP and actual hostname
- `M4-09_Topology.png` — diagram of configured lab and pending management architecture
- `M4-10_Endpoint_Inventory.csv` — updated copy of `docs/ENDPOINT_INVENTORY.csv`
- Three **running** service captures after integration (must not be inferred from installed package screenshots)

## 4. What Member 5 must provide

1. Lecturer-accepted agent-based VA platform / Wazuh deployment design and manager version compatible with the installed 4.14.9 agents.
2. Management address or DNS name that is reachable **from all three VMs**. The `192.168.56.x` addresses are host-only on the endpoint operator's laptop and are not directly routed to a teammate's laptop.
3. Secure network route / VPN or other approved connectivity for agents to reach the manager.
4. Agent enrollment instructions. Standard Wazuh ports are TCP 1515 for enrollment and TCP 1514 for agent communication, but actual configuration must be confirmed.
5. Evidence of **actual local/cloud synchronization**, not just a cloud dashboard screenshot; lecturer approval of the chosen interpretation is necessary.

Do not place API keys, credentials, or enrollment secrets in GitHub or shared evidence.

## 5. Final Member 4 work after manager is available

- Configure the real manager address on Ubuntu, Debian and Windows.
- Start and verify each service is `active (running)` / `Running`.
- Confirm each agent checks in to Member 5's Wazuh dashboard; confirm real agent IDs and last-seen timestamps.
- Update the inventory with actual `Service_Running`, `Manager_Registration_Status` and **running service screenshot** filenames.
- Deliver evidence to Members 5 and 6 for vulnerability detection and final presentation.

## 6. Lecturer explanation

"I set up three independent Windows and Linux endpoints and installed Wazuh Agent 4.14.9 on each one. Their snapshots and OS/IP inventory are recorded. Local service execution and successful central check-in are separate requirements: we finish those after connecting to Member 5's management server. The server and final vulnerability findings are handled by Members 5 and 6."
