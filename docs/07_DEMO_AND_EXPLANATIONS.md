# 07. Questions the lecturer may ask: answer by doing, not memorizing only

**What is a hypervisor?** Software that runs independent virtual operating systems on the host. VirtualBox manages CPU, memory, virtual disks and network adapters for our endpoints.

**Why three endpoints?** The exercise is distributed; there must be evidence of vulnerability assessment across at least three different target machines, rather than one scanned computer.

**Why Linux + Windows?** Both appear in the lecturer's examples. Windows and Debian/Ubuntu give distinct OS package inventories, configuration and service behavior. All three can be considered for modern agents.

**What is NAT?** An interface used for outbound package downloads and reaching approved endpoints. It is different from the host-only assessment network. NAT is NOT the shared group LAN.

**What is host-only networking?** Virtual NICs connected to a virtual network available on a single physical laptop. Here it is 192.168.56.0/24. The VMs can speak to each other and host but are not inherently directly reachable from another laptop.

**What is an endpoint agent?** A program on a machine that collects operating system or software inventory and security telemetry for an authorized management platform.

**What is agentless network VA?** The scanner probes a host's reachable network services and configuration from outside, without requiring a resident agent. It can miss information only visible internally.

**What is agent-based VA?** The agent inspects and reports host-specific facts like installed software, patches and configuration. It usually requires registration with a management server.

**What is the difference between running and enrolled?** A locally running Windows/Linux service is evidence that an agent installed successfully, but not that it was correctly enrolled or checked in. Member 5 must prove the latter in the manager.

**What is a correlation engine?** The management component that receives agent data and combines it with vulnerability/advisory data for findings and reports. Installing agents alone is not a full vulnerability assessment.

**What is cloud synchronization?** An actual, demonstrable data synchronization/transfer process between the required local and cloud components. A dashboard screenshot by itself is not proof. Explain the real data path, timing, access policy and a change that appears on both sides.

**What if all your scans return few CVEs?** That does not necessarily mean scanning failed: show plugin/feed status, reachable targets, covered checks, evidence of scan completion, dates, scope and limitations. Do not intentionally disable production security controls; use isolated deliberately testable lab software if authorized.

**How to demonstrate your Member 4 work in ~2 minutes:**
1. Display VirtualBox with three VMs.
2. Explain their 192.168.56.11/.12/.13 addresses and NAT/host-only separation.
3. Show Ubuntu/Debian OS/IP commands, then Windows `winver` and `Get-NetIPAddress`.
4. Show Wazuh (or approved tool) agents' installed packages and running service statuses on three machines.
5. Hand off to Member 5's synchronized manager and enrollment list.
