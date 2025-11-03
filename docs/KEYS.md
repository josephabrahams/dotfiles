# 🔑 Setting Up Git, SSH, and GPG

Quick guide for transferring keys from another computer.

## Git Local Config

```bash
cp /path/to/backup/.gitconfig.local ~/
chmod 644 ~/.gitconfig.local
```

## SSH Keys

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /path/to/backup/id_ed25519* ~/.ssh/
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## GPG Keys

### Export from old computer

```bash
gpg --list-secret-keys --keyid-format=long  # Get KEYID
gpg --export-secret-keys --armor <KEYID> > private.key
gpg --export --armor <KEYID> > public.key
```

### Import to new computer

```bash
# Import keys
gpg --import private.key
gpg --import public.key

# Trust key
gpg --edit-key <KEYID>
trust  # choose 5 = ultimate
save

# Configure Git (if not in .gitconfig.local)
git config --global user.signingkey <KEYID>
git config --global commit.gpgsign true
```
