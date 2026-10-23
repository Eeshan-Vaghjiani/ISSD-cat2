# ISSD CAT 2 — Group Handover and Setup Guide

**Updated:** 23 October 2026  
**Repository:** https://github.com/Eeshan-Vaghjiani/ISSD-cat2  
**Default branch:** `master`  
**Project:** Distributed Vulnerability Assessment — network-based and agent-based tasks  
**Status:** The three operating systems and their network baseline have been prepared on the original lab laptop. Wazuh 4.14.9 agents are installed on all three. The central Wazuh management system, local/cloud integration, registration and vulnerability results are **not yet complete**.

> **Recommended teammate setup:** Use the **Ubuntu and Debian `.ova` appliances from the group's Google Drive** for the simplest setup; **Vagrant from GitHub** is the clean-build alternative. Windows 11 is installed separately from Microsoft's official evaluation ISO. Do not download the Windows OVA for distribution unless its evaluation licence permits it. No one needs the original VM snapshots for routine work.

## 1. Who needs what?

| Member | Assignment | What they can use now | Remaining work |
|---|---|---|---|
| 1 | Network setup, at least three endpoints, topology and reachability | GitHub instructions and Vagrant configuration; Linux OVA imports; shared endpoint inventory | Independently validate the chosen assessment network and ensure three accessible targets |
| 2 | Network-scanning engine | GitHub documentation; accessible endpoint network | Deploy and configure the authorized scanner and correlation approach |
| 3 | Network scans and findings | Member 2's scanning engine | Collect authentic scan results and explain findings |
| **4** | **Agent-ready endpoints and Wazuh agent installations** | Three existing VMs, pre-agent and post-install snapshots, screenshots and inventory | Verify services as running with the actual manager; complete final agent evidence |
| 5 | Wazuh manager, agent enrollment, local/cloud integration | Wazuh agent handover, Linux OVAs if a local test environment is needed | Provide a manager reachable by all three endpoints, enroll agents and prove required local/cloud synchronization |
| 6 | Agent-based vulnerability findings and comparison | Member 5's working Wazuh system | Show findings for the three endpoints and the final demonstration |

**Critical assignment requirement:** Task 2 calls for a **local correlation engine synchronized with a cloud instance**. A cloud-only dashboard or merely installing agents is *not* proof of synchronization. Member 5 should confirm the architecture and lecturer acceptance of Wazuh as an alternative agent-based VA platform.

## 2. What Member 4 has completed

### Prepared endpoints

| VirtualBox machine | Operating system | Intended host-only IP | Wazuh agent | Local agent state at handover |
|---|---|---|---|---|
| `ISSD-CAT2-ubuntu` | Ubuntu 24.04.3 LTS | `192.168.56.11` | `4.14.9-1` | Installed, enabled; initial start failed because manager address is still `MANAGER_IP` |
| `ISSD-CAT2-debian` | Debian GNU/Linux 12 | `192.168.56.12` | `4.14.9-1` | Installed and enabled; running service not yet confirmed |
| `ISSD-CAT2-windows` | Windows 11 Enterprise Evaluation | `192.168.56.13` | `4.14.9` | Installed; `wazuhsvc` was stopped at the last check |

**Windows hostname:** Obtain the actual value by running `hostname` *inside* the Windows VM. Do not assume the VirtualBox machine name is the Windows hostname. The tracked inventory currently needs this field corrected/completed.

### Other completed work

