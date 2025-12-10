---
description: Restore saved project context with semantic awareness and intelligent prioritization
---

# Context Restore Command

You are a **Context Restoration Specialist** focused on intelligent recovery and reconstruction of project knowledge, enabling seamless continuation of work across sessions.

## Objective

Restore previously saved context to enable:
- Rapid project resumption after breaks
- Cross-session knowledge continuity
- Multi-agent workflow coordination
- Architectural pattern recall
- Onboarding acceleration

## Restoration Process

### 1. Context Source Discovery and Immediate Staleness Check

**IMPORTANT**: Before loading any context, immediately check for staleness and prompt user if needed.

#### Step 1: Verify Context Exists

```bash
# Check if context directory and metadata exist
if [ ! -f ".claude-context/metadata.json" ]; then
  echo "⚠ No saved context found in .claude-context/"
  echo "→ Run /context-save first to capture project context"
  exit 1
fi

# Validate metadata is valid JSON
if ! jq empty .claude-context/metadata.json 2>/dev/null; then
  echo "✗ Context metadata is corrupted"
  echo "→ Delete .claude-context/ and run /context-save to regenerate"
  exit 1
fi
```

#### Step 2: Calculate Staleness Metrics

```bash
# Load metadata
SAVE_TIMESTAMP=$(jq -r '.timestamp' .claude-context/metadata.json)
SAVED_COMMIT=$(jq -r '.git.commit' .claude-context/metadata.json)
SAVED_VERSION=$(jq -r '.version // "1.0.0"' .claude-context/metadata.json)

# Get current state
CURRENT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "no-git")
CURRENT_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Calculate time-based staleness
SAVE_DATE=$(date -d "$SAVE_TIMESTAMP" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%SZ" "$SAVE_TIMESTAMP" +%s)
CURRENT_DATE=$(date +%s)
SECONDS_SINCE=$((CURRENT_DATE - SAVE_DATE))
HOURS_SINCE=$((SECONDS_SINCE / 3600))
DAYS_SINCE=$((HOURS_SINCE / 24))

# Calculate commit-based staleness (if git available)
if [ "$CURRENT_COMMIT" != "no-git" ] && [ "$SAVED_COMMIT" != "null" ]; then
  COMMITS_SINCE=$(git rev-list ${SAVED_COMMIT}..${CURRENT_COMMIT} --count 2>/dev/null || echo "0")
  CHANGED_FILES=$(git diff --name-only ${SAVED_COMMIT}..${CURRENT_COMMIT} 2>/dev/null | wc -l)
else
  COMMITS_SINCE="unknown"
  CHANGED_FILES="unknown"
fi

# Get staleness thresholds from metadata (with defaults)
WARN_HOURS=$(jq -r '.staleness.thresholds.warnAfterHours // 24' .claude-context/metadata.json)
WARN_COMMITS=$(jq -r '.staleness.thresholds.warnAfterCommits // 5' .claude-context/metadata.json)
AUTO_PROMPT=$(jq -r '.staleness.autoPrompt // true' .claude-context/metadata.json)
```

#### Step 3: Determine Staleness Level

```bash
IS_STALE=false
STALENESS_LEVEL="fresh"

# Check if exceeds thresholds
if [ "$COMMITS_SINCE" != "unknown" ] && [ $COMMITS_SINCE -gt $WARN_COMMITS ]; then
  IS_STALE=true
fi

if [ $HOURS_SINCE -gt $WARN_HOURS ]; then
  IS_STALE=true
fi

# Classify staleness severity
if [ "$IS_STALE" = true ]; then
  if [ $DAYS_SINCE -gt 7 ] || [ "$COMMITS_SINCE" != "unknown" -a $COMMITS_SINCE -gt 20 ]; then
    STALENESS_LEVEL="very-stale"
  else
    STALENESS_LEVEL="stale"
  fi
fi
```

#### Step 4: Display Staleness Status

Always display freshness check, regardless of staleness:

**If Context is Fresh:**
```
✓ Context is current
  Saved: {time_ago} ago ({date})
  Commits since: {count}
  Status: Up to date
```

**If Context is Stale:**
```
⚠ Context is stale
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Last saved: {time_ago} ago ({date})
Current status:
- Time elapsed: {days} days, {hours} hours
- Commits since save: {count} commits
- Files changed: ~{count} files
- Warning threshold: {warn_hours} hours OR {warn_commits} commits

⚠ Your saved context may be outdated and missing recent changes
```

**If Context is Very Stale:**
```
⚠⚠ Context is significantly outdated
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Last saved: {days} days ago ({date})
Changes since: {commits} commits, ~{files} files modified

⚠ HIGH RISK: Architectural changes likely occurred
→ STRONGLY recommend running /context-save before proceeding
```

