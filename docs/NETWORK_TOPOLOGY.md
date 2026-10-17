# Proposed network topology, update after live verification

```text
                     Windows laptop (physical host)
                       VirtualBox + Vagrant
                        |             |
               Adapter 1 NAT   VirtualBox Host-only LAN
                (updates)        192.168.56.0/24
                                         |
                              -------------------------
                              |           |           |
                       Ubuntu Server   Debian 12    Windows 11
                       192.168.56.11   .56.12       .56.13
                        Nginx :80     Apache :80   Win agent
                              |           |           |
                    Agent A / Network scan target / Agent C
```

Host-only is one physical laptop's virtual network; other classmates' identical networks do not magically connect together. Scanning engines must be placed with network access to endpoints. The agent manager/cloud architecture remains TO BE SELECTED with Member 5. Show actual NAT vs host-only and local/cloud path in your final verified diagram, not this placeholder.
