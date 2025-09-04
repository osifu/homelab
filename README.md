# 🏠 HomeLab: My Misadventures in Self-Hosting

This repo documents my attempt to build a **HomeLab cluster** out of Intel NUCs, Raspberry Pis, and a pfSense router.  
It’s part experiment, part documentation, and part reminder that sometimes the best way to learn is to try, fail, and write it all down.  
I’m just someone who likes to tinker, self-host, and prove that we can build things together via community and run your own infrastructure.  

---

## 🌱 Why This Exists

- **To show my work** — This project is a public log of what I know and how I learn, especially around system design and operations.  
- **Community-driven** — I stick to open source tools as much as possible because they’re accessible, transparent, and shaped by collective knowledge.  
- **Right to repair** — If I own the hardware, I should control how it runs, how long it lasts, and what it does.  
- **Learning with LLMs** — I use AI to “vibe code”: improvise, debug, and iterate quickly. The goal isn’t perfect code on the first try, but repeatable, useful setups after a few messy drafts.  

---

## 🔧 Hardware

- **3× Intel NUCs** — high-availability control plane + storage  
- **2× Raspberry Pi 4s** — ARM worker nodes  
- **2× Raspberry Pi 5s** — ARM worker nodes (newer gen, not yet fully supported everywhere)  
- **Mac Mini Router (pfSense)** — routing, firewall, VPN  

---

## Software Stack

- **MicroK8s** for cluster management (for now)  
- **Ansible** for automation (because repeating mistakes by hand is exhausting)  
- **Docker** for apps and services, chosen from [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)  
- **Proxmox + Packer + OpenTofu** planned for the next iteration (Talos isn’t an option yet due to lack of Raspberry Pi 5 support)  

### Starter Apps (Dockerized)

- **Monitoring**: Portainer, Netdata, Grafana + Prometheus  
- **Networking**: Pi-hole, Nginx Proxy Manager, Vaultwarden  
- **Media & Files**: Jellyfin, Nextcloud, Paperless-ngx  
- **Collaboration & Dev**: Gitea, Outline, Mattermost/Rocket.Chat  

---

## 📖 Dev Logs

This repo isn’t about polished guides — it’s about **dev logs**:  

- What I tried
- What actually happened
- What I learned (eventually)

Example entry:  
- [2025-09-03 — Lessons Learned: Vibe Coding My MicroK8s Cluster](./devlog/2025-09-03-microk8s-retro.md)

---

## 🗺️ Roadmap

- [ ] Bootstrap a single node cleanly → scale out  
- [ ] Centralized monitoring (Grafana, Prometheus, Loki)  
- [ ] Clean DNS + TLS setup with Cloudflare Tunnels  
- [ ] ZFS replication across NUCs  
- [ ] pfSense config automation  
- [ ] Backup + recovery that works under stress  
- [ ] Proxmox + Packer migration  
- [ ] Self-hosted apps running smoothly in Docker  

---

## 📝 Philosophy

This isn’t about building a flawless homelab.  
It’s about experimenting, documenting, and making the process visible — including the missteps.  

I believe in:  
- **Open source** because knowledge should be shared, not gated.
- **Right to repair** because ownership means control.  
- **Learning out loud** because even failures are valuable lessons.  

This is more of a “try, break, fix, repeat.” But by the end, hopefully it’ll be **repeatable, shareable, and yours to run however you want**.  

---
