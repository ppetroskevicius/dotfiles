# Chezmoi Dotfiles for Home Lab

This repository manages dotfiles across multiple machine types in a home lab environment using [Chezmoi](https://www.chezmoi.io/).

## Overview

- **Repository**: `ssh://git@github.com/ppetroskevicius/homelab.git`
- **Chezmoi source**: `~/fun/homelab/chezmoi` (subdirectory of larger homelab repo)
- **Config file**: `~/.config/chezmoi/chezmoi.toml`

## Prerequisites

Dotfiles are deployed via Ansible automation:

1. **1Password CLI** - Installed on target machines before running `chezmoi apply`
2. **Service Account Token** - `OP_SERVICE_ACCOUNT_TOKEN` environment variable must be set
3. **Chezmoi** - Installed on target machines

## Machine Types

Dotfiles are applied conditionally based on hostname prefixes:

| Machine Type              | Hostname Pattern | Purpose                              | Dotfile Scope      |
| ------------------------- | ---------------- | ------------------------------------ | ------------------ |
| **Desktop**               | `dt-*`           | Development desktops with GUI        | Full configuration |
| **Bare Metal Hypervisor** | `bm-*`           | KVM hosts for running VMs            | Minimal (CLI only) |
| **Kubernetes Node**       | `vm-k8s-*`       | K3s master/worker nodes              | Minimal (CLI only) |
| **Dev Container**         | `vm-dev-*`       | Development container hosts          | Minimal (CLI only) |
| **Service VM**            | `vm-service-*`   | Standalone services (NFS, databases) | Minimal (CLI only) |

## Dotfile Categories

### Universal (All Machine Types)

Applied to all machines regardless of type:

- **Shell**: `.zshrc`, `.bashrc`, `.bash_profile`, `.zprofile`
- **Tools**: `.vimrc`, `.tmux.conf`, `.editorconfig`
- **Git**: `.gitconfig` (SSH enforcement, auto-rebase disabled)
- **SSH**: `~/.ssh/config`, `~/.ssh/id_ed25519` (via 1Password)

### Desktop-Only (`dt-*` machines)

GUI and development tools:

**Window Manager & UI:**

- `~/.config/sway/` - Wayland window manager
- `~/.config/i3status-rust/` - Status bar
- `~/.config/mako/` - Notification daemon
- `~/.alacritty.toml` - Terminal emulator
- `~/.config/starship.toml` - Shell prompt

**Development Tools:**

- `~/.config/Cursor/` - Cursor IDE settings and extensions
- `~/.config/ruff/ruff.toml` - Python linter (150 char lines, 2-space indent)
- `~/.aws/` - AWS CLI configuration
- `/etc/wireguard/gw0.conf` - WireGuard VPN for remote access
- `/etc/tlp/` - Laptop power management

**Cursor IDE Extensions:**

- Python: `ms-python.python`, `charliermarsh.ruff`
- JavaScript/TypeScript: `dbaeumer.vscode-eslint`, `esbenp.prettier-vscode`
- Shell: `mkhl.shfmt`, `timonwong.shellcheck`
- Infrastructure: `hashicorp.terraform`, `github.vscode-github-actions`
- Other: Rust, Go, Java, Markdown, GraphQL, CSV, TOML

## Configuration Standards

**Python (Ruff):**

- Line length: 150 characters
- Indentation: 2 spaces

**EditorConfig:**

- Universal formatting standards across all file types
- Excludes: `.git`, `.venv`, `__pycache__`, `node_modules`

**Git:**

- SSH enforced for GitHub operations
- Auto-rebase disabled
- SSH key management via keychain (loads only if `~/.ssh/id_ed25519` exists)

## Security

- **SSH Keys**: Managed via 1Password, deployed from `op://Personal/ssh-key-ed25519`
- **WireGuard**: Configuration stored in 1Password at `op://build/wireguard/conf`
- **Service Account**: Read-only 1Password token for automation
- **File Permissions**: Sensitive files (SSH keys, WireGuard configs) set to `600`, owned by `root:root` where appropriate

## Deployment

### Initial Setup (New Machine)

```bash
# 1. Set 1Password service account token
export OP_SERVICE_ACCOUNT_TOKEN="ops_xxxxxxxxxxxxx"

# 2. Initialize chezmoi with custom source directory
chezmoi init --source ~/fun/homelab/chezmoi --apply
```

### Manual Updates

```bash
# Pull latest changes and apply
chezmoi update

# Or step-by-step
chezmoi cd
git pull
exit
chezmoi apply
```

## File Naming Conventions

Chezmoi uses special prefixes:

- `dot_` → `.` (dotfile)
- `private_` → Sets restrictive permissions
- `executable_` → Makes file executable
- `.tmpl` → Template file (processed with variables)
- `run_` → Script executed during `chezmoi apply`
- `run_onchange_` → Script executed only when it changes

Examples:

- `dot_zshrc` → `~/.zshrc`
- `private_dot_ssh/private_config` → `~/.ssh/config` (restricted permissions)
- `dot_config/sway/config.tmpl` → `~/.config/sway/config` (templated)
- `run_wireguard.sh` → Executed during apply

## Machine-Specific Logic

Files are conditionally applied via `.chezmoiignore`:

```
{{- if not (hasPrefix "dt-" .chezmoi.hostname) }}
# Desktop-only files ignored on non-desktop machines
dot_alacritty.toml.tmpl
dot_config/sway/
private_etc_wireguard_gw0.conf.tmpl
{{- end }}
```

## Troubleshooting

```bash
# Check configuration
chezmoi doctor

# See what would change (dry run)
chezmoi apply --dry-run

# View differences
chezmoi diff

# Verify all files are in sync
chezmoi verify

# Debug template data
chezmoi data
```

## References

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- See `README.md` for daily workflow commands
