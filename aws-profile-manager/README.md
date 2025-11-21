# AWS Profile Manager

Manage AWS credentials across multiple accounts using ALKS with named profiles for simultaneous access.

## Overview

AWS Profile Manager simplifies working with multiple AWS accounts by providing easy credential management through ALKS (Account Link Key Service). Instead of constantly overwriting a single default profile, it maintains separate named profiles for each environment, allowing you to work with multiple accounts simultaneously.

## Problem It Solves

Working with multiple AWS accounts typically involves:
- ❌ Manual credential rotation and copy-paste
- ❌ Forgetting which account is currently active
- ❌ Overwriting credentials when switching accounts
- ❌ Hard-to-remember account numbers
- ❌ Error-prone manual ALKS commands

AWS Profile Manager solves this with:
- ✅ Named profiles for each environment (all active simultaneously)
- ✅ One-command credential refresh
- ✅ Clear visibility of active profile and expiration
- ✅ Smart profile switching with safety warnings
- ✅ Quick reference for account mappings

## Features

- **Named Profile Management**: Create and maintain separate AWS profiles for each account
- **ALKS Integration**: Automated credential refresh via ALKS CLI
- **Multiple Active Profiles**: All accounts can have valid credentials simultaneously
- **Expiration Tracking**: Monitor credential expiration times
- **Smart Role Selection**: Automatically uses correct ALKS role per account
- **Safety First**: Production accounts use read-only roles by default
- **Quick Reference**: Never forget account numbers again

## Installation

### Prerequisites