- Oracle VirtualBox lab with NAT plus host-only adapters.
- Linux virtual machines created through the repository's Vagrant configuration.
- Ubuntu Nginx and Debian Apache test services; historical network connectivity checks successful.
- Windows connectivity to Linux web services previously verified.
- Ubuntu and Debian snapshots: `clean-network-baseline` and `wazuh-installed-before-manager`.
- Windows snapshots: `baseline-before-agent` and `wazuh-installed-before-manager`.
- Agent version, installation and status screenshots captured.
- Twelve Member 4 evidence files uploaded successfully to Google Drive under `ISSD-CAT2-Group/Member-Evidence/Member4` on 23 October 2026 (confirmed by rclone listing).
- Ubuntu and Debian portable `.ova` exports have been prepared and, per the latest group update, uploaded to the Google Drive `Deploy` folder. Validate them on a **different laptop** before treating them as fully tested deployment images.
- Windows `.ova` export created as an optional **private backup**; sharing it is subject to Microsoft's evaluation licence.

**What is not done:** Wazuh manager address, three running agents, three check-ins, CVE findings and the lecturer's local/cloud synchronization proof.

## 3. What GitHub currently contains

At the time of review, the `master` branch contained:

```text
ISSD-cat2/
├── .gitignore
├── README.md
├── Vagrantfile
├── docs/
│   ├── 01_OVERVIEW_AND_MARKING.md
│   ├── 02_WINDOWS_HOST_SSD_AND_PREREQUISITES.md
│   ├── 03_LINUX_VAGRANT_STEP_BY_STEP.md
│   ├── 04_WINDOWS11_STEP_BY_STEP.md
│   ├── 05_MEMBER4_AGENTS_AND_EVIDENCE.md
│   ├── 06_GITHUB_AND_GROUP_HANDOVER.md
│   ├── 07_DEMO_AND_EXPLANATIONS.md
│   ├── 08_GROUP_CHECKLIST.csv
│   ├── 09_TROUBLESHOOTING.md
│   ├── ENDPOINT_INVENTORY.csv
│   ├── M4-09_Topology.png
│   ├── M4-11_Handover_to_M5.md
│   └── NETWORK_TOPOLOGY.md
├── evidence/
│   └── README.md
└── scripts/
    ├── 01_prepare_storage.ps1
    ├── 02_preflight.ps1
    ├── 03_check_linux.ps1
    ├── 04_check_windows.ps1
    ├── 05_evidence_linux_commands.txt
    └── bootstrap-linux.sh
```

GitHub's `Vagrantfile` defines only the **Ubuntu and Debian** Linux VMs. Its shell provisioner installs Nginx/Apache and standard utilities, **not Wazuh**. Thus `vagrant up` does **not** recreate Member 4's installed Wazuh agents. Use the OVAs if that pre-installed state is important.

**Documentation to refresh:** At the time of review, `README.md` still incorrectly said no agents were installed, `docs/06_GITHUB_AND_GROUP_HANDOVER.md` contained example repository/branch instructions, and the group checklist still marked progress as `NOT STARTED`. This guide records the current verified state; update those older documents before asking others to follow them.

**Visibility:** GitHub reported this repository as **public** during the review. Check that this matches the group's intention and do not push passwords, tokens, private keys, or unredacted evidence.

## 4. Fastest setup for Members 1 and 5: Google Drive OVAs (recommended)

**Requirements:** 64-bit Windows laptop with hardware virtualization enabled, Oracle VirtualBox installed, sufficient free SSD space and access to the group's Drive `Deploy` folder.

1. Install **Oracle VirtualBox** from https://www.virtualbox.org/wiki/Downloads. **Vagrant is not required for this method.**
2. Download `ISSD-CAT2-ubuntu.ova` and `ISSD-CAT2-debian.ova` from `ISSD-CAT2-Group/Deploy` in the group Drive. **Insert the actual shared folder URL here once approved:** `[Google Drive Deploy link]`.
3. In VirtualBox Manager, use **Home → Import** (or **File → Import Appliance**, depending on version), and select each `.ova` file.
4. Select an SSD-backed **Base Folder** with enough storage. Review the VM name; if a machine with that name exists, **rename the imported VM** rather than overwriting an existing one. Keep generated/unique network adapter MAC addresses.
5. Before first boot, inspect each imported VM's **Network** settings: Adapter 1 should support outbound updates (NAT); Adapter 2 should attach to the desired **host-only** VirtualBox network. Create/select a host-only network in the intended `192.168.56.0/24` range where appropriate. **Do not assume the imported adapter name or static IP will be correct on another laptop.**
6. Start the VMs and verify from their console or an authorized SSH session:

   ```bash
   hostname
   cat /etc/os-release | head -6
   ip -br -4 addr
   dpkg-query -W wazuh-agent
   ```

