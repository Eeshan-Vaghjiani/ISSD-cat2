# ISSD CAT 2 — Master Progress and Evidence Register

> **Historical planning register (24 October):** The unchecked boxes and pre-manager state below are retained as the original plan, not current status. For the 27 October evidence review use [CURRENT_STATUS.md](CURRENT_STATUS.md), [08_GROUP_CHECKLIST.csv](08_GROUP_CHECKLIST.csv) and [ENDPOINT_INVENTORY.csv](ENDPOINT_INVENTORY.csv). Three later active-agent captures and cloud findings supersede the pending enrollment entries.

**Source of requirements:** `BICS ISSD CAT 2 2026.docx` (3 pages) and `ISSD_CAT2_6_Member_Task_Allocation (1).pdf` (2 pages).  
**Working date:** 24 October 2026  
**Demonstration:** On or before Wednesday, 25 November 2026, 10:00–16:00, HP Lab.  
**Project root on operator's Windows laptop:** `E:\ISSD_CAT2`  
**GitHub:** https://github.com/Eeshan-Vaghjiani/ISSD-cat2 (`master`)  
**Important:** This is an *evidence tracker*, not a claim that pending checks have passed. Record only real observations and screenshots.

## A. Requirements and marks

### Task 1: Network-based distributed vulnerability assessment — 17 marks

- Hypervisor/VMM/container (1 mark).
- At least three endpoints (6 marks).
- Network VA correlation/management engine setup (2 marks).
- Network scanning (6 marks).
- Reports (2 marks).
- Approved examples: Nessus agentless, Metasploit, OpenVAS, W3AF or another network VA tool.
- **Clarification needed:** Task 1 is called network-based/agentless but also contains a line saying "End-point Specific agents distributed vulnerability collection." Confirm expected interpretation with lecturer; do not quietly ignore it.
- Task 1 cloud connection is conditional: "local synced with a cloud instance **if necessary**".

### Task 2: Agent-based distributed vulnerability assessment — 17 marks

- Hypervisor/VMM/container and at least three endpoints.
- Endpoint-specific agents and distributed vulnerability collection.
- **Local correlation engine synchronized with a cloud instance is required**, not optional.
- Examples: Tenable/Nessus, Nexpose/InsightVM or supported alternatives. Wazuh is installed but its lecturer acceptance and actual local/cloud design are not yet verified.

### Submission

Both exercises demonstrated in HP Lab; each member can explain observations. The assignment **does not expressly require a separate written report**. We are retaining clear documentation, genuine screenshots, exported scans and results to make the demonstration strong and reproducible.

## B. Real endpoint baseline (historical checks; live status to be reconfirmed only when needed)

| VM | Guest OS | Host-only IP | Network/service | Agent | Current documented status |
|---|---|---|---|---|---|
| `ISSD-CAT2-ubuntu` | Ubuntu 24.04.3 LTS; hostname `issd-ubuntu` | `192.168.56.11` | NAT + host-only; Nginx on TCP/80 | Wazuh 4.14.9-1 | Installed and enabled; service did not start with invalid `MANAGER_IP` placeholder; not enrolled |
| `ISSD-CAT2-debian` | Debian 12; hostname `issd-debian` | `192.168.56.12` | NAT + host-only; Apache on TCP/80 | Wazuh 4.14.9-1 | Installed and enabled; running status not yet verified; not enrolled |
| `ISSD-CAT2-windows` | Windows 11 Enterprise Evaluation; **actual guest hostname still unconfirmed** | `192.168.56.13` | NAT + host-only; Windows-to-Linux connectivity previously verified | Wazuh 4.14.9 | Installed; `wazuhsvc` stopped at last check; not enrolled |

**Existing recovery snapshots:** Linux: `clean-network-baseline`, `wazuh-installed-before-manager`; Windows: `baseline-before-agent`, `wazuh-installed-before-manager`. Keep them. Avoid restoring/deleting, reinstalling or exporting again unless troubleshooting requires it.

## C. Member-by-member work register

Status legend: **Evidence exists** = supported by existing local/Drive evidence; **partial** = some work missing; **pending** = not yet demonstrated.

