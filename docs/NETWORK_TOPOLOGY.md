# Evidence-backed network topology

Reviewed 27 October 2026 against private evidence from Members 1, 4, 5 and 6. This diagram describes captured configuration, not current uptime. It supersedes the pre-manager `M4-09_Topology.png` (retain that image as installation history).

```mermaid
flowchart TB
    subgraph laptop[Physical Windows laptop - VirtualBox]
        scanner[Task 1: OpenVAS / gvmd / web UI - 192.168.56.20]
        lan[Host-only network - 192.168.56.0/24]
        ubuntu[Ubuntu 24.04 - issd-ubuntu - .11 - agent 001]
        debian[Debian 12 - issd-debian - .12 - agent 002]
        windows[Windows 11 Eval - ISSD-CAT2-windo - .13 - agent 003]
        worker[Task 2: Wazuh local worker - .30 - issd-local-worker]
        browser[Host browser - SSH tunnel - localhost:8443]
        browser --> scanner
        scanner -->|Agentless assessment| lan
        lan --- ubuntu
        lan --- debian
        lan --- windows
        ubuntu -->|Agent data| worker
        debian -->|Agent data| worker
        windows -->|Agent data| worker
    end
    worker <-->|Tailscale - Wazuh cluster| master[Oracle Cloud - issd-cloud-master]
    worker -->|Filebeat TLS via configured relay| indexer[Cloud indexer]
    master -->|Inventory and vulnerability processing| indexer
    indexer --> dashboard[Cloud Wazuh dashboard]
```

## Paths and limits

- NAT adapters support outbound updates; they are not the scanner-to-target path. Host-only keeps vulnerable services off the public LAN. Both tasks reuse the same three endpoints.
- Greenbone `gvmd` consolidates targets, tasks and reports; OpenVAS performs network tests; feeds supply vulnerability tests; the web UI presents results.
- Wazuh agents collect local inventory and send it to the local worker. The master/worker cluster shares agent registration/state; this is distinct from event forwarding and vulnerability indexing. Filebeat carries event data; do not describe it as the vulnerability-inventory synchronization mechanism.
- `M5-11` shows master and worker on 4.14.9. `M4-07` and `M5-14` show three active agents assigned to the worker; `M5-15` shows cloud inventory rows. Fresh `M5-16` worker/master logs now demonstrate group exchange and integrity checks. Some summary fields remain `n/a`; the actual logs show successful exchange and no integrity differences requiring transfer, not a failed cluster.
- `M5-18_Relay_Route_Redacted.png` shows the loopback relay's intended private cloud indexer destination and a certificate-verified Filebeat output test. `M5-17_Local_To_Cloud_Receipt.png` separately shows a uniquely marked benign Debian test indexed in the cloud, matched to the worker alert. This proves one live pipeline event, not that every historical event was received.
- Host-only networks on separate laptops are separate. Tailscale is the approved private inter-machine route in the captured design; do not expose agent, cluster or indexer ports to the public internet.
- A 16 GB laptop should demonstrate Tasks 1 and 2 separately; avoid running scanner, worker and all targets together unnecessarily.
