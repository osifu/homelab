# 📝 Code Specification Template

Use this template to clearly define requirements when collaborating on code.

---

## 1. Goal / Problem Statement
**What is the main objective or problem to solve?**  
_(e.g., Automate the deployment of a web app on Kubernetes)_

---

## 2. Context / Background
**Why is this needed?**  
**Any existing code, tools, or infrastructure involved?**  
_(e.g., Using MicroK8s on local VMs, need CI/CD integration with GitLab)_

---

## 3. Scope
- **In Scope:**  
  _(e.g., Write Terraform configs for networking, provision EC2 instances)_
- **Out of Scope:**  
  _(e.g., Database migration is handled separately)_

---

## 4. Requirements
- **Functional Requirements:**  
  _(e.g., Must provision 3 replicas, expose service via LoadBalancer, use HTTPS)_
- **Non-Functional Requirements:**  
  _(e.g., Code must follow PEP8, include logging, be idempotent)_
- **Security / Compliance:**  
  _(e.g., Use TLS 1.2+, no hardcoded secrets)_

---

## 5. Inputs & Outputs
- **Inputs:**  
  _(e.g., User provides cluster.yaml, environment variables)_
- **Outputs:**  
  _(e.g., Deployed app with accessible endpoint, logs in /var/log/app.log)_

---

## 6. Constraints
_(e.g., Must run on ARM and x86 nodes, only use open-source tools, Python 3.10+)_

---

## 7. Edge Cases / Failure Scenarios
_(e.g., Network failure during deployment, invalid config values)_

---

## 8. Testing / Validation
**How will success be verified?**  
_(e.g., Integration tests pass, app is reachable via DNS)_

---

## 9. Example Usage / Workflow
_(Provide example CLI command, API call, or usage scenario)_

---

## 10. Preferred Style / Patterns
_(e.g., Follow DRY principles, use classes instead of scripts, prefer async)_

---

## 11. Deliverables
_(e.g., Terraform code, Ansible playbook, Python script, CI/CD pipeline YAML)_

---

### ✅ Example of a Filled Template

**Goal:** Automate creation of a MicroK8s cluster across 3 NUC control planes and 4 Raspberry Pi worker nodes.  
**Context:** Existing Ansible setup is partially working but lacks resilience and logging.  
**Scope:**  
- In: Join nodes, enable Calico, validate cluster health.  
- Out: Application deployment.  
**Requirements:**  
- Functional: Detect failures, retry joining.  
- Non-Functional: Use Ansible best practices, add logging.  
**Inputs:** Inventory file with hostnames.  
**Outputs:** Fully functioning HA MicroK8s cluster.  
**Constraints:** Must support Ubuntu 22.04.  
**Edge Cases:** Node fails to join due to network plugin errors.  
**Testing:** Run `microk8s status` on all nodes; expect "healthy".  
**Example Usage:** `ansible-playbook setup-cluster.yml -i inventory`  
**Style:** Use roles, avoid inline shell.  
**Deliverables:** Final playbook with logging and conditionals.