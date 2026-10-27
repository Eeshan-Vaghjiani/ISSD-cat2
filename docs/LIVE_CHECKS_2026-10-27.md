# CAT 2 - Live verification, 27 October 2026

This supplements the earlier screenshot review. Existing machines were booted normally with operator approval; no disks, snapshots or enrolled identities were reset. Checks use real command output and application pages. Times in guest output are UTC.

| Check | Observed result | Private evidence relative to `Evidence/` |
|---|---|---|
| Ubuntu, 12:30 UTC | `issd-ubuntu`, `.11`, agent package 4.14.9-1, systemd active (running) | Member4/M4-12_Ubuntu_Agent_Running.png |
| Debian, 12:33 UTC | `issd-debian`, `.12`, agent package 4.14.9-1, systemd active (running) | Member4/M4-13_Debian_Agent_Running.png |
| Windows, 16:07 +03:00 | `ISSD-CAT2-windo`, `.13`, OS 10.0.26300, WazuhSvc Running | Member4/M4-14_Windows_Agent_Running.png |
| Local/cloud cluster, 12:43 UTC | Master and worker 4.14.9 connected; worker logs show successful keepalive and agent-group chunks received | Member5/M5-16_Fresh_Cluster_Sync.png |
| Cloud counterpart | Master logs show corresponding agent-group chunks sent; cloud services active | Member5/M5-16_Cloud_Cluster_Live_Transcript.txt |
| Private relay, 12:46 UTC | Loopback listener forwards to intended cloud Tailscale indexer; Filebeat TLS chain verification and output test pass | Member5/M5-18_Relay_Route_Redacted.png |
| Debian CVE, live dashboard retrieval | Agent 002 filter returns one Inventory row: libexpat1 2.5.0-1+deb12u2 / CVE-2026-93990 / High | Member6/M6-09_Debian_Endpoint_CVE_Inventory.png |
| Greenbone readiness | Dashboard has no feed-sync warning; all three tasks Done; policies all OpenVAS Default / Full and fast | Member2/M2-14_Dashboard_Ready_For_Demo.png; M2-15_Three_Completed_Tasks_Live.png; M2-16_Ubuntu_Task_Policy_Live.png; M2-16_Debian_Task_Policy_Live.png; M2-16_Windows_Task_Policy_Live.png |
| Feed versions | NVT 20261023T0724; SCAP 20261020T0205; CERT 20261023T0425; GVMD_DATA 20261023T0512; UI age 4-7 days | Member2/M2-13_Feeds_Ready_For_Demo.png |
| Scanner backend | gvmd healthy; VT cache finished loading version 202610230724 at 13:16:59 UTC; root filesystem 140G | Member2/M2-17_Scanner_Services_And_VT_Cache_Live.png |
| Fresh end-to-end receipt | A clearly labelled benign Debian sudo/logger test was processed by the worker (rule 5402) and found in the cloud `wazuh-alerts-*` index | Member5/M5-17_Local_To_Cloud_Receipt.png; M5-17_Worker_Endpoint_Test_Event.jsonl; M5-17_Debian_Test_Event_Source.png |
| Worker clock correction | NTP was inactive and clock lagged several minutes; enabled with `timedatectl set-ntp true`; subsequently synchronized to ntp.ubuntu.com | Member5/M5-21_Worker_Time_Sync_And_Agent002.png |

## Interpretation and provenance

- Linux screenshots are unmodified VirtualBox framebuffer captures. The commands were run on a temporary alternate guest text console through authorized SSH (`openvt`); shell tracing makes the commands visible. They are not images rendered from invented terminal text.
- The Debian finding is an unmodified browser screenshot of the real cloud dashboard through an SSH tunnel. It proves the **stored endpoint inventory record**, not a fresh collection while the endpoint was offline, and not exploitation.
- `cluster_control -i` still reports some summary fields as `n/a`. Actual worker/master logs show successful agent-group exchange and integrity checks with no differences requiring transfer. `n/a` alone is not a synchronization failure. Fresh endpoint-to-cloud receipt was separately verified using the benign test below.
- Machines are run in small groups for RAM safety. The old three-active-agent screenshot remains historical evidence; this session does not yet establish all three online simultaneously.
- Windows completed its existing boot-update sequence normally before its service capture. No snapshot was restored to skip updates.
- The VirtualBox management process initially returned object-not-ready errors. It was restarted only after confirming no VM processes were running; VM storage/configuration was preserved.
- For the readiness-only check, the stopped scanner was temporarily changed from 6144 MB to 4096 MB due to host RAM pressure. No new scans were run. After normal guest shutdown, its **original 6144 MB allocation was restored**. This is not a performance validation at 4 GB.
- On its second boot the local worker stalled before SSH/login at “Loading essential drivers.” The operator explicitly approved a restart of that VM. It recovered on retry, rejoined the cloud cluster and received agent 002. The underlying intermittent VirtualBox boot issue was not diagnosed; rehearse on the final demonstration machine.

## Benign receipt test and time handling

The endpoint command was an authorized `sudo /usr/bin/logger` invocation tagged `ISSD_CAT2_EVIDENCE`, with the message explicitly identifying a benign pipeline test. Wazuh generated its normal **Successful sudo to ROOT executed** alert (rule 5402). This was not an attack, exploit, or extra vulnerability finding.

An initial test exposed worker clock skew: its event timestamp lagged the Debian log timestamp. NTP was inactive. After enabling standard time synchronization and confirming `System clock synchronized: yes`, a second unique marker ending `DEBIAN_SYNCED` was emitted at **13:39:49 UTC**. The worker alert timestamp is **13:39:53.768 UTC**; the cloud screenshot displays **16:39:53.768** in the browser's UTC+03 timezone. The exact marker is present in the cloud indexed record. This establishes real endpoint -> worker processing -> cloud indexing, with timezone differences explained rather than concealed.

The private worker JSONL retains both the earlier skewed test and the synchronized test for provenance. Original scan findings and the 26 October vulnerability totals were not rewritten to include these administrative test events.

Keep these images/transcripts private. Git contains only this sanitized record and corrected documentation, not passwords, SSH keys or browser sessions.

**End state:** All five local lab VMs were shut down; the scanner's original 6144 MB was verified restored. The cloud instance was left running. Evidence-only SSH tunnels and the separate Greenbone browser were closed. No new vulnerability scan, snapshot restoration or agent re-enrollment was performed. Worker NTP enablement is the deliberate persistent guest configuration change.

**Still required:** Group rehearsal, lecturer confirmation of Wazuh/local-cloud interpretation and Task1's agent wording, current feeds/health on demo day, and password hygiene. Rotate the Wazuh password shared in chat and replace the default Greenbone admin password through a coordinated group change; neither password was silently rotated during this session.
