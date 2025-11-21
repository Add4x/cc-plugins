# Troubleshooting Guide

## Marketplace Issues

### Marketplace Not Found

**Symptom:**
```
Error: Marketplace 'development-plugins-marketplace' not found
```

**Possible Causes:**
- Marketplace not added to Claude Code
- Incorrect path provided
- marketplace.json file missing or invalid

**Solutions:**
1. Verify marketplace path exists:
   ```bash
   ls -la /Users/shyju.viswambaran/backend/cc-plugins/.claude-plugin/
   # Should show marketplace.json
   ```

2. Re-add marketplace with absolute path:
   ```bash
   /plugin marketplace add /Users/shyju.viswambaran/backend/cc-plugins
   ```

3. Check marketplace.json is valid JSON:
   ```bash
   cat .claude-plugin/marketplace.json | python -m json.tool
   # Should parse without errors
   ```

4. Refresh marketplace:
   ```bash
   /plugin marketplace refresh development-plugins-marketplace
   ```

---

### Plugin Not Listed in Marketplace

**Symptom:**
```
Error: Plugin 'plugin-name' not found in marketplace
```

**Possible Causes:**
- Plugin not registered in marketplace.json
- Marketplace not refreshed after adding plugin
- Plugin source path incorrect

**Solutions:**
1. Check marketplace.json includes the plugin:
   ```bash
   cat .claude-plugin/marketplace.json | grep "plugin-name"
   ```

2. Verify plugin directory exists:
   ```bash
   ls -la plugin-name/
   # Should show agents/, commands/, README.md
   ```

3. Refresh marketplace:
   ```bash
   /plugin marketplace refresh development-plugins-marketplace
   ```

4. If plugin is new, ensure it's added to marketplace.json:
   ```json
   {
     "plugins": [
       {
         "name": "plugin-name",
         "version": "1.0.0",
         "source": "./plugin-name",
         ...
       }
     ]
   }
   ```

---

### Marketplace Refresh Fails

**Symptom:**
```
Error: Failed to refresh marketplace
```

**Solutions:**
1. Check for JSON syntax errors in marketplace.json
2. Verify all plugin source paths exist
3. Check file permissions (should be readable)
4. Try removing and re-adding marketplace

---

## Plugin Installation Issues

### Plugin Installation Fails

**Symptom:**
```
Error: Failed to install plugin 'plugin-name'
```

**Possible Causes:**
- Invalid plugin structure
- Missing required files
- Permission issues

**Solutions:**
1. Verify plugin structure:
   ```bash
   ls -la plugin-name/
   # At minimum should have README.md
   # Typically has agents/ and/or commands/
   ```

2. Check plugin registration in marketplace.json

3. Try uninstalling first if it's a reinstall:
   ```bash
   /plugin uninstall plugin-name
   /plugin install plugin-name@development-plugins-marketplace
   ```

---

### Commands Not Available After Installation

**Symptom:**
- Plugin installed successfully
- Commands like `/context-save` not recognized

**Solutions:**
1. Verify plugin is installed:
   ```bash
   /plugin list
   # Should show the plugin
   ```

2. Check command files exist:
   ```bash
   ls -la plugin-name/commands/
   # Should show .md files for each command
   ```

3. Try refreshing Claude Code (restart if necessary)

4. Verify command names match file names:
   - File: `context-save.md` → Command: `/context-save`

---

## Context Management Issues

### No Context Found

**Symptom:**
```
⚠ No saved context found in .claude-context/
```

**Cause:** No context has been saved yet

**Solution:**
```bash
# Run context-save first
/context-save

# Then restore
/context-restore
```

---

### Context Save Creates No Files

**Symptom:**
- `/context-save` completes
- No `.claude-context/` directory created

**Possible Causes:**
- Write permission issues
- Command execution error
- Wrong directory

**Solutions:**
1. Check current directory:
   ```bash
   pwd
   # Should be in your project root
   ```

2. Check write permissions:
   ```bash
   ls -la .
   # Verify you can write to current directory
   ```

3. Try creating directory manually:
   ```bash
   mkdir .claude-context
   # If this fails, permission issue confirmed
   ```

4. Look for error messages in command output

---

### Outdated Context Warning

**Symptom:**
```
⚠ Context is 7 days old (saved: 2025-11-14)
→ Consider running /context-save to refresh
```

**Cause:** Context was saved a while ago and may not reflect current codebase

**Solution:**
```bash
# Refresh context
/context-save

# Then restore updated context
/context-restore
```

**Best Practice:** Run `/context-save` after major changes

---

### Token Budget Exceeded

**Symptom:**
```
⚠ Full context requires 15,000 tokens but budget is 8,192
→ Loading prioritized subset
```

**Cause:** Saved context is too large for current token budget

**Solutions:**
1. Use selective restoration:
   ```bash
   /context-restore with focus on architecture
   /context-restore with focus on testing
   ```

