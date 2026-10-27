# CAT 2 - Current status and final corrections

**Reviewed:** 27 October 2026. Sources: both shared ChatGPT reviews and the actual local `Evidence/Member1` through `Member6` files. Chat reviews are suggestions, not evidence. No VM was started or changed during this review; all were off at the initial check.

## What is supported

| Member | Evidence-backed position | Remaining action |
|---|---|---|
| 1 | Three endpoint identities and scanner-to-endpoint connectivity screenshots exist. Ubuntu OS/IP and Windows hostname are already captured. | Use current topology and explain reuse of Member4 evidence. No need to retake these identity screenshots. |
| 2 | Greenbone targets/tasks, completed scans, running containers and 140G root filesystem captured. | New ready-feed/dashboard proof: `M2-12` still says feeds syncing and new scans unavailable. |
| 3 | Three original OpenVAS PDFs and per-host extracts exist; documented totals are 2 Critical + 5 Low at QoD >= 70. | Use `Task1_Findings_and_Demo_Notes.md`; rehearse results, filters and remediation. |
| 4 | Agents 001/002/003 active on local worker in later manager screenshots. Inventory and handover corrected. | Direct endpoint service-status captures still absent; old stopped/failed captures are installation history. |
| 5 | Local/cloud 4.14.9 cluster, three agent registrations, Filebeat TLS test and cloud inventory evidenced. | Stronger actual synchronization/data-flow demonstration; explain relay destination. Lecturer platform/design acceptance not recorded. |
| 6 | Dashboard has 14,233 records, including 3,407 pending. Ubuntu package/CVE row exists in Member5 evidence. | Debian package/CVE row still needed; final report is `Task2_Findings.md`, not the two older drafts. |

## Corrections made

- Current entry point, inventory, Member4 handover, checklist, evidence index and topology reflect later evidence rather than pre-manager placeholders.
- Windows hostname is **`ISSD-CAT2-windo`**, confirmed by `Member1/M1-06_Windows_Hostname_And_IP.png` (not the VirtualBox VM name).
- Kept original screenshots unchanged; corrected their captions in `evidence/README.md` instead of hiding their actual contents.
- Added concise Member2 component/configuration explanation and one canonical sanitized Task2 report with existing filenames.
- Hardened the import launcher: a supplied checksum manifest must cover imported appliances, and inherited secondary network adapters are disabled before attaching host-only networking. Mocked safety checks pass; real imports remain untested.
- Older planning registers and handover guides are explicitly historical. Do not use their unchecked boxes as current progress.

## Screenshots still needed - exactly where to take them

### 1. Greenbone readiness - scanner VM, `ISSD-CAT2-scanner` (.20)

When running the scanner normally, wait for feed import to finish. In the existing host-browser SSH tunnel, capture **Administration -> Feed Status**, plus the dashboard/tasks with no feed-sync/scans-unavailable warning and the three completed tasks visible. Save privately as `Member2/M2-13_Feeds_Ready_For_Demo.png` and `Member2/M2-14_Dashboard_Ready_For_Demo.png`. Do not reinstall Greenbone or run new scans just to obtain a screenshot. If the warning persists, send the actual feed status and service logs for diagnosis.

### 2. Local agent service - each of the three endpoint VMs

Inside **Ubuntu (.11)** and **Debian (.12)**, separately:

```bash
date -Is
hostname
sudo systemctl status wazuh-agent --no-pager -l
```

Save `Member4/M4-12_Ubuntu_Agent_Running.png` and `Member4/M4-13_Debian_Agent_Running.png`. Capture the real output even if it fails; do not restart or re-enroll merely to conceal an error.

Inside the **Windows 11 guest (.13)**, PowerShell:

```powershell
Get-Date -Format o
hostname
Get-Service -Name WazuhSvc | Format-List Name,Status,DisplayName
```

Save `Member4/M4-14_Windows_Agent_Running.png`. The existing cloud active-agent screenshot proves check-in at capture; these separately prove local service state.

### 3. Debian finding - cloud Wazuh dashboard, not the public advisory site

Use the browser opening the **Oracle Cloud Wazuh dashboard**. Go to **Vulnerability Detection -> Inventory**, filter **agent.id = 002** and **vulnerability.id = CVE-2026-93990**. Show agent identity, `libexpat1`, installed version, CVE and severity together; save `Member6/M6-09_Debian_Endpoint_CVE_Inventory.png`. If there is no matching row, capture that and remove the claimed Debian example rather than inventing one. No Debian VM console screenshot is needed for this dashboard record (the VM must be online only if fresh inventory is required).

### 4. Synchronization - local Wazuh worker (.30) AND Oracle Cloud master

Member5 should capture fresh `date -Is` and `sudo /var/ossec/bin/cluster_control -l`, `-i`, and `-a` on the **cloud master**, with the corresponding local-worker service/log timestamps. `M5-12` currently shows `n/a` synchronization fields; a connected node alone is insufficient. Demonstrate a harmless fresh event or inventory change from one endpoint arriving at the cloud with matching agent identity and timestamps. Also show sanitized relay/service configuration connecting Filebeat's `127.0.0.1:9200` to the intended cloud indexer. Never include cluster keys, tokens, private keys or passwords. Suggested filenames: `Member5/M5-16_Fresh_Cluster_Sync.png`, `Member5/M5-17_Local_To_Cloud_Receipt.png`, `Member5/M5-18_Relay_Route_Redacted.png`.

## Final demonstration

1. Member1: VirtualBox, endpoint identity, host-only isolation, scanner reachability.
2. Member2: Greenbone components, ready feeds, target scope `.11/.12/.13`, scan policy.
3. Member3: completed reports; Linux default SSH credentials and timestamp findings; filters and mitigations.
4. Member4: three local services and cloud active-agent list; explain installation versus enrollment.
5. Member5: local worker -> private cluster/data routes -> cloud master/indexer/dashboard; live synchronization proof.
6. Member6: per-host records and one concrete package/CVE finding; contrast inventory correlation with network scanning.

Confirm lecturer acceptance of Wazuh/local-cloud design, Task1's ambiguous endpoint-agent wording, and the final date/time. Recorded brief says **Wednesday 25 November 2026, 10:00-16:00, HP Lab**; original assignment files were not re-opened in this review.

## Publication boundary

Only sanitized docs/configuration/scripts belong in Git. Preserve original VM disks, snapshots, private keys, OVAs, raw reports, evidence and old report drafts locally. Existing OVA agent-enrollment state must be checked before distribution; never clone enrolled identities. The installer/import workflow has not been tested end-to-end on another laptop.

The existing `Evidence.zip` was **not rebuilt**. Its embedded records remain the older copies; prepare a new private submission package from the corrected folders and canonical reports, not the unchanged ZIP. The 25 October Task1 PDF guide is also historical; its pending Ubuntu/storage/container captures now exist.
