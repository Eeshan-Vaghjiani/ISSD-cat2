# Task 2 - Agent-based vulnerability assessment (canonical report)

**Assessment evidence:** 26 October 2026. **Review:** 27 October 2026. This is the final working report, superseding both Markdown drafts retained privately in `Evidence/Member6`. It is not a claim of current uptime or a completed lecturer demonstration.

## Method and architecture

Three authorized endpoints run Wazuh 4.14.9 agents: Ubuntu 24.04.3 LTS (`issd-ubuntu`, `.11`, agent 001), Debian GNU/Linux 12 (`issd-debian`, `.12`, agent 002), and Windows 11 Enterprise Evaluation (`ISSD-CAT2-windo`, `.13`, agent 003). Addresses are in the isolated `192.168.56.0/24` host-only network.

Agents report to `issd-local-worker` at `.30`. The worker connects privately over Tailscale to the Oracle Cloud `issd-cloud-master`, indexer and dashboard. Both cluster nodes show 4.14.9; the cloud lists all three agents active on the worker. See `NETWORK_TOPOLOGY.md` for the evidence-backed diagram and synchronization limitations.

Syscollector provides installed software/OS inventory; Wazuh vulnerability detection correlates that inventory with vulnerability intelligence. This is **not exploitation**, nor a remote port scan. Cluster registration synchronization, Filebeat event forwarding and vulnerability inventory indexing are separate paths. The Filebeat TLS test to a loopback relay alone does not prove the relay's cloud destination.

**27 October live follow-up:** The relay route and TLS output were inspected directly; master/worker logs demonstrate group exchange. A uniquely marked benign Debian sudo/logger event was processed on the worker and retrieved from the cloud alert index. Worker clock skew was corrected by enabling and verifying NTP, then the test repeated. See `LIVE_CHECKS_2026-10-27.md`. This administrative test is **not** a vulnerability finding and does not alter the historical counts below.

## Observed results

| Global dashboard category | Records |
|---|---:|
| Critical | 670 |
| High | 5,019 |
| Medium | 4,647 |
| Low | 490 |
| Severity-classified subtotal | 10,826 |
| Pending evaluation | 3,407 |
| Total including pending | 14,233 |

Source: `Member6/M6-01_Vulnerability_Detection_Dashboard.png`. These are dashboard records, not distinct CVEs or 14,233 confirmed exploitable vulnerabilities.

| Endpoint | Critical | High | Medium | Low | Pending shown in filtered dashboard | Total records |
|---|---:|---:|---:|---:|---:|---:|
| Ubuntu | 283 | 2,636 | 3,087 | 444 | 1,668 | 8,118 |
| Debian | 387 | 2,378 | 1,558 | 46 | 1,739 | 6,108 |
| Windows | 0 | 5 | 2 | 0 | 0 | 7 |
| Total | 670 | 5,019 | 4,647 | 490 | 3,407 | 14,233 |

Sources: `Member6/M6-02_Ubuntu_CVE_Inventory.png`, `M6-03_Debian_CVE_Inventory.png`, `M6-04_Windows_CVE_Inventory.png`. Despite their filenames, these are **OS-filtered dashboard summaries**, not individual CVE Inventory rows. Each shows one agent in the captured lab. Future captures should use agent-ID filters if multiple agents share an OS.

Ubuntu's SCA score was 49% (118 passed / 119 failed / 42 not applicable); Debian's was 41% (76 / 106 / 25). These are configuration-check scores, not CVE counts.

## Concrete findings and evidence limits

### Ubuntu - supported endpoint inventory example

`Member5/M5-15_Cloud_Vulnerability_Indexer_Healthy.png` actually shows vulnerability Inventory rows. It links **issd-ubuntu**, **rsyslog 8.2312.0-3ubuntu9.1**, **CVE-2026-78002**, **High** in the same row. This supports an inventory-to-CVE correlation, not successful exploitation.

The vendor advisory describes a heap buffer overflow in RainerScript `replace()` that can cause denial of service. Ubuntu's advisory, checked 27 October 2026, lists the Ubuntu 24.04 fix as **8.2312.0-3ubuntu9.4**. Review exposure, apply a supported security update and refresh inventory to verify remediation. No patch was applied during this review.

### Debian - endpoint inventory example now verified

The 27 October live dashboard check filtered **agent.id 002** and **CVE-2026-93990** and returned one Inventory row linking **issd-debian / libexpat1 / 2.5.0-1+deb12u2 / High**. This is captured in `Member6/M6-09_Debian_Endpoint_CVE_Inventory.png`. It verifies Wazuh's stored endpoint correlation, not exploitation or a fresh software collection while the guest was offline. The older advisory and endpoint-overview screenshots alone were insufficient.

The Debian tracker, checked 27 October 2026, lists bookworm `2.5.0-1+deb12u2` as vulnerable, with fixed-version metadata `2.5.0-1+deb12u4` and the security repository at `2.5.0-1+deb12u5`. That supplies vendor patch information separately from Wazuh detection. Confirm the current guest package and supported security candidate before remediation; no patch/retest is claimed here.

