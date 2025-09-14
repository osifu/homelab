---
title: "2025-09-14 — Standing Up iMac + GitLab CE + Cloudflare"
description: "Dev log of deploying a self-hosted GitLab behind Cloudflare Tunnel/Access and wiring CI to deploy my Astro site to Cloudflare Workers."
tags: ["gitlab-ce", "cloudflare", "wrangler", "ci", "homelab"]
---

# 2025-09-14 — iMac + GitLab CE + Cloudflare

Goal: run **GitLab CE** on my **iMac (2015, Ubuntu, 18 GB RAM)**, expose it safely through **Cloudflare Tunnel/Access**, and use **GitLab CI** to build my site and deploy to **Cloudflare Workers**.

---

## Context / Constraints

- **Public entry** must be fronted by Cloudflare (tunnel + Access).
- CI must be able to reach GitLab’s API **non-interactively** despite Access.
- Keep everything **self-hosted/open-friendly** and reproducible.

---

## Infra sketch

Dev → Git push
│
▼
Cloudflare (DNS + Tunnel + Access)
│
▼
iMac (Ubuntu) ── GitLab CE + shell runner
│
├─ Build (pnpm) → Astro
└─ Deploy via Wrangler → Cloudflare Workers (osifu.me / staging.osifu.me)

---

## Step 1 — GitLab CE on the iMac

## Step 1 — GitLab CE on the iMac

1. Install GitLab CE (Omnibus) and set external URL:
   ```bash
   sudo editor /etc/gitlab/gitlab.rb
   # external_url "https://gitlab.osifu.me"
   sudo gitlab-ctl reconfigure

    Cloudflare Tunnel terminates TLS; GitLab listens HTTP internally (keeps cert mgmt simple).

    Create an admin user, then a normal dev user (use admin only for admin).

Gotcha: Container Registry is disabled by default; I deferred it until the app pipeline was stable.

## Step 2 — Cloudflare Tunnel + Access

Created a tunnel mapping gitlab.osifu.me → http://127.0.0.1:80 on the iMac.

Set Access policies:

This lets runners hit the GitLab API without interactive login.

Normal Require rules for browsers (email/SSO, MFA, etc.)

## Step 3 — Runner registration (new tokens)

GitLab 17+ uses runner authentication tokens (glrt-…), not old registration tokens.

In the project: Settings → CI/CD → Runners → New runner.

Copied the glrt-… token.

Registered a system-mode shell runner

Gotcha (fixed): “PANIC: Failed to verify the runner”
Cause: Access blocked the verify call. Fix: added policy for runner IP and retry

## Step 4 — Make Node/pnpm visible to gitlab-runner

The shell runner runs as the gitlab-runner user; Node wasn’t on its PATH.

Installed Node system-wide;
Using Corepack to pin pnpm in CI;
Optional: ensured /etc/gitlab-runner/config.toml has PATH=/usr/local/bin:/usr/bin:….

## Step 5 — Website pipeline (Astro → Workers)

Project layout: portfolio/site with Astro + Tailwind v4 (@tailwindcss/vite) + pnpm.

Wrangler deploys Static Assets to Workers using custom domains:

osifu.me for prod (--env="")

staging.osifu.me for staging (--env=staging)

Secrets in GitLab → Settings → CI/CD → Variables (masked, protected):

CLOUDFLARE_ACCOUNT_ID

CLOUDFLARE_API_TOKEN (must have Workers Scripts: Edit and DNS: Edit for custom domains)

Gotcha (fixed): Wrangler 10000 auth error

Missing/incorrect CLOUDFLARE_ACCOUNT_ID or token scopes.

Fix: set both variables, confirm with wrangler whoami in CI, and pass --env explicitly.

Gotcha (fixed): pnpm approve-builds was interactive

Added an allowlist (preferred)

Decision: build+deploy in one job to skip artifact uploads, which hit proxy/body-size limits earlier.

## Validation

Runner online in project Runners page.

develop push → auto deploys to staging.osifu.me.

main push → auto deploys to osifu.me.

wrangler whoami prints correct account in job logs.

Access logs show runner IPs bypassing Access (no 403s).

## Lessons Learned

Access + CI: runners can’t complete Access challenges; a Bypass rule by IP is the simplest fix.

New runner tokens: use the glrt-… token flow (UI-created). Old registration tokens fail on modern GitLab.

Shell runner realities: install Node system-wide or your jobs won’t see npm/pnpm.

pnpm CI: pre-approve build scripts or set the CI-only var; otherwise jobs prompt.

Workers custom domains > routes when you don’t want to precreate DNS; requires DNS:Edit on the token.

## Next Steps

Add K8s runner on MicroK8s and migrate CI workloads there.

Bootstrap MicroK8s HA and storage (Rook-Ceph/OpenEBS).

Introduce AD + Authentik for prod-like identity and introduce my friend to collaborate.

Stand up Postgres/Redis/RabbitMQ/Mongo + Kafka-backed logging pipeline.

Wire GitOps (Argo/Flux) and start promoting services staging → prod.