### Member 1 — Task 1: Isolated virtual lab + 3 reachable endpoints (PARTIAL; near complete)
- [x] VirtualBox environment and three VM operating systems prepared.
- [x] Host-only LAN `192.168.56.0/24` plus NAT configured.
- [x] Historical Ubuntu/Debian IP/service verification and Windows connectivity.
- [x] Existing topology graphic and endpoint screenshots (from Member 4 evidence).
- [ ] Confirm actual Windows guest hostname; correct `docs/ENDPOINT_INVENTORY.csv`.
- [ ] Select/reuse final network evidence and create Member 1 evidence manifest.
- [ ] **After the Task 1 scanner is deployed:** prove scanner has appropriate access to all three addresses and capture screenshot.
- [ ] Final screenshot captions/explanation checked.

**Available files in `Evidence\Member4` (already uploaded to Google Drive):** `M4-01_VirtualBox_3VMs.png`, `M4-02_Ubuntu_OS_IP.png`, `M4-03_Debian_OS_IP.png`, `M4-04_Windows_OS_IP.png`, `M4-08_Linux_Connectivity.png`, `M4-09_Topology.png`, `M4-10_Endpoint_Inventory.csv`. Reuse or reference the same genuine evidence; do not recreate solely to rename it.

**New/pending Member 1 evidence:** `M1-06_Windows_Hostname_And_IP.png` if not visible in prior capture; `M1-07_Scanner_To_All_Endpoints.png` when scanner available.

### Member 2 — Task 1: VA scanner and management (PENDING)
- [ ] Select supported tool and installation approach based on 16 GB host RAM and E: SSD space.
- [ ] Install scanner in an authorized environment that can reach the host-only LAN.
- [ ] Confirm management UI loads and feeds/plugins ready; capture version/feed status.
- [ ] Create scope/targets for `192.168.56.11`, `.12`, `.13` only.
- [ ] Configure defensible discovery/scan policy; note Windows firewall limitations rather than disabling protections broadly.
- [ ] Save dashboard, feeds, target configuration and scan policy screenshots.
- [ ] Clarify Task 1 endpoint-agent ambiguity with lecturer.

**Evidence suggestions:** `M2-01_Scanner_Dashboard.png`; `M2-02_Version_And_Feed_Status.png`; `M2-03_Three_Targets.png`; `M2-04_Scan_Policy.png`; `M2-05_Scanner_Network_Access.png`.

### Member 3 — Task 1: Scans and reporting (PENDING)
- [ ] Scan Ubuntu; retain completed scan ID/timestamp, target, duration, feed version and counts by severity.
- [ ] Scan Debian; record equivalent details.
- [ ] Scan Windows; note host discovery/firewall/authentication constraints.
- [ ] Export actual available scan report(s) from chosen tool; keep raw artifact if permitted.
- [ ] Explain top findings using observed evidence, actual CVEs and remediation; do not invent vulnerabilities if none found.
- [ ] Describe scanner limitations and compare endpoint coverage.
- [ ] Complete Task 1 demo narrative and verify that the three targets are visibly included.

**Evidence suggestions:** `M3-01_Ubuntu_Completed_Scan.png`; `M3-02_Debian_Completed_Scan.png`; `M3-03_Windows_Completed_Scan.png`; `M3-04_Severity_Comparison.png`; `M3-05_Exported_Report.png`; `Task1_Findings.md` plus genuine tool exports.

### Member 4 — Task 2: Endpoints + agents (PARTIAL)
- [x] Three agent-compatible endpoint OSs installed.
- [x] Wazuh 4.14.9/4.14.9-1 packages installed and installation evidence captured.
- [x] OS/IP inventory, network proof, snapshots and handover documented.
- [ ] Actual Windows hostname captured and reflected in inventory.
- [ ] Configure valid manager IP/hostname after architecture approved.
- [ ] Show Wazuh agent **running** on Ubuntu, Debian and Windows (three real screenshots).
- [ ] Update status/evidence fields in `docs/ENDPOINT_INVENTORY.csv`.

**New/pending evidence:** `M4-12_Ubuntu_Agent_Running.png`; `M4-13_Debian_Agent_Running.png`; `M4-14_Windows_Agent_Running.png`.