7. Confirm the expected host-only IPs (`.11` Ubuntu, `.12` Debian) **on that laptop**. If missing, adjust the guest network configuration for the new adapter. Do not change the original operator's VMs.
8. **Access check:** The exported Bento/Vagrant guests may rely on SSH key-based access originally configured by Vagrant. Before distribution, the owner must test that a new member can log in (console or SSH) using an authorized, individually provided method. **Do not publish SSH private keys or reusable passwords in GitHub or Drive.**
9. The Wazuh agents are installed but not manager-enrolled. When Member 5's real manager address and enrollment method are available, configure each VM independently. Never reuse a registered agent identity across cloned machines.
10. If Member 1 needs a **third endpoint**, install Windows from the official evaluation ISO (Section 6), or coordinate use of the existing Windows demonstration VM. Two Linux OVAs alone do **not** satisfy the three-endpoint requirement.

**Network warning:** `192.168.56.x` host-only networks on *different laptops* are separate networks. Importing the same IP configuration does **not** make VMs on different computers talk to one another. Member 5 needs secure, reachable manager connectivity (such as an approved VPN or reachable server), not just identical local addresses.

## 5. Alternative: GitHub + Vagrant clean Linux build

Use this when the Drive files are unavailable, or a member prefers to recreate Linux machines from configuration.

1. Install Git, VirtualBox and Vagrant from their official sources.
2. Choose a folder on an SSD; clone the repository:

   ```cmd
   git clone https://github.com/Eeshan-Vaghjiani/ISSD-cat2.git
   cd ISSD-cat2
   ```

3. Configure the VirtualBox machine folder and `VAGRANT_HOME` on the teammate's own computer as described in `docs/02_WINDOWS_HOST_SSD_AND_PREREQUISITES.md`. There is **no need** to copy the original operator's `E:\ISSD_CAT2\VMs` or `.vagrant` folders.
4. From the cloned folder containing `Vagrantfile`:

   ```cmd
   vagrant validate
   vagrant up ubuntu --provider=virtualbox
   vagrant up debian --provider=virtualbox
   vagrant status
   ```

5. Follow `docs/03_LINUX_VAGRANT_STEP_BY_STEP.md` to verify networking. This creates two *new* Linux systems, **without Wazuh agents**. If agents are needed, use the official Wazuh 4.14.9 installation procedure and coordinate manager details with Member 5.
6. To shut down the new Linux guests safely:

   ```cmd
   vagrant halt ubuntu debian
   ```

Do **not** run `vagrant init` in the existing repository. Do not use `vagrant destroy` on the operator's original project.

## 6. Windows 11: smaller ISO, additional installation

The Windows Enterprise Evaluation ISO may be much smaller than the approximately 30 GB `.ova` backup. **Smaller download does not mean an already installed VM**: users must still create a Windows VirtualBox guest, install Windows, configure its second network adapter, apply the intended static host-only IP and install Wazuh if needed.

- Official download: https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
- Existing repository instructions: `docs/04_WINDOWS11_STEP_BY_STEP.md`.
- Suggested Windows lab IP: `192.168.56.13/24` on the host-only interface; gateway and DNS blank for that interface.
- Existing operator's Wazuh installation: Agent 4.14.9, not yet enrolled.
- Check Microsoft evaluation/redistribution terms before distributing a preinstalled Windows OVA. Keep any Windows OVA private until approved.

## 7. Google Drive and evidence

