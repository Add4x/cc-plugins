---
name: git-remote-switcher
description: Switch git remote origin between personal GitHub (github.com-personal:Add4x/cc-plugins.git) and work GHE (git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git). Use when switching remotes, changing repositories, or swapping between personal and work repos.
allowed-tools: Bash
---

# Git Remote Switcher

Quickly and safely switch git remote origin between personal and work repositories.

## Supported Remotes

- **Personal GitHub**: `github.com-personal:Add4x/cc-plugins.git`
- **Work GHE**: `git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git`

## Instructions

When the user requests to switch git remotes:

### Step 1: Check Current Remote

Always verify the current remote configuration first:

```bash
git remote -v
```

Display the current remote to the user so they understand the current state.

### Step 2: Identify Target Remote

Determine which remote the user wants:
- Keywords: "personal", "github", "personal github" → Switch to personal
- Keywords: "work", "ghe", "cox", "enterprise" → Switch to work

If unclear, ask the user which remote they want.

### Step 3: Switch Remote

Use the appropriate command based on target:

**Switch to Personal:**
```bash
git remote set-url origin github.com-personal:Add4x/cc-plugins.git
```

**Switch to Work:**
```bash
git remote set-url origin git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git
```

### Step 4: Verify Change

Always verify the switch was successful:

```bash
git remote -v
```

### Step 5: Confirm with User

Display clear confirmation:
- Show what the remote was before
- Show what the remote is now
- Confirm the switch was successful

## Common Requests

Listen for these natural language requests:

- "Switch to personal repo"
- "Switch to work repo"
- "Change to my personal GitHub"
- "Use work GHE remote"
- "Switch to Cox remote"
- "Change back to personal"
- "What's my current remote?"
- "Show current git remote"

## Safety Checks

Before switching:
- ✓ Verify we're in a git repository
- ✓ Check current remote status
- ✓ Confirm target remote is valid
- ✓ Verify change after switching

## Example Interactions

### Example 1: Switch to Personal

```
User: "Switch my remote to personal GitHub"

1. Check current: git remote -v shows work GHE
2. Switch: git remote set-url origin github.com-personal:Add4x/cc-plugins.git
3. Verify: git remote -v shows personal GitHub
4. Confirm: "✓ Switched from work GHE to personal GitHub"
```

### Example 2: Switch to Work

```
User: "Change to work repo"

1. Check current: git remote -v shows personal GitHub
2. Switch: git remote set-url origin git@ghe.coxautoinc.com:Shyju-Viswambaran/cc-plugins.git
3. Verify: git remote -v shows work GHE
4. Confirm: "✓ Switched from personal GitHub to work GHE"
```

### Example 3: Check Status

```
User: "What's my current remote?"

1. Run: git remote -v
2. Display: Current remote configuration
3. Identify: "Currently using personal GitHub remote"
```

## Error Handling

Handle common errors gracefully:

- **Not in git repo**: "Error: Not in a git repository"
- **Remote switch fails**: Show error and suggest checking SSH keys/permissions
- **Unknown target**: Ask user to clarify "personal" or "work"

## Notes

- This Skill is specific to the cc-plugins repository
- Both remotes point to the same codebase (personal fork and work repo)
- Switching remotes doesn't affect local branches or commits
- After switching, pushes will go to the new remote
- SSH keys must be configured for both GitHub and GHE