2. Increase token budget:
   ```bash
   /context-restore with 16384 token budget
   ```

3. Use incremental mode:
   ```bash
   /context-restore incremental mode
   ```

---

### Corrupted Context

**Symptom:**
```
✗ Context files are corrupted or incomplete
```

**Solutions:**
1. Delete and regenerate:
   ```bash
   rm -rf .claude-context
   /context-save
   ```

2. Check for incomplete writes (disk full, interrupted save)

3. Verify JSON files are valid:
   ```bash
   cat .claude-context/metadata.json | python -m json.tool
   ```

---

## AWS Profile Manager Issues

### ALKS CLI Not Found

**Symptom:**
```
Error: alks: command not found
```

**Cause:** ALKS CLI not installed or not in PATH

**Solutions:**
1. Install ALKS CLI:
   ```bash
   # Follow installation instructions at:
   # https://github.com/Cox-Automotive/alks-cli
   ```

2. Verify installation:
   ```bash
   alks --version
   ```

3. Check PATH:
   ```bash
   echo $PATH
   # Verify directory containing 'alks' is in PATH
   ```

---

### ALKS Authentication Failed

**Symptom:**
```
Error: ALKS authentication failed
```

**Possible Causes:**
- Not logged into VPN
- ALKS session expired
- Invalid credentials
- MFA required

**Solutions:**
1. Verify VPN connection

2. Re-authenticate with ALKS:
   ```bash
   alks developer login
   ```

3. Complete MFA if prompted

4. Try refreshing credentials again:
   ```bash
   /aws-auth nonprod
   ```

---

### Invalid Profile Name

**Symptom:**
```
Error: Unknown profile 'xyz'
→ Available profiles: nonprod, sandbox, preprod, prod
```

**Cause:** Profile name doesn't match configured profiles

**Solutions:**
1. Use correct profile name:
   ```bash
   /aws-auth nonprod  # Correct
   /aws-auth dev      # Incorrect
   ```

2. View available profiles:
   ```bash
   /aws-accounts
   ```

3. Accepted names:
   - `nonprod` or `vc-nonprod`
   - `sandbox` or `vc-sandbox`
   - `preprod` or `vc-preprod`
   - `prod` or `vc-prod`

---

### Credentials Not Working After Refresh

**Symptom:**
- `/aws-auth` reports success
- AWS CLI commands still fail with authentication errors

**Possible Causes:**
- Wrong profile selected
- Credentials not written to ~/.aws/credentials
- AWS_PROFILE not set

**Solutions:**
1. Verify profile in credentials file:
   ```bash
   cat ~/.aws/credentials | grep -A 5 "\[vc-nonprod\]"
   ```

2. Check AWS_PROFILE:
   ```bash
   echo $AWS_PROFILE
   ```

3. Set profile explicitly:
   ```bash
   /aws-switch nonprod
   # Or
   export AWS_PROFILE=vc-nonprod
   ```

4. Test with AWS CLI:
   ```bash
   aws sts get-caller-identity --profile vc-nonprod
   ```

---

### Permission Denied on ~/.aws/credentials

**Symptom:**
```
Error: Permission denied: ~/.aws/credentials
```

**Solutions:**
1. Check file permissions:
   ```bash
   ls -la ~/.aws/credentials
   ```

2. Fix permissions:
   ```bash
   chmod 600 ~/.aws/credentials
   ```

3. Verify directory permissions:
   ```bash
   ls -la ~/.aws/
   chmod 700 ~/.aws/
   ```

---

### All Profiles Fail to Refresh

**Symptom:**
- `/aws-auth-all` runs
- All profiles report failures

**Possible Causes:**
- ALKS service down
- Network connectivity issue
- VPN not connected
- ALKS authentication expired

**Solutions:**
1. Check VPN connection

2. Test ALKS CLI directly:
   ```bash
   alks sessions list
   ```

3. Re-authenticate:
   ```bash
   alks developer login
   ```

4. Try single profile first:
   ```bash
   /aws-auth nonprod
   ```

5. Check for service status announcements

---

## Permission Issues

### Operation Requires User Permission

**Symptom:**
```
⚠ This operation requires user permission
Do you want to allow: [Operation description]?
```

**Cause:** Operation not in `allow` list in settings.local.json

**Solutions:**
1. Approve manually (for one-time operations)

2. Add to allow list (for trusted operations):
   - Edit `.claude/settings.local.json`
   - Add operation pattern to `allow` array
   - Example: `"Bash(git commit:*)"`

3. Review permission configuration:
   ```bash
   cat .claude/settings.local.json
   ```

---

### Permission Denied for File Operations

**Symptom:**
```
Error: Permission denied when writing file
```

**Solutions:**
1. Check file permissions:
   ```bash
   ls -la <file-path>
   ```

