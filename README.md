# ISSD CAT 2: Shared Vulnerability Assessment Lab (Group of Six)

**STATUS (27 October 2026 evidence review):** Three endpoints, three completed OpenVAS scans, and three active Wazuh 4.14.9 agents are evidenced locally. Wazuh uses a local worker and Oracle Cloud master over Tailscale; cloud vulnerability records exist. This is historical screenshot/report evidence, not a live health check. See [current status and remaining screenshots](docs/CURRENT_STATUS.md), [topology](docs/NETWORK_TOPOLOGY.md) and [Task 2 findings](docs/Task2_Findings.md). Greenbone feed readiness, stronger synchronization proof and the live demonstration still need confirmation.

**Teammates:** Start with [SETUP.md](SETUP.md) to import prepared Linux OVAs without Vagrant. Clean builds below create endpoints **without Wazuh**. GitHub stores instructions, not the running lab or private evidence.

## What you will build
- VirtualBox **VM 1**: Ubuntu Server 24.04 LTS, `ISSD-CAT2-ubuntu`, IP `192.168.56.11`, 2 GB RAM, port 80 Nginx.
- VirtualBox **VM 2**: Debian 12 Bookworm, `ISSD-CAT2-debian`, IP `192.168.56.12`, 1.5 GB RAM, port 80 Apache.
- VirtualBox **VM 3**: Microsoft Windows 11 Enterprise Evaluation, `ISSD-CAT2-windows`, IP `192.168.56.13`, 4 GB RAM, 64 GB dynamic virtual disk. Installed manually because it is not lawful or straightforward to make a universal redistributed Windows evaluation Vagrant base box.
- Network: VirtualBox host-only `192.168.56.0/24`, plus NAT interfaces for normal updates and approved manager connections. The host-only network is NOT a shared internet network.

The original lecturer brief suggests Windows, Linux, Metasploitable/OWASP BWA but uses **may**: examples, not strict types. Keeping Windows makes a better balanced demonstration. Metasploitable can be added separately by the network-scanning members if needed, in an isolated network and without modern-agent assumptions.

## Start here, in order
1. Read `docs/01_OVERVIEW_AND_MARKING.md`.
2. Read `docs/02_WINDOWS_HOST_SSD_AND_PREREQUISITES.md`, install VirtualBox and Vagrant, then run `scripts/01_prepare_storage.ps1` (choose actual SSD letter).
3. Move the project to `X:\ISSD_CAT2\LabRepo\ISSD_CAT2_Collaborative_Lab_v2` (X = SATA SSD letter).
4. In PowerShell, inside project folder: `vagrant validate` then `vagrant up ubuntu --provider=virtualbox`, then `vagrant up debian --provider=virtualbox`. Start *one at a time*.
5. Read `docs/03_LINUX_VAGRANT_STEP_BY_STEP.md` and save verified Linux evidence.
6. Read `docs/04_WINDOWS11_STEP_BY_STEP.md`, download Microsoft ISO and create Windows VM. It does not need a Vagrant box.
7. Existing endpoints already have Wazuh agents. Read `docs/M4-11_Handover_to_M5.md` and `docs/CURRENT_STATUS.md`; do not reinstall or clone enrolled identities. Lecturer acceptance of Wazuh and the local/cloud interpretation still needs confirmation.
8. Read `docs/06_GITHUB_AND_GROUP_HANDOVER.md`; repository: `https://github.com/Eeshan-Vaghjiani/ISSD-cat2` (default branch `master`). Treat it as public unless its visibility is confirmed otherwise. GitHub stores **instructions**, not running VMs or license-restricted images.
9. Test the demo using `docs/07_DEMO_AND_EXPLANATIONS.md`, `docs/08_GROUP_CHECKLIST.csv`, and `docs/09_TROUBLESHOOTING.md`.

## Download links
- VirtualBox: https://www.virtualbox.org/wiki/Downloads
- Vagrant: https://developer.hashicorp.com/vagrant/install
- Microsoft Windows 11 Enterprise eval, 90-day trial: https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
- Direct Debian 12.15 amd64 netinstall ISO (optional manual backup): https://cloudfront.debian.net/cdimage/archive/latest-oldstable/amd64/iso-cd/debian-12.15.0-amd64-netinst.iso
- Debian ISO SHA256SUMS: https://cloudfront.debian.net/cdimage/archive/latest-oldstable/amd64/iso-cd/SHA256SUMS
- Ubuntu Vagrant box is downloaded by `vagrant up`: bento/ubuntu-24.04
- Debian Vagrant box is downloaded by `vagrant up`: bento/debian-12

## Crucial boundaries
- Task 1 and Task 2 are separate demonstrations, despite using common endpoints.
- Agent **installed/service running** is Member 4 proof; agent **enrolled/checking in** is Member 5 proof; vulnerability **finding** is Member 6 proof.
- The original brief explicitly requires a **local correlation engine synchronized with a cloud instance** for Task 2. Do not claim that just installing Wazuh or just hosting a manager in the cloud meets both conditions. Decide architecture with Member 5 and obtain lecturer confirmation for alternative to Nessus or InsightVM.
- With 16 GB physical RAM, these 3 endpoints use about 7.5 GB configured guest RAM. Heavy local Wazuh/Greenbone managers are likely too much simultaneously. Run those on another group machine or an appropriately secured cloud resource if agreed.
- No port forwarding from intentionally vulnerable services onto the public internet. Avoid exposing sensitive scans/agent registration secrets in repo.
- HashiCorp announced retirement of Vagrant Cloud end of 2026; keep appropriately licensed offline copies of the Linux boxes while available, or rebuild from official ISOs if service is gone.
- Do NOT reset enrolled agents from a shared post-enrollment image: unique identity per VM is critical.
- Verify the due date. Lecturer original brief says Tuesday 25 Nov 2025, group allocation says Wednesday 25 Nov 2026.
