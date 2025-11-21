---
name: aws-status
description: Show status of all AWS profiles including expiration and current active profile
---

Display the status of all AWS profiles configured for Vehicle Custody accounts.

# Your Task

1. **Check AWS_PROFILE environment variable**: Show which profile is currently active

2. **Read ~/.aws/credentials**: Parse the credentials file to find all vc-* profiles

3. **Analyze each profile**:
   - Check if credentials exist
   - Determine if they are temporary (have session token) or permanent
   - For ALKS-managed profiles, note they are temporary

4. **Format and display status**:

```
AWS Profile Status
==================

Current Active Profile: vc-nonprod (via AWS_PROFILE)

Profile       Account         Role            Status          Notes
-------------------------------------------------------------------------
vc-nonprod    536228277869    ALKSAdmin       ✓ Valid         ALKS temporary credentials
vc-sandbox    240398786999    ALKSReadOnly    ✓ Valid         ALKS temporary credentials
vc-preprod    617995200517    ALKSReadOnly    ⚠ Expired       Run /aws-auth preprod
vc-prod       867828046507    ALKSReadOnly    ✗ Missing       Run /aws-auth prod

Tip: ALKS temporary credentials expire after ~12 hours
     Use /aws-auth-all to refresh all profiles
     Use /aws-switch <profile> to change active profile
```

# Status Indicators

- **✓ Valid**: Credentials exist and appear valid
- **⚠ Expired**: Profile exists but may be expired (check session token age)
- **✗ Missing**: Profile not found in credentials file
- **? Unknown**: Profile exists but status cannot be determined

# Current Profile Detection

Show which profile is currently active by checking:
1. AWS_PROFILE environment variable
2. If not set, note that "default" profile will be used

# Additional Information

If possible, estimate credential expiration by:
- Checking `_internal_managed_by=alks` marker
- Session tokens typically last 12 hours
- Provide guidance on when to refresh

# Edge Cases

- If ~/.aws/credentials doesn't exist, suggest running /aws-auth-all
- If no vc-* profiles found, suggest initial setup
- If credentials file has permission issues, report the error
