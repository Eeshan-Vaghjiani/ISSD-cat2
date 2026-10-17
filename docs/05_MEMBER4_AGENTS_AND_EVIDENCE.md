# 05. Member 4: agent installations and evidence

Your allocation requires: 3 agent-compatible systems; endpoint agent installed on all 3; service verified on all 3; hostname/IP/OS inventory; handover to Member 5 for enrollment. This does not mean you must run the engine or generate vulnerability reports by yourself. Member 5 handles engine/registration and Member 6 findings.

## Before agents: obtain one architecture decision
1. Ask Member 5 to select a platform from Nessus Agents, Rapid7 InsightVM Agents or an approved alternative.
2. Confirm actual access/licenses to engine and agents (free Nessus scanner is not the same as Tenable agent manager).
3. Confirm lecturer accepts the chosen tool and exactly how the required **local correlation engine synced with a cloud instance** will be demonstrated.
4. Record manager URL/IP, network route/access plan, agent version and registration method in shared documentation. Keep secrets OUT of GitHub.
5. Snapshot every VM **before** agent installation. Registered images should not be cloned as separate agents.

## Free candidate: Wazuh (ONLY after lecturer/platform agreement)
Wazuh agents support Windows and Linux, and its vulnerability detection can use operating system/software inventory. This is not automatically a substitute for a Nessus/InsightVM local/cloud setup. Confirm manager/indexer topology separately.

### Ubuntu/Debian install, current Wazuh 4.x pathway
Use the *official current guide*: https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html
Inside each Linux guest:
1. `sudo apt-get update`
2. `sudo apt-get install -y gnupg apt-transport-https curl`
3. Follow the exact official guide's GPG key import and APT repository commands (do not copy an unverified curl install script).
4. Once Member 5 gives manager address, install with the guide's proper `WAZUH_MANAGER`/registration flags for the selected version, or install a package without registering and enroll later.
5. `sudo systemctl daemon-reload`
6. `sudo systemctl enable --now wazuh-agent`
7. `sudo systemctl status wazuh-agent --no-pager`
8. `dpkg -l | grep wazuh-agent`
The service can run even when it is not registered, so Member 5 must separately show check-in on the dashboard.

### Windows install
Use: https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-windows.html
1. Download official `wazuh-agent-*.msi` INSIDE Windows evaluation VM.
2. Run the official MSI GUI installer as Windows administrator. Configure manager address after Member 5 approves it, or use the supported no-enrollment installation path.
3. Start using Windows Services application if stopped, or elevated PowerShell `Start-Service WazuhSvc`.
4. Verify `Get-Service WazuhSvc` reports `Running` and `Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'` if needed to confirm installed version (or check Programs and Features).
5. Screenshot the service and package information. Manager check-in is separate Member 5 proof.
**Version caveat**: agent installation/enrollment flags can change in future major releases. Follow the documented version of the management server.

## Required Member 4 evidence files (real captures only)
- M4-01_VirtualBox_3VMs.png
- M4-02_Ubuntu_OS_IP.png
- M4-03_Debian_OS_IP.png
- M4-04_Windows_OS_IP.png
- M4-05_Ubuntu_Agent_Running.png
- M4-06_Debian_Agent_Running.png
- M4-07_Windows_Agent_Running.png
- M4-08_Connectivity.png
- M4-09_Topology.png
- M4-10_Endpoint_Inventory.csv
- M4-11_Handover_to_M5.md

## Done vs not done
- 3 VMs boot + reachable = **infrastructure done**, but NOT full Member 4.
- 3 agents installed with running services + evidence = **Member 4 install criterion done**.
- 3 agents visible in central management + successful check-in = **Member 5**.
- Vulnerability assessments/results = **Member 6**.

## Endpoint inventory
Update `docs/ENDPOINT_INVENTORY.csv` with *actual* values, not assumptions. Save a final copy in group evidence folder. Include hostname, OS, version, private IP, MAC optional, agent name/version, install status, running status, screenshot location and responsible person.
