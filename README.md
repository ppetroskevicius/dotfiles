# Chezmoi Dotfiles Repository

This repository contains dotfiles managed by chezmoi, including shell configurations (bash, zsh), editor configs (vim, zed, Cursor), window manager settings (sway), and various application configurations. Files with the `private_` prefix are deployed with restrictive permissions (0600) but are stored in plain text in this repository.

## Installation on a New Machine

1. Install chezmoi:

   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ppetroskevicius/dotfiles
   ```

   Or if you already have chezmoi installed:

   ```bash
   chezmoi init --apply ppetroskevicius/dotfiles
   ```

2. This will clone the repository and apply all dotfiles to your home directory.

## Editing Existing Dotfiles

**Recommended method:** Edit the source files in the chezmoi repository, then apply:

```bash
cd ~/.local/share/chezmoi
# Edit the source file (e.g., private_dot_zshrc)
vim private_dot_zshrc
# Apply changes to your home directory
chezmoi apply
```

**Alternative method:** Use chezmoi's edit command:

```bash
chezmoi edit ~/.zshrc
# This opens the source file for editing
# Changes are automatically applied when you save
```

## Adding New Dotfiles

1. Add an existing file to chezmoi:

   ```bash
   chezmoi add ~/.mynewconfig
   ```

2. For files that should have restrictive permissions, use the `private_` prefix:

   ```bash
   chezmoi add --autotemplate ~/.mynewconfig
   # Then rename if needed: mv dot_mynewconfig private_dot_mynewconfig
   ```

3. Commit and push:
   ```bash
   cd ~/.local/share/chezmoi
   # or
   chezmoi cd
   git add .
   git commit -m "Add new dotfile"
   git push
   ```

## Updating Local Dotfiles from Remote

1. Pull the latest changes from the repository:

   ```bash
   cd ~/.local/share/chezmoi
   git pull
   ```

2. Apply the updates to your home directory:

   ```bash
   chezmoi apply
   ```

   Or combine both steps:

   ```bash
   chezmoi update
   ```

## Important Notes

- **File Permissions:** Files with `private_` prefix are deployed with `0600` permissions (owner read/write only) but are stored in plain text in the repository. For actual encryption, use the `encrypted_` prefix with `chezmoi encrypt`.

- **Checking Status:** Use `chezmoi status` to see which files differ between the source and your home directory.

- **Viewing Differences:** Use `chezmoi diff` to see what changes would be applied.

- **Viewing Managed Files:** Use `chezmoi managed` to see all files currently managed by chezmoi.

- **Viewing Unmanaged Files:** Use `chezmoi unmanaged` to see files in your home directory that are not managed by chezmoi.

- **Repository Location:** The chezmoi source directory is at `~/.local/share/chezmoi`. This is a git repository that tracks all your dotfile sources.

- **Remote Repository:** This repository is hosted at `ssh://git@github.com/ppetroskevicius/dotfiles.git`
