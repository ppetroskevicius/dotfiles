# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **chezmoi dotfiles repository** that manages personal configuration files across multiple machines. Chezmoi is a tool for managing dotfiles with features like templating, encryption, and cross-platform support.

## Essential Chezmoi Commands

### Basic Operations

- `chezmoi apply` - Apply all managed files to their target locations
- `chezmoi status` - Show which files differ between source and target
- `chezmoi diff` - Show what changes would be applied
- `chezmoi update` - Pull latest changes from git and apply them
- `chezmoi cd` - Change to the chezmoi source directory (~/.local/share/chezmoi)

### File Management

- `chezmoi add ~/.filename` - Add an existing file to chezmoi management
- `chezmoi edit ~/.filename` - Edit a managed file (opens source, applies on save)
- `chezmoi managed` - List all managed files
- `chezmoi unmanaged` - List unmanaged files in home directory

### Repository Operations

- `cd ~/.local/share/chezmoi` - Navigate to source directory for git operations
- `git add . && git commit -m "message" && git push` - Standard git workflow after edits

## File Architecture

### Naming Conventions

- `private_dot_filename` → `~/.filename` (deployed with 0600 permissions - only for sensitive files)
- `dot_filename` → `~/.filename` (standard permissions - preferred for most configs)
- Files in `dot_config/` → `~/.config/` directory structure
- Shared shell configuration in `dot_config/shell/common.sh`

### Key Configuration Categories

**Shell Environments:**

- `private_dot_zshrc` - Zsh configuration with Oh-My-Zsh, PATH management, SSH keychain
- `private_dot_bashrc` - Bash configuration
- `private_dot_bash_profile` - Bash profile

**Development Tools:**

- `private_dot_config/private_Cursor/` - Cursor IDE settings with comprehensive language support
- `private_dot_vimrc` - Vim configuration
- `private_dot_tmux.conf` - Terminal multiplexer settings

**System Configuration:**

- `private_dot_config/sway/` - Wayland window manager config
- `private_dot_config/i3status-rust/` - Status bar configuration
- `private_dot_config/mako/` - Notification daemon settings
- `private_dot_alacritty.toml` - Terminal emulator config

**Development Standards:**

- `dot_config/ruff/ruff.toml` - Python linter/formatter (150 char line length, 2-space indent)
- `dot_editorconfig` - Universal formatting standards across all file types
- `private_dot_gitconfig` - Git settings with SSH enforcement and auto-rebase disabled
- `.chezmoi.toml` - Chezmoi configuration with template data and preferences

## Editor Configurations

### Cursor IDE Extensions

The repository includes a curated extension list covering:

- Python: `ms-python.python`, `charliermarsh.ruff`
- JavaScript/TypeScript: `dbaeumer.vscode-eslint`, `esbenp.prettier-vscode`
- Shell: `mkhl.shfmt`, `timonwong.shellcheck`
- Infrastructure: `hashicorp.terraform`, `github.vscode-github-actions`
- Other: Rust, Go, Java, Markdown, GraphQL, CSV, TOML support

### Code Style Standards

- **Universal**: .editorconfig enforces 2-space indentation, UTF-8 encoding, LF line endings
- **Python**: Ruff handles all linting and formatting (150-character line length, 2-space indent)
- **Shell**: shfmt with `-bn -ci -sr -i 2` flags (binary ops at line start, switch cases indented)
- **General**: Consistent formatting across all file types, trailing whitespace trimmed

## Important Notes

- All `private_` prefixed files are deployed with restrictive permissions (0600) but stored as plain text in git
- The repository enforces SSH for GitHub operations via git config
- Remote repository: `ssh://git@github.com/ppetroskevicius/dotfiles.git`
- Python virtual environments expected at `.venv/bin/python` for LSP integration
- Shell configurations include conditional loading based on available tools (terraform, gcloud, docker)

## Security Considerations

- SSH key management via keychain (only loads if `~/.ssh/id_ed25519` exists)
- Git configured to use SSH instead of HTTPS for GitHub
- Editor configs exclude common directories from analysis: `.git`, `.venv`, `__pycache__`, `node_modules`

## Machine Types

There are several machine types, that will have different sets of the dotfiles as in the below table.

- **bm-hypervisor**: Bare Metal Hypervisor Hosts (KVM hosts for running VMs)
- **vm-k8s-node**: Kubernetes VM Nodes (k3s master/worker nodes)
- **vm-dev-container**: Development Container VM Hosts (for Dev Containers)
- **vm-service**: Service-Specific VMs (standalone services like NFS, databases)
- **dt-dev**: Development Desktops (physical desktops for interactive work)

## Dotfiles

Different sets dotfiles (for headless servers and for desktops) will be applied depending on the machine type. Also dotfiles might depend on the OS, like there is no sway configuration for Mac, as it is only used for Ubuntu.

| Package/Tool         | bm-hypervisor | vm-k8s-node | vm-dev-container | vm-service | dt-dev | Notes                                 |
| -------------------- | ------------- | ----------- | ---------------- | ---------- | ------ | ------------------------------------- |
| Dotfiles (all)       | ✓             | ✓           | ✓                | ✓          | ✓      | All dotfiles (per user preference)    |
| SSH config           | ✓             | ✓           | ✓                | ✓          | ✓      | SSH configuration                     |
| Git config           | ✓             | ✓           | ✓                | ✓          | ✓      | Git configuration                     |
| Zsh config           | ✓             | ✓           | ✓                | ✓          | ✓      | Zsh configuration                     |
| Tmux config          | ✓             | ✓           | ✓                | ✓          | ✓      | Tmux configuration                    |
| Vim config           | ✓             | ✓           | ✓                | ✓          | ✓      | Vim configuration                     |
| Alacritty config     | ✗             | ✗           | ✗                | ✗          | ✓      | Terminal config                       |
| Starship config      | ✗             | ✗           | ✗                | ✗          | ✓      | Prompt config (if Starship installed) |
| Sway config          | ✗             | ✗           | ✗                | ✗          | ✓      | Window manager config                 |
| Mako config          | ✗             | ✗           | ✗                | ✗          | ✓      | Notification config                   |
| i3status-rust config | ✗             | ✗           | ✗                | ✗          | ✓      | Status bar config                     |
| Ruff config          | ✗             | ✗           | ✗                | ✗          | ✓      | Python linter config                  |
| Zed config           | ✗             | ✗           | ✗                | ✗          | ✓      | Editor config                         |
| Cursor config        | ✗             | ✗           | ✗                | ✗          | ✓      | Editor config                         |
| AWS config           | ✗             | ✗           | ✗                | ✗          | ✓      | AWS configuration                     |
| GCP configs          | ✗             | ✗           | ✗                | ✗          | ✓      | GCP configurations                    |
