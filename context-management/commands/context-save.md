---
description: Capture comprehensive project state and knowledge for future retrieval
---

# Context Save Command

You are a **Context Extraction Specialist** focused on capturing comprehensive project state, architectural decisions, and institutional knowledge for any codebase.

## Objective

Analyze and save project context including:
- Architecture patterns and design decisions
- Project structure and organization
- Key technical decisions and their rationale
- Dependencies and integration points
- Code conventions and standards
- Development workflows and processes

## Extraction Process

### 1. Project Discovery

Automatically discover what exists in the project:
- Identify programming languages and frameworks
- Detect project type (web app, library, service, etc.)
- Locate configuration files and build tools
- Find documentation and README files
- Detect version control information

### 2. Architecture Analysis

Extract high-level architectural understanding:
- Overall project structure (monorepo, microservices, monolith, etc.)
- Module/package organization
- Key entry points and primary workflows
- External dependencies and integrations
- Build and deployment infrastructure

### 3. Pattern Extraction

Identify patterns organically based on what's present:
```
Patterns to discover and capture:
- Code organization patterns
- Naming conventions
- Error handling approaches
- Testing strategies (if tests exist)
- Configuration management
- Logging and monitoring patterns
- Security patterns (authentication, authorization, encryption)
```

### 4. Decision Context

Document the "why" behind architectural choices:
- Rationale for technology selections
- Design trade-offs and considerations
- Historical context from commit messages
- Known limitations or technical debt
- Future considerations or migration plans

### 5. Knowledge Capture

Extract institutional knowledge:
- Setup and onboarding procedures
- Development workflows
- Deployment processes
- Troubleshooting guides
- Common pitfalls and solutions

### 6. Dependency Mapping

Track relationships:
- External library dependencies
- Internal module dependencies
- Service-to-service communication (if applicable)
- Data flow between components
- Integration points with external systems

### 7. Context Storage Format

Save context to `.claude-context/` directory:

**Directory Structure:**
```
.claude-context/
├── metadata.json                    # Snapshot metadata
├── architecture/
│   ├── overview.md                 # High-level architecture
│   ├── structure.md                # Project structure details
│   └── decisions.md                # Architectural decision records
├── patterns/
│   ├── code-patterns.json          # Discovered code patterns
│   ├── conventions.json            # Naming and style conventions
│   └── workflows.json              # Development workflows
├── dependencies/
│   ├── external.json               # Third-party dependencies
│   └── internal.json               # Module relationships
└── knowledge/
    ├── setup.md                    # Getting started guide
    └── troubleshooting.md          # Common issues and solutions
```

**metadata.json (v2.0.0):**
```json
{
  "version": "2.0.0",
  "timestamp": "2025-11-18T21:42:00Z",
  "project": {
    "name": "project-name",
    "displayName": "Project Display Name",
    "path": "/path/to/project",
    "type": "web-application",
    "description": "Brief project description",
    "languages": ["typescript", "python"],
    "frameworks": ["react", "flask"]
  },
  "git": {
    "commit": "abc123def456",
    "branch": "main",
    "remote": "origin",
    "commitCount": 142,
    "lastCommitDate": "2025-11-18T13:00:00Z"
  },
  "extraction": {
    "mode": "standard",
    "duration_seconds": 45,
    "filesAnalyzed": 87,
    "patternsExtracted": 23,
    "dependencies": {
      "external": 34,
      "internal": 12
    },
    "contentSizes": {
      "architecture_bytes": 12458,
      "patterns_bytes": 8934,
      "dependencies_bytes": 3421,
      "knowledge_bytes": 6789
    }
  },
  "fileTracking": {
    "snapshot": {
      "totalFiles": 87,
      "byExtension": {
        "ts": 45,
        "tsx": 12,
        "json": 15,
        "md": 8,
        "py": 7
      },
      "keyFiles": [
        {
          "path": "src/index.ts",
          "lastModified": "2025-11-18T12:30:00Z",
          "included": true
        },
        {
          "path": "package.json",
          "lastModified": "2025-11-17T10:15:00Z",
          "included": true
        }
      ]
    }
  },
  "staleness": {
    "thresholds": {
      "warnAfterHours": 24,
      "warnAfterCommits": 5
    },
    "autoPrompt": true
  },
  "history": {
    "saves": [
      {
        "timestamp": "2025-11-18T21:42:00Z",
        "commit": "abc123def456",
        "filesChanged": 0,
        "type": "initial"
      }
    ],
    "lastUpdate": "2025-11-18T21:42:00Z"
  },
  "extraction_version": "2.0.0",
  "compression": "standard"
}
```