#### Step 5: Automatic Refresh Prompt

If `AUTO_PROMPT` is enabled and context is stale:

```bash
if [ "$IS_STALE" = true ] && [ "$AUTO_PROMPT" = "true" ]; then
  echo ""
  echo "I recommend refreshing the context first."
  echo ""
  echo "Options:"
  echo "1. Update now (recommended) - Run /context-save to capture recent changes"
  echo "2. Proceed with stale context - Load potentially outdated information"
  echo "3. Show what changed - Display commit log and file changes"
  echo ""
  echo "What would you like to do? [Reply with 1, 2, or 3]"

  # Wait for user response
  # If 1: Execute /context-save, then continue with restore
  # If 2: Proceed with restore (add warnings to output)
  # If 3: Show git changes, then ask again
fi
```

**Option 3: Show What Changed**

If user selects option 3:

```bash
echo ""
echo "Changes since last context save (commit ${SAVED_COMMIT:0:7}):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Recent commits ($COMMITS_SINCE):"
git log --oneline ${SAVED_COMMIT}..${CURRENT_COMMIT} | head -10
echo ""
echo "Modified files ($CHANGED_FILES):"
git diff --stat ${SAVED_COMMIT}..${CURRENT_COMMIT} | head -20
echo ""
echo "Areas likely outdated:"
# Analyze changed files to determine affected areas
if git diff --name-only ${SAVED_COMMIT}..${CURRENT_COMMIT} | grep -q "src/"; then
  echo "- Architecture: Code changes detected"
fi
if git diff --name-only ${SAVED_COMMIT}..${CURRENT_COMMIT} | grep -q "package.json\|requirements.txt\|go.mod"; then
  echo "- Dependencies: Package file(s) updated"
fi
if git diff --name-only ${SAVED_COMMIT}..${CURRENT_COMMIT} | grep -q "test\|spec"; then
  echo "- Testing: Test file(s) modified"
fi
echo ""
echo "Would you still like to proceed with stale context? [yes/no]"
```

#### Step 6: Version Migration Check

If loading v1.0.0 context, migrate to v2.0.0:

```bash
if [ "$SAVED_VERSION" = "1.0.0" ]; then
  echo "⚠ Context saved with older version (v1.0.0)"
  echo ""
  echo "Upgrading to current version (v2.0.0)..."

  # Migrate schema (add new fields with defaults)
  jq '. + {
    "version": "2.0.0",
    "extraction": {
      "mode": (.compression // "standard"),
      "filesAnalyzed": 0,
      "patternsExtracted": 0
    },
    "fileTracking": {"snapshot": {"totalFiles": 0, "keyFiles": []}},
    "staleness": {
      "thresholds": {"warnAfterHours": 24, "warnAfterCommits": 5},
      "autoPrompt": true
    },
    "history": {
      "saves": [{"timestamp": .timestamp, "commit": .git.commit, "filesChanged": 0, "type": "migrated-from-v1"}],
      "lastUpdate": .timestamp
    }
  }' .claude-context/metadata.json > .claude-context/metadata.json.tmp

  mv .claude-context/metadata.json.tmp .claude-context/metadata.json

  echo "✓ Context upgraded successfully"
  echo ""
  echo "New features enabled:"
  echo "- Enhanced change tracking"
  echo "- Automatic staleness detection"
  echo "- Configurable thresholds"
  echo ""
fi
```

#### Step 7: Proceed with Restoration

After staleness handling, continue with normal context loading...

### 2. Restoration Modes

**Full Restoration** (default):
- Load complete context from all categories
- Reconstruct architectural understanding
- Restore all patterns and conventions
- Provide comprehensive project knowledge

**Incremental Restoration**:
- Load only context that's changed since last session
- Compare current codebase with saved context
- Highlight architectural evolution
- Focus on deltas and updates

**Selective Restoration**:
- Load specific context categories based on task
- Apply relevance filtering
- Prioritize high-value patterns for current work
- Optimize for token budget

### 3. Input Parameters

Configure restoration behavior:

**context_source** (default: `.claude-context/`):
- Directory containing saved context
- Can specify alternative context stores

**restoration_mode** (default: `full`):
- `full` - Complete context restoration
- `incremental` - Only changed patterns
- `selective` - User-specified categories

**token_budget** (default: 8192):
- Maximum tokens to spend on context
- Automatically prioritizes most relevant patterns
- Prevents context overflow

**relevance_threshold** (default: 0.75):
- Semantic similarity cutoff (0.0-1.0)
- Higher = more selective restoration
- Lower = more comprehensive context

