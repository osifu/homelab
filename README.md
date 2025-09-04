# homelab

# Lessons Learned: Vibe Coding My MicroK8s Cluster

This README documents my overall attempt at setting up and running a MicroK8s cluster by "vibe coding"—diving in without a strict plan, experimenting, and learning as I went.
It’s not a step-by-step guide, but rather a retrospective of what worked, what didn’t, and what I’d do differently.

---

## 🎯 Goals
- Deploy a working MicroK8s cluster across Intel NUC and Raspberry Pi nodes.
- Use automation to deploy with tools I'm comfortable with (Ansible, shell scripts, Terraform).
- Integrate services like Cloudflare so it can be exposed to the internet securely (Zero Trust, DNS, Tunnels).
- Learn by doing—accepting trial, error, and debugging as part of the process. Exposing myself to LLM head first through experimentation.

---

## ✅ Wins
- **Cluster Brought to Life**: I successfully got multiple NUCs and Pi workers participating in the cluster.
- **ZFS Storage Pools**: Learned how to provision storage across external drives on NUCs.
- **Cloudflare Tunnel Experiments**: Gained hands-on experience with setting up tunnels for ingress traffic.
- **Ansible Lessons**: Built conditional logic for existing data checks and dynamic skipping of missing devices.
- **RBAC & Security Awareness**: Reinforced that identity and permissions should be thought through *early*.
- **Kubernetes**: Definetely firehosed my learning of managing a control plane
---

## ⚠️ Challenges
- **Pods Crashing**: Debugging failures without proper logging visibility wasted time.
- **DNS/DNS Conflicts**: Cloudflare DNS records sometimes conflicted with service names (duplicate A/CNAME issues).
- **Cert Management**: Missing `cert.pem` and unclear defaults in Cloudflared tripped me up.
- **MicroK8s Reset**: Some commands assumed single-node context, but my cluster was multi-node—leading to errors.
- **Networking Plugins**: Calico required multiple retries and occasionally failed silently.
- **LLM patterns**: Constantly have to remind ChatGPT to not use Jinja but it was adamant to the point where I caved.

---

## 🤔 Lessons Learned

1. **Plan First or Create Specification Documents**  
   Jumping straight in led to messy configurations. Define which nodes are masters vs. workers up front.

2. **Start Small, Then Scale**  
   I should have validated everything on a single NUC before adding Pi workers.  
   Debugging a 4-node cluster without a clean baseline was painful.
   Consider to use Packer?

3. **Logs Are Gold**  
   Always enable detailed logging and know where to check (`journalctl`, `microk8s inspect`, `kubectl describe pod`).

4. **DNS is Always the Culprit**  
   Most external access problems came down to DNS conflicts. Automate conflict checks before applying records.

5. **Idempotence Matters**  
   Ansible plays should never assume “blank slate” clusters. Conditional logic and skips prevent data loss.

6. **Certificates Need Love**  
   Cloudflare tunnels rely on origin certs—explicitly define paths and validate them during setup.

7. **Automate Verification**  
   Adding health checks (`microk8s status --wait-ready`) saved time by catching broken states early.

8. **LLM Prompt Engineering or Specifications**
    Basic specifications when interacting with an LLM make it tremendenlousy easier. Used ChatGPT for this experiment and enabling the memory feature is beneficial but if you talk with it long enough while still learning it'll definitely keep the ideas of bad system design and the collective brain power of humanity patterns which skews to medicority.

---

## 🔮 Next Steps
- Build a **golden path playbook**: a reliable bootstrap for single-node, then expand?
- Centralize **logging and monitoring** (Grafana, Prometheus) early to see pod health trends.
- Treat **DNS + Certificates** as first-class citizens in the setup process, set that up before.
- Document **Ansible roles** so future runs aren’t “vibe-based” but repeatable.
- Use a different LLM for different parts of the homelab.

---

## 📝 Final Thoughts
Vibe coding was fun and forced me to learn quickly, but clusters are very unforgiving.  
The takeaway: **experiment freely, but operationalize with structure.**  
Next attempt, I’ll balance improvisation with disciplined automation but it was definitely good attempt at interacting with AI better.
