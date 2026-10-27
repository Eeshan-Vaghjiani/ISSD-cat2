# Task 1 - Findings, interpretations and demonstration notes

**Source:** unmodified Greenbone/OpenVAS PDF exports in `Member3/`, all dated 24 October 2026 (report timestamps UTC). The three scans were performed one after another against the isolated VirtualBox lab. The generated per-host overview images are explicitly marked as **extracts from page 2 of the original reports**, not new dashboard screenshots.

## Architecture

Oracle VirtualBox runs an Ubuntu Server OpenVAS/Greenbone scanner (`192.168.56.20`) plus three target VMs: Ubuntu 24.04 (`192.168.56.11`), Debian 12 (`192.168.56.12`) and Windows 11 Enterprise Evaluation (`192.168.56.13`). Targets and scanner share the **192.168.56.0/24 host-only network**. A separate NAT adapter supports updates; the Windows laptop browser uses an SSH tunnel to the scanner web dashboard on `https://localhost:8443`. The scanner performs network-based, agentless assessments. Greenbone's `gvmd` manages/correlates the scans and reports; OpenVAS does remote testing.

## Verified PDF findings

| Host / task | Critical | High | Medium | Low | Main observation |
| --- | ---: | ---: | ---: | ---: | --- |
| Ubuntu `.11` (`ISSD-Scan-Ubuntu`) | 1 | 0 | 0 | 2 | SSH accepted default lab account credentials; CVSS 9.8 |
| Debian `.12` (`ISSD-Scan-Debian`) | 1 | 0 | 0 | 2 | SSH accepted default lab account credentials; CVSS 9.8 |
| Windows `.13` (`ISSD-Scan-Windows`) | 0 | 0 | 0 | 1 | TCP timestamps information disclosure; CVSS 2.6 |
| **Total** | **2** | **0** | **0** | **5** | **7 findings in PDFs** |

The Linux reports also include TCP timestamps (Low, CVSS 2.6) and ICMP timestamp replies (Low, CVSS 2.1). Critical SSH finding: **"SSH Brute Force Logins With Default Credentials Reporting"**, OID `1.3.6.1.4.1.25623.1.0.103239`. The scanner verified that a **known default username/password combination** worked on the test VMs. Demonstrate only the authorized lab account; avoid disclosing working passwords in public repositories.

**Interpretation:** A known default SSH password risks unauthorized access where SSH is reachable. Mitigate with a unique strong password or disable password authentication where safe, configure per-VM SSH keys, and limit SSH access to trusted management addresses. In these Vagrant-managed guests, plan credential changes carefully so provisioning/SSH access remains functional. The listed vendor-specific CVEs in the generic NVT references are *not automatically verified vulnerabilities* of Ubuntu/Debian. Network timestamp issues leak limited network timing/uptime information; mitigate according to use case (block unnecessary ICMP timestamp requests, restrict exposure, or review TCP timestamp settings while balancing functionality).

**Windows interpretation:** The PDF contains one Low TCP timestamp disclosure result. This does *not* demonstrate the Windows OS is free of vulnerabilities. An unauthenticated network scan with a restrictive host firewall may have limited visibility, and no High/Critical results were reported under the selected filters.

## Important report filter / count clarification

The PDFs report **QoD >= 70**, omit `Log`, `Debug` and `False Positive` findings, and contain **3 of 19 Ubuntu**, **3 of 17 Debian**, and **1 of 3 Windows** original results. Some earlier dashboard severity screenshots displayed **mixed-host aggregate Results**, so they were moved unchanged to `Reference_Archive/Old_or_Aggregate_Screenshots/`. Do not use them as per-host totals. The corrected `M3-*Severity_From_Original_PDF.png` images show each original PDF's own per-host counts and filtration statement.

## Suggested lecturer demo script (roughly 2 minutes)

"Our Task 1 uses OpenVAS through Greenbone Community Edition, an approved network-based VA tool. We configured an isolated VirtualBox host-only network with an OpenVAS scanner at .20 and three endpoints at .11, .12 and .13. We verified scanner-to-endpoint connectivity, created three scan targets and configured Full and fast scan tasks. We completed each scan separately and exported its report. The Ubuntu and Debian reports show one critical issue each: SSH accepted default lab credentials, allowing a remote account login. They also have two low-severity timestamp findings each. Windows shows one low TCP timestamp disclosure finding. These are observed results within the report's minimum 70 percent Quality of Detection filter. Our main recommendation is to replace default SSH passwords and restrict access, then rescan after fixing them. We also recognise that agentless network scans cannot prove that an endpoint has no other vulnerabilities, especially when a firewall limits exposure." 

## Capture checklist updated 27 October (not a live health check)

1. **Member 1 - now present:** `Member1/M1-11_Ubuntu_OS_and_IP_LIVE.png` shows Ubuntu hostname, OS and `.11`. Windows hostname and three scanner-origin connectivity captures also exist. Do not retake them unnecessarily.
2. **Member 1 (optional):** VirtualBox screenshot with all four relevant VM entries including `ISSD-CAT2-scanner`, not just three endpoints.
3. **Member 2 - now present:** `Member2/M2-10_Final_Scanner_Storage.png` shows the 140G root filesystem.
4. **Member 2 - now present:** `Member2/M2-11_Greenbone_Containers_Healthy.png` shows Compose services Up/healthy where checks exist.
5. **Member 2 - now present:** Live `M2-13`/`M2-14` show loaded feed versions and a dashboard without the sync warning; `M2-15` shows three Done tasks; all three `M2-16` captures confirm `OpenVAS Default / Full and fast`; `M2-17` shows services and loaded VT cache. `M2-12` is historical. Feeds were 4-7 days old, not today's latest.
6. **Assignment ambiguity:** Task 1 says 'End-point Specific agents distributed vulnerability collection' while offering OpenVAS as a network-based agentless tool. Ask the lecturer whether this is separately required under Task 1, or belongs to Task 2. Do not claim Wazuh endpoint agent collection has been demonstrated under Task 1.

## Demonstration sequence

Show the topology -> VirtualBox 3 VMs and scanner IPs -> three network tests -> Greenbone ready feeds, targets and tasks -> three completed scan reports -> explain Critical SSH default credentials + lower-severity timestamp findings -> discuss filters and limits -> take questions.

**Privacy:** `Member3/` reports include sensitive details of lab credentials and services. Keep the ZIP private and out of your public GitHub repository. Do not publish its original PDFs or images with working credentials.
