# 01. What the lecturer wants and how the group divides the practical

Source A: `BICS ISSD CAT 2 2025.docx`, 3 pages. Original lecturer brief.
Source B: `ISSD_CAT2_6_Member_Task_Allocation.pdf`, 2 pages. Group division.

## Original CAT2 brief
- **Task 1 (17 marks)**: Network-based distributed vulnerability assessment. Example tools: Metasploit, OpenVAS, W3AF or alternative. Hypervisor/VMM/container (1), three or more endpoints (6), local/cloud correlation engine as necessary (setup 2, scan 6, reports 2), wording additionally mentions endpoint-specific agents. That wording is ambiguous in a network-based task: ask lecturer to clarify.
- **Task 2 (17 marks)**: Agent-based distributed vulnerability assessment, using Tenable's Nessus, Nexpose/InsightVM or another agent-based VA platform, requiring hypervisor/VMM/container, >=3 endpoints, **local engine synced with cloud**, and agent-based distributed collection.
- Explain what you observe in lecturer demo; original paper does **not explicitly demand a separate written report**.

## Member responsibilities
| Member | Responsibility | Evidence |
|---|---|---|
| 1 | Virtual network and >=3 endpoints; topology, IPs, reachability | VM screen captures, topology and ping/TCP checks |
| 2 | Network scanner & correlation engine | Dashboard, targets, configured scan |
| 3 | Run network scans and explain findings | Results by endpoint, CVE/severity, reports |
| **4 YOU** | >=3 agent-compatible endpoints + endpoint agents | 3 service captures, inventory and topology |
| 5 | Agent platform, local/cloud sync, register/link agents | Dashboard, real sync proof, agent check-ins |
| 6 | Agent findings, comparisons, final demo | Findings, explanations, presenter checklist |

## What YOU should be able to demonstrate live
1. Show VirtualBox and each VM powered on.
2. Show Linux `/etc/os-release`/`hostname`, Windows `winver`, and their assigned private IPs.
3. Prove isolated connectivity, show endpoint services, and explain NAT vs host-only.
4. Show installed vulnerability agent's version and **RUNNING** service on all three systems. Do this only when you actually have it installed.
5. Hand Member 5 the private IPs, real hostnames and agent names; Member 5 registers them.
6. Member 1 can reproduce Linux VMs with Vagrant; Windows is documented to recreate rather than requiring your laptop online.

## Blocking decision
The lecturer permits an 'other agent-based VA tool' but also requires local/cloud engine sync. **Wazuh is a candidate**, not confirmed equivalent. Ask Member 5 and lecturer before installing. In particular Wazuh manager/indexer architecture and a real sync path need demonstration; multiple dashboards alone are not synchronization.
