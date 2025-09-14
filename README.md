# 🏠 HomeLab: My Adventures in Self-Hosting

This documents my attempt to build a "production grade" **HomeLab cluster** out of the devices I have laying around my house.  
It’s part experiment, part documentation, and part reminder that sometimes the best way to learn is to try, fail, and write it all down.  
I’m just someone who likes to tinker, self-host, and prove that we can build things together via community and run your own infrastructure.
Overall this experience has helped me become a stronger system architect and code reviewer due to LLM's hallucintating personality.

---

## 🔗 Quick Links

- **GitLab CE (self-hosted):** `https://gitlab.osifu.me` (via Cloudflare Tunnel/Access)  
- **Website (prod):** `https://osifu.me` — built with Astro, deployed from GitLab CI → Cloudflare Workers  
- **Website (staging):** `https://staging.osifu.me`

---

## 🌱 Why This Exists

- **To show my work** — This project is a public log of what I know and how I learn, especially around system design and operations.  
- **Community-driven** — I stick to open source tools as much as possible because they’re accessible, transparent, and shaped by collective knowledge.  
- **Right to repair** — If I own the hardware, I should control how it runs, how long it lasts, and what it does.  
- **Learning with LLMs** — I use AI to “vibe code”: improvise, debug, and iterate quickly. The goal isn’t perfect code on the first try, but repeatable, useful setups after a few messy drafts.  

---

## 📝 Philosophy

This project isn’t about building a flawless homelab.  
It’s about experimenting, documenting, and making the process visible — including the missteps — so that others can learn, adapt, or even laugh along the way.  

I believe in:  

- **Open source** because knowledge should be shared, not gated, and communities thrive when tools are accessible to everyone.
- **Right to repair** because ownership should mean the freedom to tinker, fix, and extend the life of our hardware together.  
- **Learning out loud** because when we document both our wins and failures, we contribute back to the collective knowledge pool.  

And about **LLMs**:  

I think LLMs are often overhyped. At its core, it’s **language pattern recognition**, surfacing a common baseline of what our communities have already written, built, and discovered. That’s powerful — but it can’t replace the depth of expertise or the context that comes from real practice in any profession.  

Engineering, for instance, isn’t just about “building a bridge.” It’s about building a bridge with specific constraints: safety, cost, environment, accessibility. Those considerations come from people, communities, and lived experience — not from predictive text.  

Still, AI has value. It shouldn’t be about replacing people, but about **augmenting communities**: giving us faster ways to draft, share, and remix ideas. Used well, LLMs can help lower barriers to entry and let more people participate in building and learning.  

That’s why I use them here. They help me “vibe code,” improvise, and move faster — but the real strength comes from connecting those outputs back to **community best practices, shared knowledge, and collective problem-solving**.  

---

## 🔧 Hardware

- **3× Intel NUCs** — high-availability control plane + storage  
- **2× Raspberry Pi 4s** — ARM worker nodes  
- **2× Raspberry Pi 5s** — ARM worker nodes (newer gen, not yet fully supported everywhere)
- **iMac (2015, 18 GB RAM, Ubuntu)** — **GitLab CE** host + **shell CI runner**
- **Router / Edge** — Cloudflare Zero Trust in front; pfSense/OPNsense used/planned
- **External storage** attached to one NUC  
- **Mac Mini Router (pfSense)** — routing, firewall, VPN  

---

## ✅ What’s Working Now

### 1) GitLab CE on iMac (behind Cloudflare)

- **GitLab CE** installed on the iMac (Ubuntu), reachable at `gitlab.osifu.me` via **Cloudflare Tunnel**.
- **Cloudflare Access** in front; Rules for runner egress IPs so CI can hit the API non-interactively.
- **Shell runner** on the iMac (tags: `imac`, `web`, `opencl`) for Node/PNPM builds and OpenCL workflows.
- (Optional) **Kubernetes runner** via Helm on MicroK8s (tags: `k8s`) for elastic jobs—ready to use.

### 2) Portfolio/Blog Website Pipeline

- Site uses **Astro** + **Tailwind v4** (`@tailwindcss/vite`), package manager **pnpm**.
- GitLab CI builds with **pnpm** then deploys to **Cloudflare Workers (Static Assets)** via **Wrangler**.
- **Custom domains** managed by Wrangler (no placeholder DNS):  
  - `osifu.me` (prod, branch `main`, `--env=""`)  
  - `staging.osifu.me` (staging, branch `develop`, `--env=staging`)
