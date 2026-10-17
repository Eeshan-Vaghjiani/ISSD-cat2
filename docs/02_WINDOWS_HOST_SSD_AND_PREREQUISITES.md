# 02. SSD, VirtualBox and Vagrant setup on Windows

Assumes 64-bit Intel/AMD Windows laptop with 16 GB physical RAM and an additional SATA SSD with >200 GB free. The SSD's drive letter may differ between machines.

### A. Confirm hardware
1. Windows Task Manager > Performance > CPU > **Virtualization: Enabled**. If disabled, enable VT-x/AMD-V in BIOS/UEFI before proceeding.
2. Task Manager > Performance > Memory: confirm total physical RAM and existing utilization.
3. File Explorer > This PC: record the extra SATA SSD drive letter (e.g. E: or F:) and free space.
4. Prefer using SATA connected internally or reliable fast enclosure; avoid moving the external disk while VMs are running.

### B. Install virtualization tools
1. Download and install VirtualBox 7.x for Windows from https://www.virtualbox.org/wiki/Downloads. Include networking components, including host-only adapters. Reboot if installer asks.
2. Download and install the latest Vagrant 2.4.x from https://developer.hashicorp.com/vagrant/install. Close and reopen PowerShell.
3. Open VirtualBox once. If you see a Microsoft Hyper-V compatibility warning, do not disable Windows protections blindly. Try the VM first and use the troubleshooting guide if you have an actual error.
4. Open PowerShell and run `vagrant --version`; for VBox version, use `& "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" --version`.

### C. Put ALL virtual-machine data on SATA SSD
1. Extract repository ZIP initially to a temporary folder.
2. From PowerShell in folder containing `scripts`, run `powershell -ExecutionPolicy Bypass -File .\scripts\01_prepare_storage.ps1` and enter your actual drive letter. Inspect the script beforehand if PowerShell warns about execution policy; do not permanently weaken your security policy.
3. It creates `X:\ISSD_CAT2\VMs`, `VagrantHome`, `Downloads`, `Evidence`, `SharedExports`, `LabRepo` and sets VirtualBox's default machine folder (if VBoxManage found).
4. Reopen PowerShell. Check `echo $env:VAGRANT_HOME` equals `X:\ISSD_CAT2\VagrantHome`.
5. Move the extracted folder into `X:\ISSD_CAT2\LabRepo\`. Open PowerShell *inside it*, where you see `Vagrantfile`.
6. Optionally run `.\scripts\02_preflight.ps1` to see requirements and free space.

**Storage note:** The 64 GB Windows virtual disk is configured to grow as data is written. It does NOT immediately consume 64 GB, but updates and snapshots increase real SSD usage. Reserve ~80-120 GB free for images, logs, snapshots and exports if possible.

**Important:** Vagrant's downloaded box cache ordinarily lives on C: unless `VAGRANT_HOME` is set BEFORE download. Always verify the environment variable after opening a new PowerShell window.
