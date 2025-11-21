---
name: aws-switch
description: Switch active AWS profile by setting AWS_PROFILE environment variable
model: haiku
---

Switch the active AWS profile by setting the AWS_PROFILE environment variable.

The user wants to switch to: **{{arg}}**

# Available Profiles

- **nonprod** or **vc-nonprod**: Vehicle Custody Non Prod (ALKSAdmin)
- **sandbox** or **vc-sandbox**: Vehicle Custody Sandbox (ALKSReadOnly)
- **preprod** or **vc-preprod**: Vehicle Custody Pre Prod (ALKSReadOnly)
- **prod** or **vc-prod**: Vehicle Custody Prod (ALKSReadOnly)

# Your Task

1. **Validate the profile name**: Check if the requested profile exists (accept both short names and full vc-* names)

2. **Verify profile exists**: Check that the profile is configured in ~/.aws/credentials

3. **Provide export command**: Give the user the exact command to run in their shell

4. **Important Note**: Explain that Claude Code cannot directly modify the user's shell environment, so they need to run the command themselves

# Output Format

If user requests: `/aws-switch nonprod`

Respond with:

```
Switching to vc-nonprod (Vehicle Custody Non Prod)
Account: 536228277869
Role: ALKSAdmin

To activate this profile in your shell, run:

    export AWS_PROFILE=vc-nonprod

Or add to your current shell session:

    ~/.zshrc: Add this line temporarily or use:
    echo "export AWS_PROFILE=vc-nonprod" >> ~/.zshrc && source ~/.zshrc

Verification:
    aws sts get-caller-identity

This will show you're using the correct account.
```

# Special Warnings

**For prod/preprod profiles**, add a warning:

```
⚠️  WARNING: You are switching to a PRODUCTION environment!
   This profile has READ-ONLY access.
   Exercise caution when running commands.
```

# Error Handling

If no argument provided:
```
Usage: /aws-switch <profile>

Available profiles:
  nonprod, sandbox, preprod, prod

Example: /aws-switch nonprod
```

If profile not found in credentials file:
```
Error: Profile 'vc-nonprod' not found in ~/.aws/credentials

Run this command to create the profile:
  /aws-auth nonprod
```

# Additional Tips

Suggest useful follow-up commands:
- `aws sts get-caller-identity` - Verify current identity
- `aws configure list` - Show current configuration
- `/aws-status` - Check all profile statuses
