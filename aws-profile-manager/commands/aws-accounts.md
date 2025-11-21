---
name: aws-accounts
description: Display reference table of all AWS accounts and profile mappings
model: haiku
---

Display a quick reference table of all configured AWS accounts and their profile mappings.

# Your Task

Show a comprehensive table with all Vehicle Custody AWS accounts:

```
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

Examples
--------
Refresh non-prod:          /aws-auth nonprod
Switch to prod (readonly): /aws-switch prod
Check all statuses:        /aws-status

Notes
-----
• ALKS temporary credentials expire after ~12 hours
• Production environments have READ-ONLY access for safety
• Non-prod has full admin access for development/testing
• Use 'vc-' prefix or short names (nonprod, sandbox, preprod, prod)

Direct ALKS Commands (if needed)
---------------------------------
alks sessions open -a 536228277869 -r ALKSAdmin -o creds --profile vc-nonprod -f --newSession
alks sessions open -a 240398786999 -r ALKSReadOnly -o creds --profile vc-sandbox -f --newSession
alks sessions open -a 617995200517 -r ALKSReadOnly -o creds --profile vc-preprod -f --newSession
alks sessions open -a 867828046507 -r ALKSReadOnly -o creds --profile vc-prod -f --newSession
```

# Additional Information

Provide helpful context:
- Credentials file location: `~/.aws/credentials`
- ALKS CLI documentation: https://github.com/Cox-Automotive/alks-cli
- AWS profile usage: `aws <command> --profile vc-nonprod` or `export AWS_PROFILE=vc-nonprod`

# Purpose

This command serves as a quick reference when:
- You forget which account number corresponds to which environment
- You need to copy/paste account numbers for manual operations
- You want to see all available commands at a glance
- You're onboarding a new team member and need to share account info
