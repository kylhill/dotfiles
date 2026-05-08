# Global Copilot Instructions

## Autonomy — proceed without asking

- Reading any file, log, API response, or metric
- Running `ansible-lint`, `git diff`, `git log`, `git status`
- Editing files inside any git repository under `/home/kyleh/`
- Adding, modifying, or removing Ansible roles, tasks, templates, vars, and defaults
- Running `SELECT` queries against any database
- Fetching URLs for research or diagnostics
- Running `docker ps`, `docker logs`, `docker inspect`, and other read-only Docker commands
- Querying Grafana/Prometheus/Loki for metrics or logs
- Running `infra-diag` or any other read-only diagnostic command

## Always pause and confirm before proceeding

- Any SQL that modifies data: `INSERT`, `UPDATE`, `DELETE`, `DROP`, `TRUNCATE`, `ALTER`
- Running `ansible-playbook` (propose the command; never run it)
- Creating git commits or pushing branches (propose; never run)
- Writing files outside of a git repository
- Direct edits to system config files not tracked by Ansible (`/etc/`, `/usr/`, `/var/`, `/opt/` outside of `/opt/appdata/` managed paths)
- `ssh` commands that mutate state on `syntax`, `gateway`, or `oci`
- `docker exec` commands that write data or change config inside a running container
- Anything involving secrets, or vault files

## Filesystem boundaries

- Safe to read and write: `/home/kyleh/infra`, `/home/kyleh/docker-nginx`, `/home/kyleh/cloudflare-ddns`, `/home/kyleh/nextcloud`, `~/.copilot/`
- Off-limits without explicit instruction: `/etc/`, `/usr/`, `/var/`, `/sys/`, `/proc/`, `/boot/`
- `/opt/appdata/` — read freely; only write if deploying via Ansible or explicitly told to

## Database rules

- Always show the full query before running anything that modifies data
- For destructive operations, run a matching `SELECT` first to preview affected rows
- Never run a `DELETE` or `UPDATE` without a `WHERE` clause

## Infra-specific rules (tacomafia.net)

- Never run `ansible-playbook` — make changes to roles/templates/vars and stop; user applies manually
- Never commit or push — user reviews and commits manually
- Vault variables (`vault_*`) are encrypted; never attempt to read, grep, or expose them
- Propose Ansible changes for any system config; never make changes directly or via SSH
- ESPHome configs live at `/opt/appdata/esphome/` — treat as a separate repo; use the `esphome-review` skill
