# Personal Dotfiles

Optimized dotfiles managed with [chezmoi](https://chezmoi.io) for consistent development environments across multiple machines.

## Quick Start

Install and deploy dotfiles on a new machine:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ppetroskevicius/dotfiles
```

## What's Included

- **Shell environments**: Bash, Zsh with shared configuration
- **Editor configs**: Vim, Cursor, Zed with consistent formatting
- **Development tools**: Ruff (Python), unified formatting standards  
- **System configs**: Window managers (sway), terminal (alacritty), etc.
- **Security**: Proper permission handling for sensitive files

## Daily Usage

```bash
# Edit a config file
chezmoi edit ~/.zshrc

# Check what would change
chezmoi diff

# Apply changes
chezmoi apply

# Update from repository
chezmoi update
```

## Repository Structure

- `dot_*` - Standard config files (deployed with normal permissions)
- `private_dot_*` - Sensitive files (deployed with 0600 permissions)
- `dot_config/` - Files deployed to `~/.config/`
- `dot_config/shell/common.sh` - Shared shell environment

## Development

```bash
# Navigate to source directory
cd ~/.local/share/chezmoi

# Make changes and commit
git add .
git commit -m "Update config"
git push
```

For AI assistance with this repository, see `CLAUDE.md` for technical details and architecture.
