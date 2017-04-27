# (Open)SSH

An ssh client.

## Constructions

1. Install [OpenSSH](#Installation)

## Dotfiles

### Post Install Dotfiles

You should create local config.

```bash
$ mkdir -p ~/.ssh/ppkeys
$ mkdir -p ~/.ssh/conf.d
$ ssh-keygen -t ed25519 -f ~/.ssh/ppkeys/somehost_ed25519
$ editor ~/.ssh/conf.d/hosts.conf
Host somehost
  HostName somehost.example.com
  User     username
  Port     2223
  IdentityFile ~/.ssh/ppkeys/somehost_ed25519
```

