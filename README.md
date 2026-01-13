# Chezmoi Dotfiles Repository

This repository contains dotfiles managed by chezmoi, including shell configurations (bash, zsh), editor configs (vim, zed, Cursor), window manager settings (sway), and various application configurations.

## Prerequisites

The asumption is that `chezmoi apply` will be run from Ansible to install new machines, VMs and desktops remotely. It is also assumed, that 1password CLI will be installed on the remote machines with Ansible ahead of running the `chezmoi apply`. Current chezmoi configuration assumes that the 1password service account token (`OP_SERVICE_ACCOUNT_TOKEN`) is configurred in the environment for the automatic authentication.

```bash
# Ensure token is available
export OP_SERVICE_ACCOUNT_TOKEN="ops_xxxxxxxxxxxxx"

# Test 1Password access
op vault list

# Apply dotfiles with secrets
chezmoi apply
```

## Chezmoi Quick Reference

A quick reference guide for day-to-day chezmoi operations.

### Repository Location

- **Chezmoi source directory**: `~/.local/share/chezmoi` (default, but see custom setup below)
- **Chezmoi config file**: `~/.config/chezmoi/chezmoi.toml`
- **Custom setup**: This repo uses a subdirectory within the larger homelab repo at `~/fun/homelab/chezmoi`

### Custom Repository Setup

To use a subdirectory within a larger Git repository:

```bash
# Initialize chezmoi with a custom source directory
chezmoi init --source ~/fun/homelab/chezmoi

# Or if already initialized, change the source path
chezmoi init --source ~/fun/homelab/chezmoi --apply
```

Add to `~/.config/chezmoi/chezmoi.toml`:

```toml
[sourceDir]
    path = "~/fun/homelab/chezmoi"
```

### Daily Workflow Commands

#### Applying Dotfiles

```bash
# Apply all dotfiles from the repo to your home directory
chezmoi apply

# Apply with verbose output
chezmoi apply -v

# Dry run - see what would change without making changes
chezmoi apply --dry-run
```

#### Adding Files to Chezmoi

```bash
# Add a new file to chezmoi management
chezmoi add ~/.zshrc

# Add a file as a template (for use with variables)
chezmoi add --template ~/.config/starship.toml

# Add a private file (will be prefixed with 'private_')
chezmoi add --private ~/.ssh/config

# Add an executable script
chezmoi add --executable ~/.local/bin/myscript.sh
```

#### Editing Files

```bash
# Edit a file in chezmoi (opens your $EDITOR)
chezmoi edit ~/.zshrc

# Edit and apply immediately
chezmoi edit --apply ~/.zshrc

# Edit the source file directly
vim ~/.local/share/chezmoi/dot_zshrc
```

#### Viewing Changes

```bash
# See what changes would be applied
chezmoi diff

# See the actual content of a managed file after templating
chezmoi cat ~/.zshrc

# Compare current state with what chezmoi would apply
chezmoi verify
```

#### Managing Files

```bash
# List all files managed by chezmoi
chezmoi managed

# List files in your home directory NOT managed by chezmoi
chezmoi unmanaged

# Remove a file from chezmoi management (doesn't delete the file)
chezmoi forget ~/.zshrc

# Update chezmoi's copy from your home directory
chezmoi re-add ~/.zshrc
```

#### Git Integration

**Important:** After `chezmoi add` or `chezmoi edit`, chezmoi does NOT automatically commit or push changes to Git. You need to manually commit and push.

```bash
# After adding or editing files, commit your changes
cd ~/fun/homelab/chezmoi
git status
git add .
git commit -m "Update dotfiles"
git push

# Or use chezmoi's built-in git commands (works from anywhere)
chezmoi cd           # Navigate to the source directory
git status
git add .
git commit -m "Update dotfiles"
git push
exit                 # Return to previous directory
```

### State and Updates

```bash
# Pull latest changes from Git and apply
chezmoi update

# Or in two steps:
chezmoi git pull
chezmoi apply

# Initialize chezmoi on a new machine
chezmoi init --apply https://github.com/yourusername/homelab.git
```

Files are automatically included/excluded based on machine type via `.chezmoiignore`.

### Troubleshooting

```bash
# Check chezmoi's view of your configuration
chezmoi doctor

# Force re-apply all files
chezmoi apply --force
```

## Machine Type Configuration

Bellow machine types are supported:

- `dt-dev`: Development Desktop (default - all configs)
- `bm-hypervisor`: Bare Metal Hypervisor (core configs only)
- `vm-k8s-node`: Kubernetes Node (core configs only)
- `vm-dev-container`: Development Container Host (core configs only)
- `vm-service`: Service VM (core configs only)