1. **ALKS CLI** must be installed and configured
   ```bash
   npm install -g alks-cli
   alks profiles
   ```
   See: [ALKS CLI Documentation](https://github.com/Cox-Automotive/alks-cli)

2. **Add this marketplace** to Claude Code (if not already added)
   ```bash
   /plugin marketplace add /Users/shyju.viswambaran/backend/cc-plugins
   ```

### Install Plugin

```bash
# Install aws-profile-manager
/plugin install aws-profile-manager@development-plugins-marketplace

# Verify installation
/plugin list
```

## Configuration

The default configuration includes Vehicle Custody accounts:

| Profile | Account | Role | Access |
|---------|---------|------|--------|
| vc-nonprod | 536228277869 | ALKSAdmin | Full Admin |
| vc-sandbox | 240398786999 | ALKSReadOnly | Read Only |
| vc-preprod | 617995200517 | ALKSReadOnly | Read Only |
| vc-prod | 867828046507 | ALKSReadOnly | Read Only |

### Customizing for Your Accounts

Edit `agents/aws-profile-manager.md` to configure your own accounts:

```markdown
# Profile Configuration

The user has the following AWS profiles configured:

- **my-dev** (123456789012) - Development - Role: ALKSAdmin
- **my-prod** (987654321098) - Production - Role: ALKSReadOnly
```

Then update commands to reference your profile names.

## Commands

### `/aws-auth <profile>`

Refresh credentials for a specific profile.

**Usage:**
```bash
/aws-auth nonprod
/aws-auth sandbox
/aws-auth preprod
/aws-auth prod
```

**Example:**
```bash
$ /aws-auth nonprod

✓ Successfully refreshed credentials for vc-nonprod (536228277869)
  Role: ALKSAdmin
  Credentials will expire in ~12 hours

To use this profile: export AWS_PROFILE=vc-nonprod
```

---

### `/aws-auth-all`

Refresh credentials for all configured profiles at once.

**Usage:**
```bash
/aws-auth-all
```

**Example:**
```bash
$ /aws-auth-all

Refreshing all Vehicle Custody AWS profiles...

Profile       Account         Role            Status
---------------------------------------------------------
vc-nonprod    536228277869    ALKSAdmin       ✓ Success
vc-sandbox    240398786999    ALKSReadOnly    ✓ Success
vc-preprod    617995200517    ALKSReadOnly    ✓ Success
vc-prod       867828046507    ALKSReadOnly    ✓ Success

All credentials refreshed successfully!
Credentials will expire in ~12 hours.
```

**When to use:**
- Start of your workday to set up all profiles
- Before credentials expire
- When switching between multiple environments frequently

---

### `/aws-status`

Display status of all AWS profiles including expiration and current active profile.

**Usage:**
```bash
/aws-status
```

**Example:**
```bash
$ /aws-status

AWS Profile Status
==================

Current Active Profile: vc-nonprod (via AWS_PROFILE)

Profile       Account         Role            Status
-------------------------------------------------------------------------
vc-nonprod    536228277869    ALKSAdmin       ✓ Valid
vc-sandbox    240398786999    ALKSReadOnly    ✓ Valid
vc-preprod    617995200517    ALKSReadOnly    ⚠ Expired
vc-prod       867828046507    ALKSReadOnly    ✗ Missing

Tip: Use /aws-auth-all to refresh all profiles
```

---

### `/aws-switch <profile>`

Get command to switch active AWS profile.

**Usage:**
```bash
/aws-switch nonprod
/aws-switch prod
```

**Example:**
```bash
$ /aws-switch prod

⚠️  WARNING: You are switching to a PRODUCTION environment!
   This profile has READ-ONLY access.

Switching to vc-prod (Vehicle Custody Prod)
Account: 867828046507
Role: ALKSReadOnly

To activate this profile in your shell, run:

    export AWS_PROFILE=vc-prod

Verification:
    aws sts get-caller-identity
```

---

### `/aws-accounts`

Display reference table of all AWS accounts and profile mappings.

**Usage:**
```bash
/aws-accounts
```

**Example:**
```bash
$ /aws-accounts

Vehicle Custody AWS Accounts Reference
======================================

Profile       Account Number   Environment        Role            Access Level
--------------------------------------------------------------------------------
vc-nonprod    536228277869    Non Production     ALKSAdmin       Full Admin
vc-sandbox    240398786999    Sandbox/Prod       ALKSReadOnly    Read Only
vc-preprod    617995200517    Pre Production     ALKSReadOnly    Read Only
vc-prod       867828046507    Production         ALKSReadOnly    Read Only

Quick Commands
--------------
Refresh single profile:    /aws-auth <profile>
Refresh all profiles:      /aws-auth-all
Check profile status:      /aws-status
Switch active profile:     /aws-switch <profile>
```

## Workflows

### Morning Setup

Start your day by refreshing all credentials:

```bash
/aws-auth-all
```

All four profiles will have valid credentials for the next ~12 hours.

### Working Across Environments

Deploy to non-prod and verify in prod:

```bash
# Terminal 1: Deploy to non-prod
export AWS_PROFILE=vc-nonprod
cdk deploy

# Terminal 2: Verify in prod (readonly)
export AWS_PROFILE=vc-prod
aws cloudformation describe-stacks --stack-name my-stack
```

### Quick Status Check

Before running AWS commands, check which profile is active:

```bash
/aws-status
```

### Profile Switching

Switch between environments safely:

```bash
/aws-switch nonprod   # For development work
/aws-switch prod      # For readonly verification (with warning)
```

### Refreshing Expired Credentials

When credentials expire (after ~12 hours):

```bash
# Refresh single profile
/aws-auth nonprod

# Or refresh all at once
/aws-auth-all
```

## Security Best Practices

1. **Read-Only Production**: Production accounts use `ALKSReadOnly` role to prevent accidental modifications
2. **Named Profiles**: Explicit profile names reduce chance of running commands on wrong account
3. **Expiration Monitoring**: Regular status checks remind you to rotate credentials
4. **Role Segregation**: Non-prod uses admin role, prod uses readonly
5. **No Hardcoded Secrets**: All credentials are temporary and managed via ALKS

## Troubleshooting

### ALKS CLI Not Found

```bash
# Install ALKS CLI
npm install -g alks-cli

# Verify installation
alks --version
```

### Profile Not Found After Refresh

Check if ALKS command succeeded:
```bash
/aws-auth nonprod
# Look for error messages
```

Common issues:
- VPN not connected
- ALKS session expired (may need MFA)
- Invalid account/role combination

### Wrong Account Active

Verify current profile:
```bash
aws sts get-caller-identity
echo $AWS_PROFILE
```

Switch if needed:
```bash
export AWS_PROFILE=vc-nonprod
```

### Credentials Expired

Simply refresh:
```bash
/aws-auth <profile>
```

ALKS will generate new temporary credentials (~12 hour validity).

## Technical Details

### How It Works

1. **ALKS Integration**: Uses ALKS CLI to fetch temporary AWS credentials
2. **Credential Storage**: Updates `~/.aws/credentials` with named profiles
3. **Profile Format**: Standard AWS credentials file format
4. **Session Tokens**: Temporary credentials with ~12 hour expiration

### ALKS Command Format

```bash
alks sessions open \
  -a <account-number> \
  -r <role> \
  -o creds \
  --profile <profile-name> \
  -f \
  --newSession
```

### Credentials File

Location: `~/.aws/credentials`

Format:
```ini
[vc-nonprod]
aws_access_key_id=ASIA...
aws_secret_access_key=...
aws_session_token=IQoJb3JpZ2luX2VjE...
region=us-east-1
output=json
_internal_managed_by=alks
```

## FAQ

**Q: Can I use this with multiple organizations?**
A: Yes! Edit the agent configuration to add profiles for other accounts.

**Q: How long do credentials last?**
A: ALKS temporary credentials typically expire after 12 hours.

**Q: Can I modify production resources?**
A: No, production profiles use `ALKSReadOnly` role by design for safety.

**Q: Do I need to refresh all profiles?**
A: No, you can refresh individual profiles as needed with `/aws-auth <profile>`.

**Q: Will this affect my existing AWS profiles?**
A: The plugin only manages profiles it creates (vc-* prefixed). Your existing profiles remain untouched.

**Q: Can I use short names like "nonprod" instead of "vc-nonprod"?**
A: Yes! Commands accept both short names (nonprod) and full names (vc-nonprod).

## Contributing

To extend or customize this plugin:

1. Fork the plugin directory
2. Modify `agents/aws-profile-manager.md` for account configurations
3. Update command files in `commands/` for custom behaviors
4. Test thoroughly before deploying

## License

MIT

## Support

For issues or questions:
- Create an issue in the cc-plugins repository
- Check [ALKS CLI Documentation](https://github.com/Cox-Automotive/alks-cli)
- Refer to [Claude Code documentation](https://code.claude.com/docs)

---

**Version**: 1.0.0
**Author**: Shyju Viswambaran
**Keywords**: aws, alks, credentials, multi-account, devops
