# Joseph does dotfiles

## Using Dotbot

This repo uses [Dotbot](https://github.com/anishathalye/dotbot) to symlink dotfiles from this directory to your home directory. Edit [install.conf.yaml](install.conf.yaml) to configure which files get symlinked where.

## Prerequisites

### Remap Caps Lock key to Control
Settings → Keyboard → Keyboard Shortcuts… → Modifier Keys → Apple Internal Keyboard

### Set up Git, SSH, and GPG
See [docs/KEYS.md](docs/KEYS.md) for a quick guide on transferring keys from another machine.

## Installation

### Download dotfiles
```bash
git clone git@github:josephabrahams/dotfiles ~/.dotfiles
```

### Create default folders and local overrides
```bash
scripts/bootstrap
```

### Install Homebrew formulae
```bash
scripts/brew
```

### Install dotfiles
```bash
scripts/dotbot
```

### Sensible macOS defaults
```bash
scripts/macos
```

### Install VS Code / Cursor extensions
```bash
scripts/vscode
```

### Install MacOS apps
Manually install MacOS apps from the checklist in [docs/APPS.md](docs/APPS.md).

## Acknowledgements

- Dotfiles based on [sensible macOS defaults](https://github.com/mathiasbynens/dotfiles) by Mathias Bynens.
- Colors are [Base16](https://github.com/chriskempson/base16) by Chris Kempson.
