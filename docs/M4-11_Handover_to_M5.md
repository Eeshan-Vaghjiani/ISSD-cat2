# Member 4 — Wazuh Endpoint Installation Handover

**Project:** ISSD CAT 2, Task 2 (agent-based distributed vulnerability assessment)  
**Updated:** 27 October 2026 from later private evidence (26 October captures).  
**Status:** All three agents were active in the earlier manager evidence. Direct running-service screenshots were collected from all three guests on 27 October. See `LIVE_CHECKS_2026-10-27.md`; these are dated observations, not a claim of continuous uptime.

## 1. Installed endpoint inventory

| VM | Verified hostname | OS | Host-only address | Agent package | Installation | Service status |
|---|---|---|---|---|---|---|
| ISSD-CAT2-ubuntu | `issd-ubuntu` | Ubuntu Server 24.04.3 LTS | `192.168.56.11` | Wazuh Agent `4.14.9-1` | Installed | Active (running), 27 October guest-console capture M4-12 |
| ISSD-CAT2-debian | `issd-debian` | Debian 12 (Bookworm) | `192.168.56.12` | Wazuh Agent `4.14.9-1` | Installed | Active (running), 27 October guest-console capture M4-13 |
| ISSD-CAT2-windows | `ISSD-CAT2-windo` | Windows 11 Enterprise Evaluation | `192.168.56.13` | Wazuh Agent `4.14.9` | Installed | WazuhSvc Running, 27 October guest-console capture M4-14 |

Ubuntu and Debian are managed by Vagrant from `E:\ISSD_CAT2` on the host. Windows runs as a manually created VirtualBox VM. Each endpoint has a host-only adapter in `192.168.56.0/24` and a NAT adapter for outbound traffic.

## 2. Existing recovery snapshots

- Ubuntu: `clean-network-baseline`; `wazuh-installed-before-manager`.
- Debian: `clean-network-baseline`; `wazuh-installed-before-manager`.
- Windows: `baseline-before-agent`; `wazuh-installed-before-manager`.

Do not restore or overwrite these snapshots as part of routine installation or service checks. Snapshots taken before enrollment cannot be used to clone already enrolled identities.

## 3. Member 4 evidence

**Final registration evidence:** `M4-07_Three_Active_Endpoint_Agents.png` shows all three active on `issd-local-worker`. The `M4-04_Ubuntu_Agent_Connected.png`, `M4-05_Debian_Agent_Connected.png` and `M4-06_Windows_Agent_Connected.png` files show progressive enrollment. Windows identity is confirmed in `Member1/M1-06_Windows_Hostname_And_IP.png`; Ubuntu identity in `Member1/M1-11_Ubuntu_OS_and_IP_LIVE.png`.

The earlier failed/stopped service screenshots below are **installation history**, not final state. `M4-02_Ubuntu_OS_IP.png` actually shows a physical-host TCP connectivity check; use the later Ubuntu identity capture. `M4-09_Topology.png` is superseded by `NETWORK_TOPOLOGY.md`.

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

## 4. Member 5 integration and remaining proof

1. Captured design: 4.14.9 local worker at `192.168.56.30`, private Tailscale connection to the Oracle Cloud master/indexer/dashboard; all three agents registered on the worker.
2. Preserve the existing manager configuration and enrolled identities. Do not repeat enrollment or restore pre-manager snapshots just to collect evidence.
3. Capture direct endpoint service status and refresh three-agent last-seen information during rehearsal.
4. Supply stronger actual local/cloud synchronization and relay-route proof: existing cluster output includes `n/a` fields and the Filebeat test targets loopback. See `CURRENT_STATUS.md`.
5. Obtain lecturer acceptance of Wazuh and the local/cloud interpretation; connectivity alone does not establish every marking requirement.

Do not place API keys, credentials, or enrollment secrets in GitHub or shared evidence.

## 5. Final Member 4 closeout

- Existing manager enrollment is evidenced; do not replace it with placeholders.
- Capture each local service as `active (running)` / `Running`; report any real failures before changing configuration.
- Reconfirm agent IDs 001/002/003 and current last-seen timestamps in the dashboard during rehearsal.
- Inventory now references all three real direct local-service screenshots (M4-12, M4-13, M4-14), separately from historical manager check-in evidence.
- Deliver evidence to Members 5 and 6 for vulnerability detection and final presentation.

## 6. Lecturer explanation

"I prepared three independent endpoints and installed Wazuh Agent 4.14.9. The later cloud dashboard shows all three agents active through our local worker. The inventory and topology now reflect that state, while earlier failed/stopped screenshots are installation history. I distinguish local service proof from manager check-in; Members 5 and 6 explain cloud integration and vulnerability records."