- **CI hardening** completed:
  - Node available to `gitlab-runner` user (PATH fixed).
  - pnpm made non-interactive (allowlist via `onlyBuiltDependencies` or CI var `npm_config_dangerously_allow_all_builds=true`).
  - Build+deploy combined in one job (no artifact uploads → fewer proxy issues).
  - Wrangler token scopes + `CLOUDFLARE_ACCOUNT_ID` set in GitLab variables.

### 3) Cluster Direction

- **MicroK8s** selected to unify NUCs + RPis (ARM/AMD64).
- **OpenTofu + Packer** planned for golden images & infra state.
- **GitOps** (Argo CD or Flux) will manage `env/staging` and `env/prod` states.
- Observability (Prometheus/Grafana/Loki) and runtime security (Falco) on the roadmap.

---

## Software Stack

## 📦 Software Stack (current & planned)

- **Now**
  - GitLab CE (CI/CD, runners)
  - Cloudflare Zero Trust (Tunnel, Access), Workers (Static Assets)
  - Astro + Tailwind v4 + pnpm, Wrangler deploy
- **Planned / WIP**
  - MicroK8s HA + storage class (Rook-Ceph/OpenEBS)
  - OpenTofu + Packer (image builds; infra state in B2/S3)
  - GitOps (Argo CD / Flux); SealedSecrets or External Secrets (SOPS/AGE)
  - **Identity:** Windows Server **Active Directory** (lab) + **Authentik** (IdP/SSO; OIDC/SAML)
  - **Data/Messaging:** PostgreSQL, Redis/Memcached, RabbitMQ, MongoDB
  - **HA Logging/Monitoring:** Vector/Fluent Bit → **Kafka** → OpenSearch/ClickHouse; Prometheus(+Thanos)/Grafana; Loki; Tempo

## 🧱 Hardware Considerations (prod-like & open-friendly) now that I'm attempting to create a production grade environment

### Philosophy

- Prefer **hardware that runs mainline Linux/BSD cleanly** (Intel NICs, NVMe w/ good drivers), avoid proprietary lock-ins.
- Aim for **redundancy + observability** first; raw speed second. Design for **graceful degradation** and **easy replacement**.
- Reuse old devices such as vintage Macbook Airs or iMacs to breathe new life into these workflows.

### Control Plane & Compute

- Keep MicroK8s control plane on the **3× NUCs**; pin etcd/CP there for stability.  
- **ECC**: NUCs lack ECC; plan a future upgrade path (e.g., **ASRock Rack / Supermicro** mini-servers with ECC UDIMMs) for long-lived stateful workloads.  
- **RPi 4/5**: use for **stateless/edge**; boot from **USB SSD**, add heatsinks, good PSUs, PoE+ if useful.

### Storage (K8s & DBs)

- Use **ZFS** or **ext4/xfs + mdadm**; avoid vendor RAID. Schedule ZFS scrubs.  
- Prefer **NVMe with power-loss protection** for Postgres/Kafka/WAL/AOF. Put **logs/WAL** on fastest device; bulk data on larger SSD/HDD.  
- For distributed storage (Rook-Ceph/Longhorn), add **≥10GbE** or keep datasets modest; replication is network-hungry.  
- External/JBOD: choose **HBA in IT mode** (LSI 2008/2308/3008) for open drivers and ZFS-friendly behavior.

### Networking

- Baseline **2.5GbE** to each node; stretch **10GbE SFP+** between storage/DB/Kafka nodes.  
- Prefer **Intel i225/i210/i350** NICs; avoid USB for core replication paths.  
- **Switching**: fanless 2.5GbE access + small **10GbE SFP+** spine (DAC cables). Use **VLANs** for `frontend`, `apps`, `data`, `observability`.

### Power, Cooling, & Management

- **UPS** sized for 10–20 min; integrate **NUT** for graceful shutdowns.  
- Keep temps in check; quiet 120 mm airflow + dust filters.  
- Add **PiKVM** (open design) or IPMI-capable boxes for out-of-band.

### Security & Crypto

- Use **TPM 2.0** or **LUKS** for node-disk encryption (at least control & DB nodes).  
- **Time sync**: enable NTP (PTP if needed). Auth, certs, Kafka all want correct clocks.

### Service Placement (this stack)

