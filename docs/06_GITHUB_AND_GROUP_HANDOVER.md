# 06. GitHub + Google Drive: make collaboration easy without copying everyone's work

## Why Vagrant + GitHub is useful
- GitHub **holds recipes/configurations**, not running virtual machines.
- A colleague cloning this project and typing `vagrant up ubuntu`/`vagrant up debian` gets functionally equivalent **new** Linux guests with same expected 192.168.56.11/12 address **on her own computer**.
- These private 192.168.56.x IPs are LOCAL to each member's laptop. Member 1 CANNOT remotely scan your laptop's host-only VMs just by knowing IPs.
- Windows requires a one-time Microsoft ISO install on the colleague's laptop **or** a permitted offline VM transfer, if allowed. Not automated by our Vagrantfile.
- Members can make changes with Git branches/pull requests. Your running VMs never silently synchronize when someone pushes code.

## A. Use the existing repository

The repository already exists at `https://github.com/Eeshan-Vaghjiani/ISSD-cat2`, branch **master**. Do not run `git init`, rename the branch or create a replacement repository. Treat it as public unless visibility is confirmed otherwise. For current progress read `docs/CURRENT_STATUS.md`.

On a teammate's laptop:

```powershell
git clone https://github.com/Eeshan-Vaghjiani/ISSD-cat2.git
cd ISSD-cat2
```

The owner's remote is named `ISSD-cat2`; a fresh clone normally uses `origin`. Check `git remote -v` before pulling/pushing. Use the credential helper or GitHub CLI, never a token embedded in a file. The owner can invite collaborators in repository settings. Review staged files before committing; never stage VM folders or unredacted evidence.

## B. Member 1 workflow (her own laptop)
1. Install VirtualBox, Vagrant, Git.
2. Configure SATA/other drive storage as desired with script (she sets her own drive letter).
3. `git clone https://github.com/Eeshan-Vaghjiani/ISSD-cat2.git`
4. `cd ISSD-cat2`
5. `vagrant up ubuntu --provider=virtualbox`
6. `vagrant up debian --provider=virtualbox`
7. Use `docs/04_WINDOWS11_STEP_BY_STEP.md` for Windows if she needs it on her own laptop, or use the single authoritative Windows machine for the demo.
8. Confirm connectivity, draw and verify topology. Commit *documents/diagrams/configuration*, not VM disks.

## C. Work without accidental overwrites
- Create a GitHub Issue per deliverable (e.g. `M4 verify three running agents`, `M1 topology`); assign an owner.
- Member-specific branches: `m1-topology`, `m4-endpoints`, `m5-manager`, etc.
- Before edits, `git pull --ff-only origin master` on a fresh clone (owner uses remote `ISSD-cat2`). Submit pull requests, have another member review, merge to `master`. Never force-push shared work.
- Changes to Vagrantfile should be approved by both Members 1 and 4 to avoid breaking shared infrastructure.
- Put screenshots/results in the shared Google Drive folder (`ISSD CAT2 / Member 1 ... Member 6 / Shared Demo`); link those folders in GitHub documentation if permitted.
- Do NOT commit passwords, API keys, registration keys, unredacted host data or Windows licensed images.

## D. Exact collaboration truth
Option 1 (recommended): Local replicated VMs from same config. Reliable, independent but not live synchronized.
Option 2: Power OFF Linux VM, export OVA using VirtualBox > File > Export Appliance, store via approved group drive as allowed. Colleague imports on her laptop. Large transfer; snapshots and software identities need management.
Option 3: One shared demo host plus screen sharing; everyone can observe, only authorized operator should make changes. For remote management use an approved, secure VPN, not exposed vulnerable services.

## E. Before the demo
Choose a single authoritative demonstration environment, preferably on the strongest hardware. Member 1 gets a tested baseline and checks network. Members 2 and 5 set up distinct engines on machines with enough resources. Members 3 and 6 use authentic results.
