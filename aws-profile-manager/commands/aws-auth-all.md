---
name: aws-auth-all
description: Refresh AWS credentials for all configured profiles via ALKS
---

Refresh AWS temporary credentials for ALL configured profiles using ALKS CLI.

This command will sequentially refresh credentials for all four Vehicle Custody profiles.

# Profiles to Refresh

1. **vc-nonprod**: Account 536228277869, Role: ALKSAdmin
2. **vc-sandbox**: Account 240398786999, Role: ALKSReadOnly
3. **vc-preprod**: Account 617995200517, Role: ALKSReadOnly
4. **vc-prod**: Account 867828046507, Role: ALKSReadOnly

# Your Task

Execute ALKS commands for each profile in sequence:

```bash
alks sessions open -a 536228277869 -r ALKSAdmin -o creds --profile vc-nonprod -f --newSession
alks sessions open -a 240398786999 -r ALKSReadOnly -o creds --profile vc-sandbox -f --newSession
alks sessions open -a 617995200517 -r ALKSReadOnly -o creds --profile vc-preprod -f --newSession
alks sessions open -a 867828046507 -r ALKSReadOnly -o creds --profile vc-prod -f --newSession
```

# Output Format

Provide a summary table showing the result for each profile:

```
Refreshing all Vehicle Custody AWS profiles...

Profile       Account         Role            Status
---------------------------------------------------------
vc-nonprod    536228277869    ALKSAdmin       ✓ Success
vc-sandbox    240398786999    ALKSReadOnly    ✓ Success
vc-preprod    617995200517    ALKSReadOnly    ✓ Success
vc-prod       867828046507    ALKSReadOnly    ✓ Success

All credentials refreshed successfully!
Credentials will expire in ~12 hours.

To use a profile: export AWS_PROFILE=<profile-name>
Or use: /aws-switch <profile>
```

# Error Handling

If any profile fails:
1. Continue with remaining profiles
2. Mark failed profiles in the summary
3. Show error details for failed profiles
4. Suggest troubleshooting steps

# Important Notes

- This operation may take 30-60 seconds to complete all profiles
- Requires valid ALKS authentication
- May prompt for MFA if session has expired
- All existing credentials for these profiles will be overwritten
