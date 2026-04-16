# Attacking Linux Lab Bootstrap

Ansible bootstrap for my **Attacking Linux** class at **EKoparty Hackademy**.

This repository provisions a deliberately vulnerable Ubuntu lab VM used for demos and exercises. The target environment is designed to be easy to reset and quick to verify during class.

## What It Deploys

- WordPress served from `/var/www/wordpress`
- MariaDB with a `wordpress` database
- Nginx + PHP-FPM
- VSFTPD with a weakly protected local user
- SSH password authentication enabled
- Intentionally weak filesystem permissions in selected paths
- A backup archive of `wp-config.php`
- Noise files in the FTP user's home directory

## WordPress Plugins

The playbook installs and activates these bundled plugins from `templates/plugins`:

- `wp-autosuggest.0.24.zip`
- `wp-site-import.1.0.1.zip`
- a vulnerable site editor component referenced in the course material
- an exposed upload workflow used for the lab narrative

## Lab Notes

The environment includes insecure defaults on purpose for training use. Examples include weak credentials, writable paths, and permissive service configuration. This repository is meant for isolated lab VMs, not for production or internet-exposed systems.

## Prerequisites

- An Ubuntu target VM reachable over SSH
- Ansible installed on the control machine
- SSH access to the target host defined in `inventory.ini`
- `sudo` privileges for the remote user

## Reference Platform

This bootstrap is currently documented and maintained against the following reference VM:

```text
Distributor ID: Ubuntu
Description:    Ubuntu 24.04.4 LTS
Release:        24.04
Codename:       noble
Linux hackademy 6.8.0-101-generic #101-Ubuntu SMP PREEMPT_DYNAMIC Fri Feb 6 20:07:40 UTC 2026 aarch64 aarch64 aarch64 GNU/Linux
```

In other words:

- Ubuntu `24.04.4 LTS`
- kernel `6.8.0-101-generic`
- architecture `aarch64`

Current inventory target:

```ini
[lab]
192.168.100.136 ansible_user=tty0 ansible_become=true
```

## Usage

Provision the lab:

```bash
make create
```

Remove the lab:

```bash
make remove
```

Verify the deployed state:

```bash
make verify
```

## What `make verify` Checks

- `mariadb`, `nginx`, and `vsftpd` are running
- `wp-config.php` exists
- `backup.tgz` exists in the WordPress directory
- `/var/www/html` exists with the expected demo permissions
- the `webmaster` user exists
- bundled WordPress plugins are active

## Documentation

- `docs/ATTACK_SURFACE.md`: vulnerable components, intended findings, and lab storyline
- `docs/METHODOLOGY.md`: recon, enumeration, password auditing, web testing, and post-exploitation topics covered in class

## Shell Configuration

The playbook appends the following shell preferences to both `/root/.bashrc` and `/home/tty0/.bashrc`:

```bash
set -o vi
bind '"\C-l": clear-screen'
export PATH=$PATH:/home/tty0/.local/bin
export VISUAL=vim
export EDITOR=vim
export PAGER=vim
```

## Repository Layout

- `lab.yml`: main Ansible playbook
- `inventory.ini`: target host inventory
- `Makefile`: convenience targets for create, remove, and verify
- `docs/`: supporting course and scenario documentation
- `templates/`: nginx, PHP-FPM, WordPress, and plugin assets