- **PostgreSQL / MongoDB**: run on **NUCs** with NVMe; avoid RPi except for dev/scratch.  
- **Redis/Memcached**: RAM-heavy; keep on NUCs. Redis with AOF + RDB to NVMe.  
- **RabbitMQ**: 3-node cluster on NUCs; keep queues near producers/consumers.  
- **Kafka (KRaft)**: needs **NVMe, RAM, 10GbE**; three brokers minimum, separate log dirs if possible.

---

## 📏 Sizing Cheat Sheet (start small; scale up)

| Service          | vCPU | RAM   | Storage (min)               | Notes                                   |
|------------------|:----:|:-----:|-----------------------------|-----------------------------------------|
| PostgreSQL (HA)  | 2–4  | 8–16G | NVMe 100–500 GB (+WAL fast) | pgBackRest to object store; replicas=3  |
| Redis (AOF)      | 2    | 4–8G  | NVMe 20–50 GB               | Sentinel/Cluster; watch memory/evictions|
| RabbitMQ (3x)    | 1–2  | 2–4G  | SSD 20–50 GB                | Quorum queues + DLQs; low-latency NIC   |
| MongoDB (RS)     | 2–4  | 8–16G | NVMe 200–500 GB             | WiredTiger; backups + restore drills    |
| Kafka (3x)       | 2–4  | 8–16G | NVMe 500 GB–1 TB (each)     | KRaft; 10GbE; separate log dirs if can  |
| Loki/ClickHouse  | 2–4  | 8–16G | SSD/NVMe 200–500 GB         | Consider object storage tiering         |
| Prometheus       | 2    | 4–8G  | SSD 50–200 GB               | Remote write → Thanos/Victoria optional |

> Treating these as **floor** configs for a lab that mimics production. Validate with load tests and watch Grafana to right-size.

---

## 🧭 Roadmap — Data & Messaging Track (prod-ish on MicroK8s) - Updating this so I can collobrate with a friend who requested certain tech stacks to work with

### 0) Foundations (cluster + storage + secrets)

- Namespaces: `data`, `messaging`, `apps`, `observability`.  
- StorageClass: Rook-Ceph (preferred) or OpenEBS; anti-affinity across NUCs.  
- Secrets: SOPS/AGE with a GitOps flow; one of `sealed-secrets` or `external-secrets`.  
- NetworkPolicy: default-deny in `data` & `messaging`; allow only app namespaces.

### 1) Operators / Helm (install once) 

- PostgreSQL: **CloudNativePG** (or Crunchy) operator.  
- Redis: Redis Operator **or** Bitnami Redis (sentinel/cluster).  
- RabbitMQ: **RabbitMQ Cluster Operator**.  
- MongoDB: MongoDB Community Operator **or** Bitnami MongoDB (replicaset).

### 2) Minimal HA services (replicated, anti-affinity)

- **PostgreSQL**: 3-node HA; WAL archive; pgBackRest.  
- **Redis**: sentinel/cluster; RDB+AOF; secrets via SOPS.  
- **RabbitMQ**: 3-node; definitions from ConfigMap; quorum queues; DLQs.  
- **MongoDB**: 3-member replica set; scheduled backups.

### 3) Observability + SLOs

- Exporters: `postgres_exporter`, `redis_exporter`, `rabbitmq_exporter`, `mongodb_exporter`.  
- Grafana dashboards + alert rules (replica lag, disk %, consumer lag, queue depth).  
- Central log pipeline: Vector/Fluent Bit → **Kafka** → sinks (OpenSearch/ClickHouse).

### 4) Access for developers (secure + convenient)

- Cloudflare Access service tokens + bastion / `kubectl port-forward` for DB access.  
- **Authentik** SSO for dashboards (Grafana, RabbitMQ Mgmt, pgAdmin, Mongo Express).  
- Per-env credentials (staging/prod) via SOPS; read-only users for analytics.

### 5) CI/CD wiring (GitLab)

- **Migrations repo** (e.g., `apps/app-db`): `/migrations` (SQL/Prisma/Flyway).  
- Pipeline: **plan** (dry-run) → **apply** (staging) → **manual** (prod).  
- Seed data per env; smoke tests: SQL healthcheck, Redis PING, Rabbit publish/consume, Mongo read/write.  
- **Backups CI**: nightly dump + restore rehearsal into a throwaway namespace (prove RPO/RTO).