### 8. Semantic Enrichment

For each extracted element, include:
- **Purpose**: What problem it solves
- **Context**: When and why it's used
- **Examples**: Real code snippets demonstrating usage
- **Relationships**: Links to related patterns or modules
- **Source References**: File paths and line numbers
- **Evolution**: How it has changed over time

### 9. Compression Levels

Adjust detail based on needs:

**Minimal**:
- Basic architecture overview
- Key technologies and patterns
- Essential setup information

**Standard** (default):
- Complete architecture documentation
- All discovered patterns
- Dependency mapping
- Development workflows

**Comprehensive**:
- Everything in standard
- Detailed code examples
- Full decision history
- Extensive cross-references

### 10. Security Considerations

**IMPORTANT - Exclude from saved context:**
- API keys, passwords, secrets, tokens
- Database credentials and connection strings
- Private encryption keys
- Personal identifiable information (PII)
- Customer or proprietary data
- Internal URLs or IP addresses (if sensitive)

Only document patterns and structures, never actual sensitive values.

## Command Usage

```bash
/context-save
```

**Optional parameters** (specify in natural language):
- Compression level: "Use minimal detail" or "Comprehensive extraction"
- Focus area: "Focus on architecture" or "Capture testing patterns primarily"
- Scope: "Only analyze the backend module"

## Smart Update Detection and Incremental Saves

### Automatic Operation Mode Detection

**IMPORTANT**: Before beginning extraction, determine if this is an initial save or an update by checking for existing context.

#### Step 1: Detect Operation Type

```bash
# Check if context already exists
if [ -f ".claude-context/metadata.json" ]; then
  OPERATION_TYPE="update"
  echo "🔄 Existing context detected - will perform incremental update"
else
  OPERATION_TYPE="initial"
  echo "🎯 No existing context - will perform initial extraction"
fi
```

### Initial Save Mode

When no existing context is found (`OPERATION_TYPE="initial"`):

**Execution:**
1. Perform complete project analysis
2. Extract all patterns, architecture, and dependencies
3. Create full context structure
4. Initialize metadata with v2.0.0 schema
5. Set `history.saves[0].type` to "initial"

**User Feedback Template:**
```
🎯 Context Extraction Started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Analyzing project structure...
Discovering patterns...
Extracting architecture...
Mapping dependencies...

✓ Context saved successfully (first time)

Summary:
- Files analyzed: {count}
- Patterns extracted: {count}
- External dependencies: {count}
- Internal modules: {count}
- Storage location: .claude-context/
- Estimated size: {size}KB

Next: Run /context-restore in future sessions to instantly load this context
```

### Update Mode

When existing context is found (`OPERATION_TYPE="update"`):

#### Step 1: Load Previous Context

```bash
# Read previous metadata
PREV_METADATA=$(cat .claude-context/metadata.json)
PREV_COMMIT=$(echo "$PREV_METADATA" | jq -r '.git.commit')
PREV_TIMESTAMP=$(echo "$PREV_METADATA" | jq -r '.timestamp')
PREV_FILES=$(echo "$PREV_METADATA" | jq -r '.fileTracking.snapshot.totalFiles')
```

#### Step 2: Detect Changes

```bash
# Get current git state
CURR_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "no-git")

if [ "$CURR_COMMIT" != "no-git" ] && [ "$PREV_COMMIT" != "null" ]; then
  # Git-based change detection
  COMMITS_SINCE=$(git rev-list ${PREV_COMMIT}..${CURR_COMMIT} --count 2>/dev/null || echo "0")
  CHANGED_FILES=$(git diff --name-only ${PREV_COMMIT}..${CURR_COMMIT} 2>/dev/null || echo "")
  FILES_CHANGED_COUNT=$(echo "$CHANGED_FILES" | grep -c . || echo "0")
else
  # Fallback to time-based detection when git unavailable
  COMMITS_SINCE="unknown"
  FILES_CHANGED_COUNT="unknown"
  echo "⚠ Git not available - using time-based staleness only"
fi

# Calculate time since last save
HOURS_SINCE=$(calculate hours between PREV_TIMESTAMP and now)
DAYS_SINCE=$(calculate days between PREV_TIMESTAMP and now)
```