### Windows

Seven records (5 High / 2 Medium) were displayed. Fewer records do not prove greater security: inventory freshness, product coverage, patch state and installed software differ. The advisory screenshot `M6-08_Windows_CVE_Details.png` alone is not endpoint detection evidence.

## Comparison and priorities

| Endpoint | Task 1: displayed OpenVAS findings | Task 2: Wazuh records including pending |
|---|---|---:|
| Ubuntu | 1 Critical default SSH credential finding + 2 Low timestamp findings | 8,118 |
| Debian | 1 Critical default SSH credential finding + 2 Low timestamp findings | 6,108 |
| Windows | 1 Low TCP timestamp finding | 7 |

OpenVAS observes reachable services and authentication weaknesses from the network; Wazuh correlates locally collected installed-software inventory with CVEs. Counts are not directly comparable. OpenVAS PDFs use QoD >= 70 and omit Log/Debug/False Positive entries. Do not treat generic NVT CVE references as verified endpoint CVEs.

Prioritize default SSH credential exposure without breaking authorized Vagrant/key access. Validate vendor package fixes (including backports), patch through supported channels, restrict unnecessary services and refresh both assessments. Do not broadly disable Windows Firewall or expose lab services publicly. No remediation success is claimed without a retest.

## Evidence manifest (paths relative to private `Evidence/`)

| Existing file | Correct interpretation |
|---|---|
| Member6/M6-01_Vulnerability_Detection_Dashboard.png | Global severity and pending counts |
| Member6/M6-02_Ubuntu_CVE_Inventory.png | Ubuntu OS-filtered dashboard summary |
| Member6/M6-03_Debian_CVE_Inventory.png | Debian OS-filtered dashboard summary |
| Member6/M6-04_Windows_CVE_Inventory.png | Windows OS-filtered dashboard summary |
| Member6/M6-05_Cloud_Three_Endpoints_Vulnerability_Summary.png | Cross-agent dashboard summary |
| Member6/M6-06_Ubuntu_CVE_Details.png | Ubuntu endpoint overview and SCA |
| Member6/M6-07_Debian_CVE_Details.png | Debian endpoint overview and SCA |
| Member6/M6-08_Ubuntu_CVE_Record.png | Public Ubuntu CVE advisory, not endpoint record |
| Member6/M6-08_Debian_CVE_Record.png | Public Debian CVE advisory, not endpoint record |
| Member6/M6-09_Debian_Endpoint_CVE_Inventory.png | Live 27 October dashboard retrieval: actual Debian package/version/CVE/severity row |
| Member4/M4-07_Three_Active_Endpoint_Agents.png | Three active agents on local worker |
| Member5/M5-11_Wazuh_Master_Worker_Connected.png | Master/worker names and versions |
| Member5/M5-12_Cluster_Synchronization_Health.png | Integrity check/keepalive; other sync fields n/a |
| Member5/M5-13_Worker_Filebeat_Cloud_Indexer_Connected.png | Certificate and configuration validation |
| Member5/M5-13_Worker_Filebeat_Cloud_Indexer_Connected-2.png | Filebeat active and successful TLS output to loopback relay |
| Member5/M5-14_Agent_Registration_Synced_Cloud.png | Cloud agent registration/active state |
| Member5/M5-15_Cloud_Vulnerability_Indexer_Healthy.png | Actual Ubuntu package/CVE Inventory rows |
| Member5/M5-16_Fresh_Cluster_Sync.png | Fresh local-worker group exchange and keepalive logs |
| Member5/M5-16_Cloud_Cluster_Live_Transcript.txt | Corresponding real cloud-master cluster output |
| Member5/M5-18_Relay_Route_Redacted.png | Intended cloud indexer route plus certificate-verified Filebeat output |
| Member5/M5-17_Local_To_Cloud_Receipt.png | Benign Debian test event retrieved from the actual cloud alert index |
| Member5/M5-17_Worker_Endpoint_Test_Event.jsonl | Actual corresponding worker alert records, including the synchronized repeat |
| Member5/M5-17_Debian_Test_Event_Source.png | Real source journal entry for the benign endpoint test |
| Member5/M5-21_Worker_Time_Sync_And_Agent002.png | Worker NTP synchronized and agent 002 active at capture |

Remaining evidence and live-demo requirements: `CURRENT_STATUS.md`. Original private screenshots and drafts are preserved; do not publish them with credentials or infrastructure details.

## References

- https://documentation.wazuh.com/current/user-manual/capabilities/vulnerability-detection/how-it-works.html
- https://documentation.wazuh.com/current/user-manual/capabilities/system-inventory/how-it-works.html
- https://ubuntu.com/security/CVE-2026-78002
- https://security-tracker.debian.org/tracker/CVE-2026-93990
- Original private OpenVAS PDF exports in `Evidence/Member3/`.