### 6) Reliability tests

- Kill a Postgres primary → confirm failover + app reconnection.  
- Evict a RabbitMQ node → verify quorum queues survive.  
- Corrupt a Redis pod → ensure sentinel/cluster handling.  
- Restore Mongo from last backup into `restore-*`; compare checksums.

### 7) Runbooks & docs (collab-ready)

- Connection strings, creds retrieval (SOPS), common `kubectl` cmds.  
- Migration etiquette (windows, rollbacks), backup/restore steps, failover drills.

---

## 👥 Roles & Collaboration

**Me (platform):**  
Cluster, storage, operators, GitOps, secrets, access policies, exporters, backups, runbooks.

**Backend engineer (friend):**  
Schema design & migrations (Postgres + Mongo), caching strategy (Redis keys/TTL), queue contracts (RabbitMQ exchanges, DLQs), app integration tests & synthetic checks.

**Branching / Environments:**  
`develop` → staging (auto-migrate + deploy).  
`main` → prod (migrate via manual approval).  
Using GitLab **Merge Request pipelines** for per-MR test namespaces when feasible.

---

## 📖 Dev Logs

This repo isn’t about polished guides — it’s about **dev logs**:  

- What I tried
- What actually happened
- What I learned (eventually)

Entries:  

- [2025-09-03 — Lessons Learned: Vibe Coding My MicroK8s Cluster](./devlog/2025-09-03-microk8s-retro.md)
- [2025-09-03 — Lessons Learned: Vibe Coding My MicroK8s Cluster](./devlog/homelab/devlog/2025-09-14-imac-gitlab-cloudflare.md)

---

## 🗺️ Roadmap (Updated)

- [x] Stand up **GitLab CE** on the iMac behind Cloudflare Tunnel  
- [x] Add **shell runner**; fix Node/PNPM visibility and PATH  
- [x] Build & deploy **Astro** site to **Cloudflare Workers** (prod/staging)  
- [x] Make pnpm non-interactive for CI (`onlyBuiltDependencies` or CI var)

- [ ] Bootstrap **MicroK8s** across NUCs/RPis; join & enable addons  
- [ ] Add **K8s runner**; move general CI to K8s  
- [ ] Wire **GitOps** (Argo/Flux) for `env/staging` and `env/prod`  
- [ ] Bake **Packer** images; manage with **OpenTofu** (state in B2/S3)

- [ ] **Identity & Access (prod-like)**  
  - Deploy **Windows Server Active Directory** (lab forest/domain) for centralized auth & GPO testing  
  - Deploy **Authentik** as IdP/SSO (OIDC/SAML); integrate with GitLab, Grafana, Home Assistant, Jellyfin, etc.  
  - Optional: chain **AD ↔ Authentik** (LDAP/Kerberos) and front apps with **Cloudflare Access**

- [ ] **High-Availability Observability & Logging**  
  - Ship logs/metrics with **Fluent Bit/Vector → Kafka (3-node)** for durable, scalable pipelines  
  - Sink logs to **OpenSearch/ClickHouse**; keep **Grafana** for dashboards  
  - Metrics: **Prometheus** (HA via **Thanos** or **VictoriaMetrics**) + **Alertmanager** (HA)  
  - Traces with **Tempo/Jaeger**; log enrichment & routing via **Kafka Connect/ksqlDB**

- [ ] Backups: **Velero** + GitLab backups → object storage  
- [ ] App rollout: Home Assistant, Pi-hole, Jellyfin, ingress, secrets (SOPS/AGE)

---

## 🚀 How to Reproduce (high-level)

1. Install **GitLab CE** on a Linux host (iMac here) and front it with **Cloudflare Tunnel/Access**.  
2. Add a **shell runner** (or K8s runner). Ensure Node/PNPM are visible to the `gitlab-runner` user.  
3. Create **CLOUDFLARE_ACCOUNT_ID** and **CLOUDFLARE_API_TOKEN** in GitLab → CI/CD → Variables (masked, protected).  
4. Build an **Astro** site with **pnpm**; deploy via **Wrangler** using **custom domains** (`wrangler.jsonc`).  
5. Iterate toward **MicroK8s + GitOps + OpenTofu/Packer** for the cluster.  
6. Add **AD + Authentik**, then layer **Postgres/Redis/RabbitMQ/Mongo** and the **Kafka-backed** log pipeline.

---