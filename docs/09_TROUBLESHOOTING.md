# 09. Troubleshooting and common mistakes

**A. VirtualBox not opening, cannot start VM:** Check CPU virtualization in Task Manager > Performance > CPU. Restart after install. Check compatibility with Hyper-V/Windows Hypervisor Platform; do not turn off Windows features and protections without understanding impact. Re-run preflight script.

**B. Vagrant downloads on C: not SSD:** Confirm `echo $env:VAGRANT_HOME` has the SSD path in a NEW PowerShell. This must be set before boxes download. In VirtualBox Preferences > Default Machine Folder, select SSD/ISSD_CAT2/VMs.

**C. Vagrant box `no available version/provider`:** Check Vagrant 2.4+, VirtualBox support; use `vagrant box add bento/ubuntu-24.04 --provider=virtualbox --architecture=amd64` and similar for Debian. If the upstream registry is unavailable, use an appropriately licensed offline `.box` or official ISO and the manual VM setup method. A Vagrant script cannot guarantee third-party infrastructure stays available.

**D. PowerShell script blocked:** Open file to inspect contents. From the project folder run the one-time `powershell -ExecutionPolicy Bypass -File .\scripts\01_prepare_storage.ps1`. Avoid permanent system-wide policy changes.

**E. 192.168.56.* network conflict:** If a VPN or corporate network already uses that subnet, change the subnet consistently in Vagrantfile, Windows IP settings, scripts, and diagrams. All laptops use the same lab plan, but IPs may need adjustments to avoid collisions.

**F. Windows VM not receiving correct IP:** Ensure its second VirtualBox adapter is on the same host-only network as Ubuntu/Debian. Set 192.168.56.13/24 on that specific NIC. Don't assign a default gateway to host-only NIC; keep adapter 1 NAT DHCP.

**G. Windows cannot be pinged:** Windows Firewall may block unsolicited ICMP. Try Windows -> Linux TCP port 80 first. Use a narrowly scoped Windows inbound ICMP rule on your isolated test subnet if necessary; do not disable firewall entirely.

**H. Linux provisioning doesn't install:** Inspect the terminal output and `vagrant ssh ubuntu`, then `sudo apt-get update`. NAT adapter/internet/DNS may be wrong. Don't fabricate provisioning screenshots.

**I. High RAM usage/freezing:** Shut down VM you aren't testing (`vagrant halt debian`), close browsers, do NOT run 8 GB management engine + three guests on a 16 GB host if it causes swapping. Use a stronger group PC or a separate server.

**J. Two agents show identical IDs:** They may have been cloned AFTER enrollment. Restore clean pre-agent baseline and re-enroll with unique identity under Member 5. Never upload agent secrets.

**K. Scanner on Member 2's physical laptop can't reach your 192.168.56.x VMs:** Correct: host-only IPs are not routable between different laptops by default. Either have Member 2 run a local scanner on same physical host/lab copy, use a configured and approved restricted private network routing solution, or run the central demo on an agreed shared machine.

**L. Need software vulnerability findings:** Fresh patched OSs may have few vulnerabilities. Confirm scanner/feed health first; use explicitly approved isolated test apps if necessary. Don't compromise real or university systems.