**focus_area** (optional):
- Specify area of interest: "architecture", "testing", "dependencies", "workflows"
- Filters context to relevant sections
- Reduces token usage for focused work

### 4. Semantic Context Loading

**Priority-Based Loading:**
```
Priority 1 (Always Load):
- Project overview and metadata
- Core architecture patterns
- Critical conventions and standards
- Essential setup information

Priority 2 (Relevance-Based):
- Patterns matching current focus area
- Recently modified components
- Frequently accessed knowledge

Priority 3 (On-Demand):
- Detailed implementation examples
- Historical decision context
- Complete dependency graphs
- Troubleshooting guides
```

### 5. Context Rehydration Strategy

**Step 1: Metadata & Overview**
- Load project metadata (languages, frameworks, type)
- Restore high-level architecture understanding
- Rebuild mental model of project structure

**Step 2: Core Patterns**
- Load frequently used patterns
- Restore code conventions
- Reconstruct workflow understanding

**Step 3: Focused Context**
- Load context relevant to current task
- Provide examples and references on request
- Reference file locations dynamically

**Step 4: Integration Knowledge**
- Restore dependency understanding
- Understand component relationships
- Map data flows and integration points

### 6. Freshness Validation (Handled Upfront)

**Note**: Freshness validation and staleness detection are now handled automatically at the start of restoration (see Step 1 above). By the time context loading reaches this stage, staleness has already been checked and user has been prompted if needed.

**During Context Loading:**

If user chose to proceed with stale context, mark restored information appropriately:

**For Stale Context:**
- Add timestamps to sections: "(as of {date})"
- Include warnings: "⚠ This information may be outdated"
- Reference the staleness metrics in output
- Suggest running `/context-save` after viewing context

**For Very Stale Context:**
- Add prominent warnings to all sections
- Mark each section with "⚠⚠ POTENTIALLY OUTDATED"
- Show last known state with clear timestamps
- Strong recommendation to refresh before making decisions

**For Fresh Context:**
- No special markers needed
- Display confidence level: "High confidence - context is current"

**Additional Validation:**
- Verify critical files still exist at referenced paths
- Note if files have been renamed or moved
- Flag if major dependencies have changed versions

### 7. Context Presentation

Present restored context clearly:

**Architecture Summary:**
```markdown
## Project Context Restored

**Project**: project-name
**Type**: web-application
**Languages**: TypeScript, Python
**Frameworks**: React, Flask

### Architecture Overview
[High-level architecture description]

### Key Patterns
- [Pattern 1]: Description and usage
- [Pattern 2]: Description and usage

### Recent Changes
[If incremental mode: list of changes since last save]
```

**Pattern Quick Reference:**
```
Provide code examples for discovered patterns:
- Configuration patterns
- Error handling approaches
- Testing strategies
- Deployment workflows
```

**Integration Map:**
```
Show relationships between:
- Internal modules
- External dependencies
- Service integrations
- Data flows
```

### 8. Performance Optimization

**Lazy Loading:**
- Load minimal context initially
- Fetch detailed patterns on-demand
- Stream large contexts incrementally

**Caching:**
- Cache frequently accessed patterns
- Preload likely-needed context
- Minimize disk reads

**Token Efficiency:**
- Summarize verbose patterns
- Use references instead of duplication
- Compress redundant information
- Prioritize by relevance

### 9. Conflict Resolution

Handle mismatches between saved and current state:

**Version Drift:**
- Saved context from old commit
- Files moved or renamed
- Architecture evolved

**Resolution Strategy:**
- Mark outdated information with warnings
- Provide "last known" information with timestamp
- Recommend context refresh
- Merge non-conflicting updates

### 10. Token Budget Management

When context exceeds budget:

**Prioritization:**
1. Project metadata (always included)
2. Architecture overview (high priority)
3. Core patterns (by relevance score)
4. Detailed examples (lowest priority)

**Strategies:**
- Summarize instead of full detail
- Reference files instead of including content
- Defer detailed context until requested
- Use semantic filtering to select most relevant

## Command Usage

```bash
/context-restore
```

**With options** (natural language):
```
/context-restore with focus on architecture
/context-restore with 4096 token budget
/context-restore incremental mode
/context-restore selective mode for testing patterns
```

## Example Workflows

### Workflow 1: Resume After Break
```
User: "I was working on this project yesterday, what's the architecture?"
Action: /context-restore
Result: Loads full project context with architecture, patterns, and conventions
```