2. Verify directory permissions:
   ```bash
   ls -la <directory>
   ```

3. Run with appropriate permissions (if necessary)

---

## Git Integration Issues

### Git Commands Fail

**Symptom:**
```
Error: git command failed
```

**Solutions:**
1. Verify git is installed:
   ```bash
   git --version
   ```

2. Check repository status:
   ```bash
   git status
   ```

3. Verify you're in a git repository:
   ```bash
   ls -la .git
   ```

4. Check git configuration:
   ```bash
   git config --list
   ```

---

### Context Save Includes Sensitive Data

**Symptom:**
- Reviewing `.claude-context/` files
- Notice API keys or credentials in captured data

**Immediate Action:**
1. Delete sensitive data from context files

2. Run context-save again with corrections

3. Never commit sensitive context to git

**Prevention:**
1. Review `.claude-context/` before committing

2. Add to `.gitignore`:
   ```bash
   echo ".claude-context/" >> .gitignore
   ```

3. Use pattern-only capture (context-save excludes actual values)

---

## General Debugging

### Enable Verbose Output

Check command output carefully for error details. Most commands provide clear error messages and suggestions.

### Check Claude Code Logs

If available, check Claude Code logs for detailed error information.

### Verify File Structure

```bash
# Check plugin structure
find plugin-name -type f

# Check context structure
find .claude-context -type f

# Check marketplace structure
ls -la .claude-plugin/
```

### Test Individual Components

1. Test marketplace:
   ```bash
   /plugin marketplace list
   ```

2. Test plugin installation:
   ```bash
   /plugin list
   ```

3. Test commands:
   ```bash
   /command-name
   ```

### Common Patterns

Most issues fall into these categories:
1. **Path Issues**: Wrong paths or missing files
2. **Permission Issues**: File or directory permissions
3. **Configuration Issues**: Invalid JSON or missing configuration
4. **External Dependencies**: Missing tools (ALKS CLI, Git)
5. **Network Issues**: VPN, ALKS service, authentication

---

## Getting Help

### Self-Service Resources

1. **Plugin Documentation**: Check plugin README.md files
2. **Command Help**: Commands include usage instructions
3. **This Guide**: Review relevant section above

### Diagnostic Information to Collect

When reporting issues, include:

```bash
# Claude Code version
/help

# Plugin list
/plugin list

# Marketplace list
/plugin marketplace list

# File structure
ls -la .claude-plugin/
ls -la plugin-name/

# Git status (if relevant)
git status

# Error message (exact text)
[Copy full error message]
```

### Contact Support

- **Repository Issues**: Create issue in Git repository
- **Plugin-Specific**: Check plugin README for support contact
- **Marketplace**: Contact marketplace maintainer

---

## Prevention Best Practices

### Regular Maintenance

1. **Keep context fresh**:
   ```bash
   # Run after significant changes
   /context-save
   ```

2. **Refresh credentials before expiry**:
   ```bash
   # Run every morning or before expiry
   /aws-auth-all
   ```

3. **Update marketplace**:
   ```bash
   # Pull latest changes
   git pull origin main

   # Refresh in Claude Code
   /plugin marketplace refresh development-plugins-marketplace
   ```

### Configuration Backups

Backup your configuration:
```bash
# Backup settings
cp .claude/settings.local.json .claude/settings.local.json.backup

# Backup marketplace config
cp .claude-plugin/marketplace.json .claude-plugin/marketplace.json.backup
```

### Monitoring

1. **Check AWS credential expiration**:
   ```bash
   /aws-status
   ```

2. **Verify plugin functionality**:
   - Test commands periodically
   - Verify expected behavior

3. **Review context freshness**:
   - Check context age when restoring
   - Refresh if outdated

---

## FAQ

### Q: Can I use multiple marketplaces?
**A:** Yes, add multiple marketplaces with different paths.

### Q: Can plugins depend on each other?
**A:** Currently no, plugins are independent.

### Q: How do I update a plugin?
**A:** Uninstall old version, pull updates, refresh marketplace, reinstall.

### Q: Can I customize plugin behavior?
**A:** Yes, edit plugin markdown files and refresh marketplace.

### Q: Is context saved securely?
**A:** Context should not contain sensitive values. Review before committing to git.

### Q: What if ALKS credentials expire during use?
**A:** Run `/aws-auth` or `/aws-auth-all` to refresh.

### Q: Can I add custom AWS profiles?
**A:** Yes, edit `aws-profile-manager/agents/aws-profile-manager.md` configuration.

### Q: Why does context-restore not load all information?
**A:** Token budget limits may apply. Use selective restoration or increase budget.

---

**Still Having Issues?**

If this guide doesn't resolve your issue:
1. Check plugin-specific README files
2. Review command documentation
3. Create an issue with diagnostic information
4. Contact marketplace maintainer