### Member 5 — Task 2: Local manager, cloud sync, enrollment (PENDING)
- [ ] Confirm Wazuh is acceptable as a supported agent-based VA alternative for the CAT.
- [ ] Plan memory/placement: local manager/indexer/dashboard and cloud instance; prove actual synchronization, not two unrelated dashboards.
- [ ] Install compatible management components and secure access; document non-secret addresses and versions.
- [ ] Demonstrate real local-to-cloud synchronization with observed timestamps/events/status.
- [ ] Configure real manager address and enroll three uniquely identified agents.
- [ ] Show all three connected, last-seen/check-in information, and healthy managers.

**Evidence suggestions:** `M5-01_Local_Manager.png`; `M5-02_Cloud_Instance.png`; `M5-03_Sync_Proof.png`; `M5-04_Three_Agents_Active.png`; `Task2_Architecture.md`.

### Member 6 — Task 2: Agent collection, analysis, final demo (PENDING)
- [ ] Confirm agent vulnerability-detection/inventory processing is running on each endpoint.
- [ ] Capture actual per-host vulnerability counts, CVEs, severity and status.
- [ ] Export permitted results/reports for all three systems.
- [ ] Compare agent-collected and network-collected evidence, noting coverage and limitations.
- [ ] Prepare demo order, presenter explanations and lecturer follow-up questions.

**Evidence suggestions:** `M6-01_Ubuntu_Agent_Findings.png`; `M6-02_Debian_Agent_Findings.png`; `M6-03_Windows_Agent_Findings.png`; `M6-04_Network_vs_Agent.png`; `Task2_Findings.md`; `FINAL_DEMO_SCRIPT.md`.

## D. Evidence storage policy

On Windows host, use:

```text
E:\ISSD_CAT2\
├── docs\
│   ├── CAT2_MASTER_PROGRESS_AND_EVIDENCE.md  <- this file
│   ├── TASK1_MEMBER1_RECORD.md
│   └── ... existing documentation
├── Evidence\
│   ├── Member1\
│   ├── Member2\
│   ├── Member3\
│   ├── Member4\  <- existing evidence; leave intact
│   ├── Member5\
│   └── Member6\
└── Reports\
    ├── Task1\
    └── Task2\
```

- **GitHub:** documentation, redacted configuration, scripts. `.gitignore` already excludes `/Evidence/*`, and `*.ova`, `*.iso`, virtual disks.
- **Drive/local:** original screenshots, large raw scans, exported reports, OVA backups. Treat the public GitHub repository as unsuitable for credentials, keys, detailed raw vulnerability scans or private machine identifiers.
- Add `/Reports/` to `.gitignore` before storing raw tool reports if the repository remains public.
- Each screenshot should show real date/host/target/status where possible; put its purpose and interpretation in a short adjacent caption in Markdown.

## E. Phase gates (do not advance prematurely)

1. **Member 1 closeout:** Three endpoint configurations evidenced; actual Windows hostname recorded; identify remaining scanner-to-target check as awaiting scanner.
2. **Member 2:** Scanner deployed, updates ready and three targets configured.
3. **Member 3:** Three actual completed scans, genuine exports, findings explanation. **Task 1 complete.**
4. **Member 4 + Member 5:** Compatible manager/cloud architecture operational; three agents running and checked in.
5. **Member 6:** Real agent findings on three endpoints, comparison and complete demo. **Task 2 complete.**

## F. Working evidence log (append a row every time a step succeeds)

| Date | Member | Command/test | Observed result | Screenshot/report path | Status |
|---|---|---|---|---|---|
| 2026-10-23 | 4 | Existing evidence upload to Drive | 12 files transferred/listed in prior rclone output | `ISSD-CAT2-Group/Member-Evidence/Member4` | Verified at time |
| — | 1 | Windows guest hostname and IP | **TO RECORD** | — | Pending |
| — | 2 | Scanner UI and feed update | **TO RECORD** | — | Pending |
| — | 3 | Three completed network scans | **TO RECORD** | — | Pending |
| — | 5 | Wazuh local/cloud synchronization and enrollment | **TO RECORD** | — | Pending |
| — | 6 | Three agent finding datasets | **TO RECORD** | — | Pending |

**Never record a pending test as passed simply because a setup command returned without error.**
