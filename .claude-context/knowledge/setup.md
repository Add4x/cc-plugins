# Setup Guide

## Prerequisites

Before using this marketplace, ensure you have:

1. **Claude Code** installed
   - Download from: https://code.claude.com
   - Verify installation: Launch Claude Code

2. **Git** installed
   - Required for version control
   - Verify: `git --version`

3. **ALKS CLI** (for aws-profile-manager plugin)
   - Required only if using AWS credential management
   - Installation: https://github.com/Cox-Automotive/alks-cli
   - Verify: `alks --version`

## Installation

### Step 1: Clone or Access the Marketplace

If you haven't already, get access to the marketplace repository:

```bash
# Clone the repository (if not already available)
git clone git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git

# Or navigate to existing local copy
cd /Users/shyju.viswambaran/backend/cc-plugins
```

### Step 2: Add Marketplace to Claude Code

```bash
# Add the marketplace (use absolute path)
/plugin marketplace add /Users/shyju.viswambaran/backend/cc-plugins

# Verify marketplace was added
/plugin marketplace list
# Should show: development-plugins-marketplace
```

### Step 3: Browse Available Plugins

```bash
# See all plugins in the marketplace
/plugin marketplace search development-plugins-marketplace
```

### Step 4: Install Desired Plugins

#### Install Context Management Plugin

```bash
# Install context-management plugin
/plugin install context-management@development-plugins-marketplace

# Verify installation
/plugin list
```

**Available Commands:**
- `/context-save` - Capture project context
- `/context-restore` - Restore saved context

#### Install AWS Profile Manager Plugin

**Note:** AWS Profile Manager is currently in development. Once added to marketplace.json:

```bash
# Install aws-profile-manager plugin
/plugin install aws-profile-manager@development-plugins-marketplace

# Verify installation
/plugin list
```

**Available Commands:**
- `/aws-auth <profile>` - Refresh single profile credentials
- `/aws-auth-all` - Refresh all profiles
- `/aws-status` - Show profile status
- `/aws-switch <profile>` - Switch active profile
- `/aws-accounts` - List configured accounts

### Step 5: Verify Installation

```bash
# List installed plugins
/plugin list

# Try a command (example with context-management)
/context-save

# Or for AWS (if installed)
/aws-status
```

## Configuration

### Claude Code Permissions

The marketplace includes default permissions in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "WebFetch(domain:raw.githubusercontent.com)",
      "WebFetch(domain:api.github.com)",
      "Bash(tree:*)",
      "Bash(curl:*)",
      "Bash(git commit:*)"
    ],
    "deny": [],
    "ask": []
  }
}
```

**Customization:**
- Add operations to `allow` for automatic execution
- Add operations to `deny` to block them
- Add operations to `ask` to require user confirmation

### Context Management Configuration

No additional configuration required. The plugin works out-of-the-box.

**Optional:** Add `.claude-context/` to your project's `.gitignore` if the context contains sensitive project information.

### AWS Profile Manager Configuration

The plugin comes with pre-configured Vehicle Custody accounts:

- **vc-nonprod** (536228277869) - ALKSAdmin
- **vc-sandbox** (240398786999) - ALKSReadOnly
- **vc-preprod** (617995200517) - ALKSReadOnly
- **vc-prod** (867828046507) - ALKSReadOnly

**To customize for your accounts:**
1. Edit `aws-profile-manager/agents/aws-profile-manager.md`
2. Update the profile configuration section
3. Modify commands to reference your accounts
4. Refresh marketplace: `/plugin marketplace refresh development-plugins-marketplace`

## Updating Plugins

### Update Marketplace

```bash
# Pull latest changes from repository
cd /Users/shyju.viswambaran/backend/cc-plugins
git pull origin main

# Refresh marketplace in Claude Code
/plugin marketplace refresh development-plugins-marketplace
```

### Reinstall Plugin (if needed)

```bash
# Uninstall old version
/plugin uninstall plugin-name

# Install new version
/plugin install plugin-name@development-plugins-marketplace
```

## First-Time Usage

### Using Context Management

```bash
# Navigate to your project
cd /path/to/your/project

# Capture initial context
/context-save

# Review generated context
ls .claude-context/

# In future sessions, restore context
/context-restore
```

### Using AWS Profile Manager

```bash
# Check current profile status
/aws-status

# Refresh credentials for a profile
/aws-auth nonprod

# Or refresh all profiles at once
/aws-auth-all

# Switch to a different profile
/aws-switch sandbox

# View account reference
/aws-accounts
```

## Verification Steps

### 1. Verify Marketplace

```bash
/plugin marketplace list
# Expected: development-plugins-marketplace listed
```

### 2. Verify Plugin Installation

```bash
/plugin list
# Expected: Installed plugins listed with versions
```

### 3. Verify Commands Available

```bash
# Try autocomplete
/context<TAB>
# Should show: /context-save, /context-restore