#### Step 3: Incremental Analysis Strategy

**For git-tracked projects with identifiable changes:**
1. **Focus on changed files**: Analyze only files in `$CHANGED_FILES`
2. **Re-extract affected patterns**: Identify patterns that involve changed files
3. **Update dependency graph**: Refresh only relationships involving changed modules
4. **Refresh architecture**: Update architectural docs only if structural changes detected
5. **Skip unchanged content**: Do not re-analyze stable files

**Performance benefit**: 2-3x faster than full save for typical updates (10-30 seconds vs 30-120 seconds)

**For non-git or untrackable changes:**
1. Perform full re-analysis
2. Note in output that incremental optimization was unavailable
3. Compare new vs old metadata to identify differences

#### Step 4: Generate Change Summary

Compare current extraction with previous metadata:

```bash
# Calculate deltas
NEW_PATTERNS=$(current patterns count - previous patterns count)
NEW_DEPENDENCIES=$(current dependencies count - previous dependencies count)
SIZE_CHANGE=$(current total size - previous total size)

# Identify changed categories
CHANGED_AREAS=()
if architecture content changed; then CHANGED_AREAS+=("architecture"); fi
if patterns changed; then CHANGED_AREAS+=("patterns"); fi
if dependencies changed; then CHANGED_AREAS+=("dependencies"); fi
if knowledge changed; then CHANGED_AREAS+=("knowledge"); fi
```

#### Step 5: Update Metadata and History

Update metadata.json:
1. Increment version to 2.0.0 (if migrating from 1.0.0)
2. Update timestamp to current time
3. Update git.commit, git.commitCount, git.lastCommitDate
4. Update extraction statistics
5. Update fileTracking.snapshot
6. Add new entry to history.saves array:

```json
{
  "timestamp": "2025-11-23T10:15:00Z",
  "commit": "def456abc789",
  "filesChanged": 15,
  "type": "incremental-update",
  "changedAreas": ["architecture", "patterns", "dependencies"],
  "duration_seconds": 23
}
```

#### Step 6: Enhanced Update Feedback

**User Feedback Template for Updates:**
```
🔄 Context Update Started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Previous save: {time_ago} ago (commit: {short_hash})
Changes detected: {files_changed} files, {commits} commits since last save

Analyzing changed files...
Updating patterns...
Refreshing dependencies...

✓ Context updated successfully

Summary of Changes:
- Files changed: {count} (analyzed incrementally)
- New patterns: {count}
- Updated dependencies: {count}
- Commits since last save: {commits}
- Time since last save: {days} days, {hours} hours
- Previous size: {old_size}KB → New size: {new_size}KB

Changed areas:
{changed_areas_with_checkmarks}

Next: Context is now fresh and up-to-date
```

**Example output:**
```
🔄 Context Update Started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Previous save: 2 days ago (commit: abc123d)
Changes detected: 15 files, 8 commits since last save

Analyzing changed files...
Updating patterns...
Refreshing dependencies...

✓ Context updated successfully

Summary of Changes:
- Files changed: 15 (analyzed incrementally)
- New patterns: 3
- Updated dependencies: 2
- Commits since last save: 8
- Time since last save: 2 days, 3 hours
- Previous size: 31KB → New size: 34KB

Changed areas:
- ✓ Architecture: Updated (new service added)
- ✓ Patterns: 3 new patterns detected
- ✓ Dependencies: 2 package updates
- ○ Knowledge: No changes

Next: Context is now fresh and up-to-date
```

### Edge Case: Large Updates

If more than 50 files changed or more than 20 commits:

```
🔄 Context Update Started (Large Update)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Previous save: 5 days ago (commit: abc123d)
Changes detected: 67 files, 23 commits

⚠ Large number of changes detected
  This update may take similar time to initial extraction

Performing comprehensive re-analysis...

✓ Context updated successfully

Summary of Changes:
- Files changed: 67 (full re-analysis performed)
- Patterns extracted: 28 (5 new, 3 modified)
- Dependencies updated: 8
- Commits since last save: 23
- Time since last save: 5 days
- Previous size: 31KB → New size: 45KB
- Duration: 85 seconds

Significant changes detected - recommend reviewing updated context

Next: Run /context-restore to load fresh context
```

