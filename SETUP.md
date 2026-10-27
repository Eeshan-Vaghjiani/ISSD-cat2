# ISSD CAT 2 — One-launch team setup (without Vagrant)

This setup package is designed for **Members 1 and 5** and other authorised group participants who need **their own copies of the prepared virtual machines**. They need Windows 10/11 (64-bit), hardware virtualization enabled, a suitable SSD with plenty of free space, enough RAM, an Internet connection, and permission to install VirtualBox. They do **not** need Vagrant, nor to install Ubuntu/Debian themselves.

> **Status:** The scripts are prepared but have **not yet been tested with your group's actual Google Drive folder or OVA exports**. The owner must test on a spare Windows machine before the group relies on them.

> **27 October update:** The original lab now has enrolled agents. Drive OVAs may predate enrollment, but their export state was not rechecked. Do not export/distribute current enrolled machines as reusable clones without a deliberate identity-reset/re-enrollment procedure. See `docs/CURRENT_STATUS.md`. This launcher does not perform that reset.

## What they run

1. Download/clone the GitHub project, which includes `setup.bat`, `setup.ps1` and this `SETUP.md`.
2. Double-click **`setup.bat`**. This is the only launcher; it invokes the accompanying `setup.ps1`.
3. Choose a storage location on a large SSD.
4. If VirtualBox is not installed, the script offers to install it through Microsoft's `winget` (administrator approval may be required).
5. Choose **Google Drive automated download** or **local downloaded .ova files**.
6. For Google Drive mode, `rclone` is installed through `winget` if needed. First-time users must authorize Google Drive in the browser through `rclone config`; do not put access tokens into the GitHub project. Paste the URL of the shared **Deploy** folder when prompted. The script downloads files and can resume transfers when rerun.
7. It checks SHA-256 hashes when `SHA256SUMS.txt` is present (missing/invalid entries or mismatches stop import), imports absent VMs to VirtualBox, and attempts to attach an existing `192.168.56.1/24` host-only adapter. It does **not** overwrite registered VMs. Newly imported secondary adapters are disabled before attaching Adapter 2, so an inherited bridged adapter is not left enabled.
8. Confirm NAT/host-only settings in VirtualBox. If a host-only adapter was not found, use VirtualBox **Tools → Network → Host-only Networks** to create one at **192.168.56.1/24**, and then choose it for **Adapter 2** of every VM.
9. Start only the VMs needed for the particular member's role. Verify the private IPs inside the guests.

The Google Drive OAuth flow is an unavoidable user action, and UAC approvals/reboots may be required by Windows. Therefore one launcher does not mean a fully unattended installation.

## What the owner must upload to Google Drive first

**Prepare two separate Google Drive folders:**

```text
ISSD-CAT2-GROUP/
  Deploy/                  <- Share with known group members as Viewer
    ISSD-CAT2-ubuntu.ova
    ISSD-CAT2-debian.ova
    SHA256SUMS.txt
    # ISSD-CAT2-windows.ova  <- ONLY if evaluation licensing permits sharing
  Evidence/                <- Controlled-access screenshots/reports
  SnapshotArchive/         <- Optional private backup of full powered-off VM folders
```

Enter the actual **Deploy** folder link when `setup.ps1` prompts for it; no edit to `setup.bat` is needed. Member 1 or Member 5 should have access through their own Google account. Prefer **Restricted → named members → Viewer** rather than `Anyone with link → Editor`: editors can delete or replace the group's backups. If the Drive folder is publicly viewable, do not include confidential or proprietary images and do not put Windows images there.

### Export from the owner's Windows laptop

1. Confirm the originals still work and contain **Wazuh Agent 4.14.9**, not the earlier clean-only baseline.
2. Gracefully shut down both Linux VMs (`cd E:\ISSD_CAT2` then `vagrant halt ubuntu debian`). Do not destroy them and do not restore their old clean snapshots.
3. Open Windows PowerShell on the physical laptop and run:

```powershell
cd E:\ISSD_CAT2
powershell -ExecutionPolicy Bypass -File .\tools\prepare-drive-package.ps1
```

4. Upload the `E:\ISSD_CAT2\SharedExports\Deploy` folder contents to the **Deploy** folder in Drive.
5. Keep the original `VMs` folders and snapshots safe on your SSD (or in a separate private backup). Exporting **OVA flattens the current state and does not include snapshot history**.
6. For any later update, export to a new release folder instead of overwriting already-distributed archives while someone is downloading them.

Windows is **not included by default**. An authorised owner may separately export it with `-IncludeWindows`, only after confirming Microsoft Windows Enterprise Evaluation redistribution terms allow sharing a preinstalled evaluation VM. The simpler and safer group option is to use the original Windows VM for the demonstration or install Windows individually using `docs/04_WINDOWS11_STEP_BY_STEP.md`.

## Why use OVA exports instead of copying `VMs/` or `VagrantHome/`?

- OVAs are **portable, ready-to-import copies of the current installed operating systems**, including the packages present at export time.
- The imported VM has a new VirtualBox registration; it is NOT attached to the owner's Vagrant state.
- Full VirtualBox snapshots are **not** exported. Preserve snapshot history using a separate full, powered-off VM clone/backup when necessary, not a normal OVA.
- Transferring raw `.vbox` files and differencing `.vdi/.vmdk` chains across computers is more fragile and can break because of path, snapshot chain, or VirtualBox network differences.

## Important network/agent limits

- The prepared Linux VMs use `192.168.56.11` and `192.168.56.12`. Your Windows VM used `192.168.56.13`. These IPs are **local to each laptop** and not reachable across arbitrary laptops by default.
- The intended pre-enrollment OVAs have Wazuh 4.14.9 installed. Verify their actual state before import/distribution; the original lab is now enrolled. Imported copies must have unique identities and a reachable approved manager. This script does not configure or verify enrollment or local/cloud synchronization.
- **Do not clone already-enrolled Wazuh agents** into multiple computers with the same agent identity. Export before enrollment or remove/re-enroll the identity as appropriate.
- No dangerous lab VM should be placed on a bridged/public network without group approval. The script changes newly imported Adapter 1 to NAT and Adapter 2 to host-only when the adapter exists. Confirm settings before starting.
- An import of the Windows VM may assign a new virtual NIC identity; verify the host-only IP and ensure the Windows installer ISO is not mounted. If Windows shows the installer, check Storage and boot order rather than reinstalling.

## Collaboration

GitHub remains the source of truth for **code, setup scripts, markdown guides and sanitized inventory**. Google Drive holds **OVAs and evidence**. Do not commit `.ova`, `.iso`, `.vdi`, `.vmdk`, `.sav` or secret keys to Git. Each member updates the GitHub project through a branch or reviewed changes; no one should edit the original shared VM disk files inside Google Drive.

## What has NOT been completed by this script

- The member's actual Google Drive login and large downloads (will run only after the folder exists and OAuth succeeds)
- The real Windows guest license review and optional distribution
- Verified host-only NIC on the target machine if none exists
- Wazuh manager deployment, agent enrollment, local/cloud sync, vulnerability results
- A test run importing your exact OVAs on a different computer
