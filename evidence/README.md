# Private evidence index

Reviewed 27 October 2026. Genuine screenshots and reports exist locally under `Evidence/Member1` through `Evidence/Member6`; they are deliberately excluded from Git. GitHub holds sanitized summaries, not the raw evidence. Keep originals and `Evidence.zip` private.

| Folder | Contents / interpretation |
|---|---|
| Member1 | OS/IP identity, topology and scanner-to-three-endpoint connectivity |
| Member2 | Scanner setup, feeds, targets, tasks, 140G root filesystem and running containers |
| Member3 | Three original OpenVAS PDF reports; 2 Critical + 5 Low displayed findings |
| Member4 | Agent installation history plus later three-active-agent proof; updated inventory |
| Member5 | Local/cloud Wazuh nodes, Tailscale, cluster, Filebeat and cloud inventory evidence |
| Member6 | Vulnerability dashboard summaries, endpoint summaries, advisories and report drafts |

## Final submission references

- Current gaps and exact capture instructions: `docs/CURRENT_STATUS.md`.
- New live checks and capture provenance: `docs/LIVE_CHECKS_2026-10-27.md`. All three direct endpoint service screenshots, Greenbone ready-state/policies, cluster/relay checks and the actual Debian CVE row were captured on 27 October.
- Current topology: `docs/NETWORK_TOPOLOGY.md`. `M4-09_Topology.png` is a historical pre-manager diagram, **not final architecture**.
- Current endpoint record: `docs/ENDPOINT_INVENTORY.csv`; private mirror: `Member4/M4-10_Endpoint_Inventory.csv`.
- Task 1 explanation: `docs/Task1_Findings_and_Demo_Notes.md`.
- Canonical Task 2 report: `docs/Task2_Findings.md`. Both original Member6 Markdown reports are retained as superseded drafts, not two final reports.
- `Member4/M4-02_Ubuntu_OS_IP.png` actually shows a **physical Windows host-to-Ubuntu TCP/80 test**. It is not Ubuntu OS/IP evidence. Use `Member1/M1-11_Ubuntu_OS_and_IP_LIVE.png` for that purpose.
- `M6-02` through `M6-04` show OS-filtered dashboard summaries, not individual CVE inventory rows. Original filenames are retained for traceability; use these corrected captions.
- `M6-08_Ubuntu_CVE_Record.png` and `M6-08_Debian_CVE_Record.png` are **public advisory pages**, not endpoint vulnerability records.
- `Member2/M2-12_Final_Greenbone_Dashboard.png` shows completed tasks **and a feed-sync warning**. It does not prove readiness for a new scan.
- Later `Member2/M2-13` through `M2-17` supersede that warning with actual ready-state, policies and loaded-cache proof. Keep the captured feed ages in the explanation.
- `Member5/M5-19_Cloud_Dashboard_Live.png` was captured while endpoints were intentionally off; it is not three-active-agent proof. `M5-20_Worker_Boot_Diagnostic.png` records the later recovered early-boot hang, not a healthy-state capture. Use `M5-17` for fresh cloud receipt and `M5-21` for corrected time synchronization/agent 002 state.

Do not publish credentials, private keys, enrollment tokens, infrastructure secrets or raw scan exports. Do not alter screenshots to make pending checks look successful.