/aws<TAB>
# Should show: /aws-auth, /aws-auth-all, /aws-status, etc.
```

### 4. Test Command Execution

```bash
# Test context management
/context-save
# Should analyze project and create .claude-context/

# Test AWS (if applicable)
/aws-status
# Should show profile status table
```

## Common Setup Issues

### Issue: Marketplace Not Found

**Symptom:**
```
Error: Marketplace not found
```

**Solution:**
1. Verify path is correct and absolute
2. Check marketplace.json exists at `.claude-plugin/marketplace.json`
3. Try refreshing: `/plugin marketplace refresh development-plugins-marketplace`

### Issue: Plugin Not Found in Marketplace

**Symptom:**
```
Error: Plugin 'plugin-name' not found in marketplace
```

**Solution:**
1. Check plugin is listed in `.claude-plugin/marketplace.json`
2. Refresh marketplace: `/plugin marketplace refresh development-plugins-marketplace`
3. Verify plugin directory exists

### Issue: ALKS CLI Not Found

**Symptom:**
```
Error: alks: command not found
```

**Solution:**
1. Install ALKS CLI: https://github.com/Cox-Automotive/alks-cli
2. Verify installation: `alks --version`
3. Ensure ALKS is in your PATH

### Issue: Permission Denied

**Symptom:**
```
Error: Operation requires user permission
```

**Solution:**
1. Check `.claude/settings.local.json` for permission configuration
2. Add operation to `allow` list if trusted
3. Or approve manually when prompted

### Issue: Context Directory Not Created

**Symptom:**
```
/context-save completes but no .claude-context/ directory
```

**Solution:**
1. Check write permissions in current directory
2. Verify command completed without errors
3. Look for error messages in command output

## Next Steps

After setup:

1. **Read Plugin Documentation**
   - `context-management/README.md`
   - `aws-profile-manager/README.md` (when available)

2. **Try Example Workflows**
   - Capture context for an existing project
   - Refresh AWS credentials
   - Practice switching between profiles

3. **Customize Configuration**
   - Adjust permissions in `.claude/settings.local.json`
   - Modify AWS account configuration if needed

4. **Contribute**
   - Create new plugins
   - Enhance existing plugins
   - Share improvements via pull requests

## Support

For issues or questions:
- Check the troubleshooting guide: `knowledge/troubleshooting.md`
- Review plugin-specific documentation
- Create an issue in the repository
- Contact marketplace maintainer

## Quick Reference

### Essential Commands

```bash
# Marketplace Management
/plugin marketplace add <path>
/plugin marketplace list
/plugin marketplace refresh <name>

# Plugin Management
/plugin install <plugin>@<marketplace>
/plugin uninstall <plugin>
/plugin list
/plugin info <plugin>

# Context Management
/context-save
/context-restore

# AWS Management (if installed)
/aws-auth <profile>
/aws-auth-all
/aws-status
/aws-switch <profile>
/aws-accounts
```

### File Locations

- **Marketplace Config**: `.claude-plugin/marketplace.json`
- **Claude Settings**: `.claude/settings.local.json`
- **Saved Context**: `.claude-context/` (in project directory)
- **AWS Credentials**: `~/.aws/credentials`
- **Plugin Directories**: `context-management/`, `aws-profile-manager/`

## Advanced Setup

### Multiple Marketplaces

You can add multiple marketplaces:

```bash
/plugin marketplace add /path/to/marketplace1
/plugin marketplace add /path/to/marketplace2
```

### Custom Plugin Development

To create your own plugin:

1. Create plugin directory: `mkdir my-plugin`
2. Add agents and commands as needed
3. Create README.md
4. Register in marketplace.json
5. Refresh marketplace
6. Install and test

See `README.md` in the root directory for detailed plugin development guidelines.

### Automated Setup Script

For team distribution, create a setup script:

```bash
#!/bin/bash
# setup-claude-plugins.sh

MARKETPLACE_PATH="/path/to/cc-plugins"

echo "Setting up Claude Code plugins..."

# Add marketplace
echo "Adding marketplace..."
# Note: This would need to be done manually in Claude Code

echo "Marketplace path: $MARKETPLACE_PATH"
echo "Next steps:"
echo "1. Launch Claude Code"
echo "2. Run: /plugin marketplace add $MARKETPLACE_PATH"
echo "3. Run: /plugin install context-management@development-plugins-marketplace"
echo "4. Verify with: /plugin list"
```

## Environment-Specific Setup

### Development Environment

```bash
# Clone repository for development
git clone git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git
cd cc-plugins

# Add as local marketplace
/plugin marketplace add $(pwd)

# Install plugins
/plugin install context-management@development-plugins-marketplace
```

### Production Environment

For teams, consider:
1. Committing `.claude-context/` for shared knowledge (if not sensitive)
2. Documenting team-specific AWS profiles
3. Standardizing permission configurations
4. Creating onboarding documentation

---

**Setup Complete!** You're ready to use the Claude Code plugin marketplace.