Suggested locations:

```text
ISSD-CAT2-Group/
├── Deploy/
│   ├── ISSD-CAT2-ubuntu.ova
│   └── ISSD-CAT2-debian.ova
├── Member-Evidence/
│   └── Member4/
│       ├── M4-01_VirtualBox_3VMs.png
│       ├── M4-02_Ubuntu_OS_IP.png
│       ├── M4-03_Debian_OS_IP.png
│       ├── M4-04_Windows_OS_IP.png
│       ├── M4-05_Ubuntu_Agent_Installed.png
│       ├── M4-06_Debian_Agent_Installed.png
│       ├── M4-07_Windows_Agent_Installed_Version.png
│       ├── M4-07B_Windows_Agent_Service_Status.png
│       ├── M4-08_Linux_Connectivity.png
│       ├── M4-09_Topology.png
│       ├── M4-10_Endpoint_Inventory.csv
│       └── M4-11_Handover_to_M5.md
├── Snapshot-Backups/
└── Final-Demonstration/
```

**Share `Deploy` with named group members as Viewer** so they can download without accidentally deleting or replacing appliances. Editors should be limited to collaboration folders requiring edits. Avoid setting a folder full of sensitive images or credentials to unrestricted public access.

**OVAs are portable current-state images, not snapshot backups.** Maintain the original snapshot history separately on the operator's SSD. Do not run VMs directly from an actively syncing Google Drive folder.

## 8. GitHub publishing and collaboration

On the **original laptop**, the project root is `E:\ISSD_CAT2`; the existing Git remote was named `ISSD-cat2`, with branch `master`.

Before pushing, check changes:

```cmd
cd /d E:\ISSD_CAT2
git status --short
git remote -v
git branch --show-current
```

To include **this guide**, place it at `docs\ISSD_CAT2_GROUP_HANDOVER.md`, then:

```cmd
git add docs\ISSD_CAT2_GROUP_HANDOVER.md
git diff --cached --stat
git commit -m "Document CAT2 lab progress and group setup options"
git pull --rebase ISSD-cat2 master
git push ISSD-cat2 master
```

Do not force-push. Resolve any merge conflict instead. `*.ova`, `*.iso`, `VMs/`, `VagrantHome/`, `.vagrant/`, `SharedExports/` and `Evidence/*` are intentionally excluded by the existing `.gitignore`. Keep these excluded.

**Before sharing:** Ensure the GitHub branch contains the latest guide, update the old README/checklist to match real progress, and verify that collaborators have access to Google Drive's `Deploy` folder.

## 9. Final responsibilities and demonstration checklist

- [x] Original operator: three OSs installed and previously tested.
- [x] Original operator: Wazuh Agent 4.14.9 installed on Ubuntu, Debian and Windows.
- [x] Original operator: baseline and pre-manager snapshots saved.
- [x] Original operator: 12 evidence files backed up to Google Drive.
- [x] Original operator: two Linux OVA exports prepared (reported uploaded to Drive).
- [ ] Member 1: successfully import/test or rebuild endpoints on the chosen demo machine; confirm three reachable targets.
- [ ] Member 5: deploy approved Wazuh 4.14.9 manager and required local/cloud synchronization architecture.
- [ ] Member 4 with Member 5: replace placeholder manager address, verify all three agent services **running** and **checking in**.
- [ ] Member 3: collect real network-based vulnerability scan evidence.
- [ ] Member 6: collect agent-based vulnerability findings and compare with network-based results.
- [ ] Group: rehearse live demonstration and confirm lecturer's platform acceptance and actual deadline.

**Bottom line:** The Google Drive Ubuntu and Debian OVAs are the easiest starting point for classmates who do not already have Vagrant. GitHub remains the source of truth for configuration and documentation. Windows comes from the official ISO unless appliance redistribution is permitted. The group still needs a real reachable manager and synchronization proof to finish Task 2.
