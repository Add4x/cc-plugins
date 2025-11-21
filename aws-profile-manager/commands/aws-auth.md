---
name: aws-auth
description: Refresh AWS credentials for a specific profile via ALKS
model: haiku
---

Refresh AWS temporary credentials for a specific profile using ALKS CLI.

The user wants to refresh credentials for: **{{arg}}**

# Available Profiles

- **nonprod** or **vc-nonprod**: Account 536228277869, Role: ALKSAdmin (Vehicle Custody Non Prod)
- **sandbox** or **vc-sandbox**: Account 240398786999, Role: ALKSReadOnly (Vehicle Custody Sandbox)
- **preprod** or **vc-preprod**: Account 617995200517, Role: ALKSReadOnly (Vehicle Custody Pre Prod)
- **prod** or **vc-prod**: Account 867828046507, Role: ALKSReadOnly (Vehicle Custody Prod)

# Your Task

1. **Validate the profile name**: Check if the requested profile exists (accept both short names like "nonprod" and full names like "vc-nonprod")

2. **Map to configuration**: Determine the account number and ALKS role for the profile

3. **Execute ALKS command**: Run the appropriate ALKS CLI command:
   ```bash
   alks sessions open -a <account-number> -r <role> -o creds --profile vc-<env> -f --newSession
   ```

4. **Report result**:
   - On success: Confirm credentials refreshed, show expiration time (~12 hours)
   - On failure: Show error message and suggest troubleshooting steps

# Example

If user requests: `/aws-auth nonprod`

Execute:
```bash
alks sessions open -a 536228277869 -r ALKSAdmin -o creds --profile vc-nonprod -f --newSession
```

Then confirm:
```
✓ Successfully refreshed credentials for vc-nonprod (536228277869)
  Role: ALKSAdmin
  Credentials will expire in ~12 hours

To use this profile: export AWS_PROFILE=vc-nonprod
```

# Error Handling

If no argument provided, show usage:
```
Usage: /aws-auth <profile>

Available profiles:
  nonprod, sandbox, preprod, prod

Example: /aws-auth nonprod
```

If ALKS command fails, provide helpful guidance based on the error.