### Edge Case: No Git Repository

If project is not git-tracked:

```
🔄 Context Update Started
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Previous save: 3 days ago

⚠ Not a git repository - using time-based detection
  Incremental optimization unavailable

Performing full re-analysis...

✓ Context updated successfully

Summary:
- Files analyzed: 87 (full scan)
- Time since last save: 3 days, 5 hours
- Patterns: 23 (comparison with previous: +2 new patterns)
- Dependencies: 34 external, 12 internal
- Size: 31KB → 33KB

Note: For faster incremental updates, initialize git repository

Next: Context is now up-to-date
```

## Example Workflows

### Workflow 1: Initial Project Documentation
```
1. Clone or navigate to project
2. Run /context-save to perform initial analysis
3. Review generated .claude-context/ directory
4. Use /context-restore in future sessions for instant context
```

### Workflow 2: Before Major Refactoring
```
1. Run /context-save to capture current state
2. Perform refactoring work
3. Run /context-save again to capture new state
4. Compare contexts to document evolution
```

### Workflow 3: Knowledge Transfer
```
1. Experienced developer runs /context-save
2. Context captures implicit knowledge and decisions
3. New team member runs /context-restore
4. Accelerates onboarding with complete context
```

### Workflow 4: Focused Extraction
```
User: "I need to understand the authentication system"
Command: /context-save focusing on authentication
Result: Extracts only auth-related context
```

## Implementation Strategy

### Discovery Phase
1. Scan project root for configuration files
2. Identify programming languages from file extensions
3. Detect frameworks from dependencies
4. Analyze directory structure

### Analysis Phase
1. Parse key configuration files
2. Analyze code structure and imports
3. Extract patterns from representative samples
4. Build dependency graph

### Documentation Phase
1. Generate architecture overview
2. Document discovered patterns
3. Create knowledge articles
4. Build cross-reference indices

### Storage Phase
1. Organize content by category
2. Apply compression settings
3. Generate semantic embeddings (optional)
4. Write to .claude-context/ directory

## Output

After execution, you will:
1. Confirm project analyzed (name, type, languages)
2. List patterns extracted (architecture, conventions, workflows)
3. Show storage location and estimated size
4. Provide token count estimate for stored context
5. Highlight any security concerns or excluded sensitive data
6. Suggest next steps (review documentation, run tests, etc.)

## Performance Notes

### Timing Expectations

**Initial Save:**
- Small projects (< 100 files): 30-45 seconds
- Medium projects (100-500 files): 45-90 seconds
- Large projects (500-1000 files): 90-120 seconds
- Very large projects (> 1000 files): 2-5 minutes

**Incremental Update:**
- Small updates (1-10 files): 10-15 seconds
- Medium updates (10-30 files): 15-25 seconds
- Large updates (30-50 files): 25-40 seconds
- Very large updates (> 50 files): Similar to initial save (full re-analysis)

**Performance Benefit:**
- Incremental updates are typically 2-3x faster than full saves
- Update detection overhead: ~2 seconds
- Git-tracked projects benefit most from incremental optimization

### Context Size

- Typical size: 50KB-2MB depending on project complexity
- Metadata overhead: ~5-10KB
- Incremental updates may grow context size by 10-30%
- Large monorepos may require focused extraction

### Optimization Tips

- Initialize git repository for fastest incremental updates
- Use focused extraction for very large monorepos
- Run updates after significant milestones rather than every commit
- Consider "minimal" compression for faster extraction on large projects

## Adaptive Analysis

The plugin intelligently adapts to what it finds:
- **Web Applications**: Extracts frontend/backend architecture, API patterns, deployment
- **Libraries**: Documents public APIs, usage examples, extension points
- **Services**: Maps endpoints, data models, integration patterns
- **Tools/CLIs**: Documents commands, configuration, plugin systems
- **Data Pipelines**: Maps data flow, transformations, storage

Begin context extraction now, discovering and documenting project knowledge without assumptions about technology stack or architecture.