### Workflow 2: Focused Work
```
User: "I need to add new tests, what's the testing strategy?"
Action: /context-restore with focus on testing
Result: Loads only testing-related context within token budget
```

### Workflow 3: Onboarding
```
User: "I'm new to this codebase, how do I get started?"
Action: /context-restore
Result: Loads setup guide, architecture overview, key patterns, and conventions
```

### Workflow 4: Token-Constrained
```
Context: Using fast model with limited context window
Action: /context-restore with 2048 token budget
Result: Loads only essential architecture and top patterns
```

## Output Format

After restoration, provide:

### 1. Context Summary
- Project name and type
- Languages and frameworks detected
- Context save timestamp
- Number of patterns loaded

### 2. Enhanced Freshness Check

**Note**: Freshness is checked BEFORE loading context. Display appropriate status:

**Scenario 1: Fresh Context**
```
✓ Context is current
  Saved: 2 hours ago (Dec 10, 2025 at 10:30 AM)
  Commits since: 0
  Files changed: 0
  Status: Up to date
  Confidence: High

## Project Context Restored
[Continue with normal context presentation]
```

**Scenario 2: Stale Context - User Chose to Proceed**
```
⚠ Context is stale
  Last saved: 3 days ago (Dec 7, 2025)
  Changes: 12 commits, ~27 files modified

⚠ Loaded information may not reflect recent changes

## Project Context Restored (as of Dec 7, 2025)

⚠ Note: Context is 3 days old - proceed with caution

[Context presentation with staleness warnings]

→ Recommend running /context-save to refresh when convenient
```

**Scenario 3: Very Stale Context - User Chose to Proceed**
```
⚠⚠ Context is significantly outdated
  Last saved: 8 days ago (Dec 2, 2025)
  Changes: 34 commits, ~156 files modified

⚠ HIGH RISK: Architectural changes likely occurred

## Project Context Restored (POTENTIALLY OUTDATED)

⚠⚠ WARNING: Context saved 8 days ago
All information below marked as potentially outdated

**Architecture Overview** ⚠⚠ POTENTIALLY OUTDATED
(as of Dec 2, 2025)
[architecture content]

**Key Patterns** ⚠⚠ POTENTIALLY OUTDATED
(as of Dec 2, 2025)
[patterns content]

→ STRONGLY recommend running /context-save before making decisions
```

**Scenario 4: Stale Context - Auto-prompt Shown, User Updated**
```
⚠ Context was stale (3 days old)

🔄 Running /context-save to refresh...
[Context save output]

✓ Context has been refreshed

Now loading updated context...

✓ Context is current
  Saved: Just now
  Status: Up to date

## Project Context Restored
[Fresh context presentation]
```

### 3. Loaded Knowledge
- Architecture patterns (with staleness markers if applicable)
- Code conventions (with timestamps if stale)
- Key file locations (validated against current state)
- Integration points (with outdated warnings if needed)
- Development workflows

### 4. Next Steps
- Suggested actions based on context freshness
- If stale: Recommendation to run `/context-save`
- If fresh: Normal suggestions for exploration
- Gaps requiring update or clarification

## Validation & Integrity

Before presenting restored context:
- ✓ Verify context file integrity
- ✓ Check for version compatibility
- ✓ Validate JSON structure
- ✓ Confirm no sensitive data exposure
- ✓ Ensure file references are valid
- ✓ Test semantic coherence

## Error Handling

**No Context Found:**
```
⚠ No saved context found in .claude-context/
→ Run /context-save first to capture project context
```

**Outdated Context:**
```
⚠ Context is 7 days old (saved: 2025-11-11)
→ Consider running /context-save to refresh
→ Proceeding with potentially outdated information
```

**Token Budget Exceeded:**
```
⚠ Full context requires 15,000 tokens but budget is 8,192
→ Loading prioritized subset (architecture + key patterns)
→ Use selective mode or increase budget for more detail
```

**Corrupted Context:**
```
✗ Context files are corrupted or incomplete
→ Run /context-save to regenerate context
```

**Version Mismatch:**
```
⚠ Saved context from commit abc123, current commit is def456
→ Context may be outdated, showing last known state
→ Run /context-save to update with current state
```

## Adaptive Presentation

Context presentation adapts to project type:

- **Web Applications**: Focus on frontend/backend architecture, API routes, deployment
- **Libraries**: Emphasize public API, usage examples, extension points
- **Services**: Highlight endpoints, data models, integration patterns
- **Tools/CLIs**: Focus on commands, configuration, plugin architecture
- **Data Pipelines**: Show data flow, transformations, storage patterns

Begin context restoration now, intelligently loading project knowledge with semantic awareness, relevance filtering, and token efficiency.
