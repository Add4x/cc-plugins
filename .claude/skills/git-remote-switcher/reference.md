# Git Remote Switcher - Reference

## Quick Commands

### Check Current Remote
```bash
git remote -v
```

### Switch to Personal GitHub
```bash
git remote set-url origin github.com-personal:Add4x/cc-plugins.git
git remote -v  # verify
```

### Switch to Work GHE
```bash
git remote set-url origin git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git
git remote -v  # verify
```

## Remote Details

### Personal GitHub
- **URL**: `github.com-personal:Add4x/cc-plugins.git`
- **Protocol**: SSH
- **Host**: github.com (using personal SSH key config)
- **Purpose**: Personal development, public sharing

### Work GHE (GitHub Enterprise)
- **URL**: `git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git`
- **Protocol**: SSH
- **Host**: ghe.coxautoinc.com
- **Purpose**: Work projects, internal collaboration

## SSH Configuration

Both remotes use SSH. Ensure your `~/.ssh/config` has entries for both:

```
# Personal GitHub
Host github.com-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal

# Work GHE
Host ghe.coxautoinc.com
    HostName ghe.coxautoinc.com
    User git
    IdentityFile ~/.ssh/id_rsa_work
```

## Workflow Tips

### When to Use Personal Remote
- Working on personal projects
- Creating public releases
- Sharing with external collaborators
- Personal experimentation

### When to Use Work Remote
- Corporate projects
- Team collaboration within Cox
- Work-related features
- Code reviews within organization

## Troubleshooting

### Permission Denied
If you get "Permission denied" after switching:
1. Verify SSH keys are added: `ssh-add -l`
2. Test connection: `ssh -T git@github.com` or `ssh -T git@ghe.coxautoinc.com`
3. Check SSH config: `cat ~/.ssh/config`

### Wrong Repository
If the remote doesn't match expectations:
1. Check: `git remote -v`
2. Verify you're in the correct local repository
3. Re-run the switch command

### Push/Pull Issues
After switching remotes:
- First push may need `-u` flag: `git push -u origin main`
- Branch tracking may need reset
- Pull requests go to the new remote's platform
