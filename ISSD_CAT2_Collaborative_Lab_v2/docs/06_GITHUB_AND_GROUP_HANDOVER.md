# 06. GitHub + Google Drive: make collaboration easy without copying everyone's work

## Why Vagrant + GitHub is useful
- GitHub **holds recipes/configurations**, not running virtual machines.
- A colleague cloning this project and typing `vagrant up ubuntu`/`vagrant up debian` gets functionally equivalent **new** Linux guests with same expected 192.168.56.11/12 address **on her own computer**.
- These private 192.168.56.x IPs are LOCAL to each member's laptop. Member 1 CANNOT remotely scan your laptop's host-only VMs just by knowing IPs.
- Windows requires a one-time Microsoft ISO install on the colleague's laptop **or** a permitted offline VM transfer, if allowed. Not automated by our Vagrantfile.
- Members can make changes with Git branches/pull requests. Your running VMs never silently synchronize when someone pushes code.

## A. Create private GitHub repository
1. GitHub > New repository > name `issd-cat2-distributed-va` > choose **Private** > create empty repository (no README because project includes one).
2. Extract ZIP to your SSD `X:\ISSD_CAT2\LabRepo\ISSD_CAT2_Collaborative_Lab_v2`.
3. Install Git for Windows if not installed. In PowerShell inside that folder:
```powershell
git init
git add .
git commit -m "Create shared ISSD CAT2 lab baseline"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/issd-cat2-distributed-va.git
git push -u origin main
```
Replace YOUR_USERNAME. Authentication via GitHub browser/credential helper or GitHub CLI; do NOT put a password or token inside files.
4. GitHub repo > Settings > Collaborators > Add people > invite five classmates. They accept invitations.

## B. Member 1 workflow (her own laptop)
1. Install VirtualBox, Vagrant, Git.
2. Configure SATA/other drive storage as desired with script (she sets her own drive letter).
3. `git clone https://github.com/YOUR_USERNAME/issd-cat2-distributed-va.git`
4. `cd issd-cat2-distributed-va`
5. `vagrant up ubuntu --provider=virtualbox`
6. `vagrant up debian --provider=virtualbox`
7. Use `docs/04_WINDOWS11_STEP_BY_STEP.md` for Windows if she needs it on her own laptop, or use the single authoritative Windows machine for the demo.
8. Confirm connectivity, draw and verify topology. Commit *documents/diagrams/configuration*, not VM disks.

## C. Work without accidental overwrites
- Create a GitHub Issue per deliverable (e.g. `M4 verify three running agents`, `M1 topology`); assign an owner.
- Member-specific branches: `m1-topology`, `m4-endpoints`, `m5-manager`, etc.
- Before edits, `git pull origin main`. Submit pull requests, have another member review, merge to main.
- Changes to Vagrantfile should be approved by both Members 1 and 4 to avoid breaking shared infrastructure.
- Put screenshots/results in the shared Google Drive folder (`ISSD CAT2 / Member 1 ... Member 6 / Shared Demo`); link those folders in GitHub documentation if permitted.
- Do NOT commit passwords, API keys, registration keys, unredacted host data or Windows licensed images.

## D. Exact collaboration truth
Option 1 (recommended): Local replicated VMs from same config. Reliable, independent but not live synchronized.
Option 2: Power OFF Linux VM, export OVA using VirtualBox > File > Export Appliance, store via approved group drive as allowed. Colleague imports on her laptop. Large transfer; snapshots and software identities need management.
Option 3: One shared demo host plus screen sharing; everyone can observe, only authorized operator should make changes. For remote management use an approved, secure VPN, not exposed vulnerable services.

## E. Before the demo
Choose a single authoritative demonstration environment, preferably on the strongest hardware. Member 1 gets a tested baseline and checks network. Members 2 and 5 set up distinct engines on machines with enough resources. Members 3 and 6 use authentic results.
