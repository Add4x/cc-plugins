# Context Management Plugin

Intelligent context management for any project, enabling seamless knowledge capture, storage, and retrieval across development sessions.

## Overview

This Claude Code plugin provides specialized context management capabilities for software development projects. It captures architectural patterns, design decisions, and institutional knowledge to accelerate development and maintain continuity across sessions.

## Features

- **Automated Context Extraction**: Analyzes project structure, patterns, and conventions
- **Technology-Agnostic**: Works with any programming language, framework, or project type
- **Smart Pattern Recognition**: Discovers code patterns, naming conventions, and workflows
- **Semantic Storage**: Organizes context for efficient retrieval and relevance filtering
- **Security-First**: Excludes sensitive data (tokens, keys, credentials) from saved context
- **Token-Efficient Restoration**: Loads context with budget awareness and prioritization
- **Version Tracking**: Monitors context freshness and alerts to outdated information

## Installation

### Prerequisites

1. Install [Claude Code](https://code.claude.com)
2. Have access to your project repositories

### Install from Marketplace

This plugin is part of the development-plugins-marketplace. See the [repository README](../README.md) for marketplace installation instructions.

**Quick Install:**
```bash
# Add the marketplace (adjust path to your local clone)
/plugin marketplace add /path/to/cc-plugins

# Install this plugin
/plugin install context-management@development-plugins-marketplace

# Verify installation
/plugin list
```

The plugin should appear as `context-management` in your available plugins.

## Components

### Agent: context-manager

Specialized AI agent for context engineering:
- Analyzes any project to extract patterns and architecture
- Manages knowledge graphs and semantic relationships
- Optimizes context for multi-agent workflows
- Handles vector databases and RAG implementations

**Model**: Haiku (fast and cost-effective)

### Commands

#### `/context-save`

Captures comprehensive project context.

**Usage:**
```bash
# Save context for entire project
/context-save

# Use minimal compression
/context-save with minimal detail

# Focus on specific area
/context-save focusing on architecture

# Comprehensive extraction
/context-save with comprehensive detail
```

**What it captures:**
- Project architecture and structure
- Design patterns and conventions
- Code organization and naming patterns
- Dependencies and integrations
- Development workflows
- Testing strategies
- Architectural decisions and rationale

**Output location**: `.claude-context/` directory in your project root

#### `/context-restore`

Restores previously saved context with semantic awareness.

**Usage:**
```bash
# Restore full context
/context-restore

# Focus on specific area
/context-restore with focus on testing

# Set token budget
/context-restore with 4096 token budget

# Incremental mode (only changes)
/context-restore incremental mode

# Selective restoration
/context-restore selective mode for architecture
```

**Restoration modes:**
- **Full**: Complete context restoration (default)
- **Incremental**: Only changed patterns since last save
- **Selective**: Specific categories based on focus area

**Parameters:**
- `restoration_mode`: full/incremental/selective
- `token_budget`: Max tokens (default: 8192)
- `relevance_threshold`: Similarity cutoff (default: 0.75)
- `focus_area`: Filter by category (architecture/testing/dependencies/workflows)

## Usage Examples

### Example 1: New Project Setup

```bash
# Clone or create a new project
cd /path/to/project

# Capture initial context
/context-save

# In future sessions, instantly restore knowledge
/context-restore
```

### Example 2: Resume Work After Break

```bash
# Start new session
cd /path/to/project

# Restore full project context
/context-restore

# Continue working with complete architectural understanding
```

### Example 3: Focused Development

```bash
# Working on testing improvements
/context-restore with focus on testing

# Review existing test patterns and strategies
# Develop new tests with full context

# Save updated context
/context-save
```

### Example 4: Team Onboarding

```bash
# New team member clones repository
cd /path/to/project

# Senior developer has previously run /context-save

# New developer restores context
/context-restore

# Instantly understand:
# - Project architecture
# - Code conventions
# - Development workflows
# - Setup procedures
```

### Example 5: Cross-Project Work

```bash
# Working on multiple related projects
cd /project-a
/context-save

cd /project-b
/context-save

# Later, quickly switch contexts
cd /project-a
/context-restore
# Work on project A with full context

cd /project-b
/context-restore
# Switch to project B seamlessly
```

### Example 6: Token-Constrained Environment

```bash
# Using fast model with limited context window
/context-restore with 2048 token budget

# Loads only essential architecture and key patterns
```

### Example 7: Context Update Workflow

```bash
# Initial save when starting project
cd /path/to/project
/context-save

# Output: 🎯 Context saved successfully (first time)
# Summary: 87 files analyzed, 23 patterns extracted

# ... work on project for a few days ...

# Resume work after break
/context-restore

# Output shows staleness:
# ⚠ Context is stale (3 days old, 12 commits since)
# I recommend refreshing the context first.
# Options:
# 1. Update now (recommended)
# 2. Proceed with stale context
# 3. Show what changed

# Choose option 1
1

# → /context-save runs automatically
# Output: 🔄 Context updated successfully
# Changes: 15 files, 3 new patterns

# Context refreshed, continue working with up-to-date information
```

### Example 8: Incremental Updates

```bash
# After making significant changes
/context-save

# Output shows it's an update, not initial save:
# 🔄 Context Update Started
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Previous: 2 days ago (commit: abc123d)
# Changes: 15 files, 8 commits
#
# ✓ Context updated successfully
#
# Summary of Changes:
# - Files changed: 15 (analyzed incrementally)
# - New patterns: 3
# - Updated dependencies: 2
# - Time since last save: 2 days, 3 hours
# - Size: 31KB → 34KB
#
# Changed areas:
# - ✓ Architecture: Updated (new service added)
# - ✓ Patterns: 3 new patterns detected
# - ✓ Dependencies: 2 package updates
# - ○ Knowledge: No changes

# Incremental update completed in ~15 seconds (vs 60 seconds for full save)
```

### Example 9: Custom Staleness Thresholds

```bash
# Configure staleness thresholds for your workflow
# Edit .claude-context/metadata.json

# For fast-paced development (warn after 12 hours or 3 commits):
{
  "staleness": {
    "thresholds": {
      "warnAfterHours": 12,
      "warnAfterCommits": 3
    },
    "autoPrompt": true
  }
}

# For stable project (warn after 1 week or 20 commits):
{
  "staleness": {
    "thresholds": {
      "warnAfterHours": 168,
      "warnAfterCommits": 20
    },
    "autoPrompt": true
  }
}

# To disable automatic prompts (only show warnings):
{
  "staleness": {
    "thresholds": {
      "warnAfterHours": 24,
      "warnAfterCommits": 5
    },
    "autoPrompt": false
  }
}

# Now /context-restore will use your custom thresholds
/context-restore
# ✓ Context is current (based on your thresholds)
```

## Context Storage Structure

When you run `/context-save`, context is organized as:

```
.claude-context/
├── metadata.json                    # Snapshot metadata
├── architecture/
│   ├── overview.md                 # High-level architecture
│   ├── structure.md                # Project structure
│   └── decisions.md                # Architectural decisions
├── patterns/
│   ├── code-patterns.json          # Code organization patterns
│   ├── conventions.json            # Naming and style conventions
│   └── workflows.json              # Development workflows
├── dependencies/
│   ├── external.json               # Third-party dependencies
│   └── internal.json               # Module relationships
└── knowledge/
    ├── setup.md                    # Getting started guide
    └── troubleshooting.md          # Common issues and solutions
```

## Best Practices

### When to Save Context

✅ **Do save context:**
- After major architectural changes
- When establishing new patterns
- Before long breaks from the project
- After documenting important decisions
- When onboarding new conventions

❌ **Don't save context:**
- After every minor change
- Before understanding the changes
- When context is already fresh
- During active debugging sessions

### When to Update Context

**Important**: Just run `/context-save` again to update your existing context!

✅ **Do update context:**
- After major feature completion
- Before switching to another project
- When staleness warning appears during `/context-restore`
- After architectural refactoring
- Weekly for active projects
- After significant dependency updates

❌ **Don't update context:**
- After every single commit
- During active development session
- When context is less than 24 hours old (unless major changes)
- For minor formatting or documentation changes
- Multiple times in the same session

**How it works:**
- The plugin automatically detects if context exists
- Initial save: Complete analysis of entire project
- Update: Incremental analysis of only changed files (2-3x faster)
- Shows exactly what changed since last save

### When to Restore Context

✅ **Do restore context:**
- Starting work after a break
- Switching between projects
- Before code reviews
- When architectural decisions are needed
- For onboarding new team members

❌ **Don't restore context:**
- When you already have full context
- For trivial changes
- When context is still in working memory

### Staleness Management

**Automatic Detection:**
- Context restore automatically checks staleness
- Warns after 24 hours OR 5 commits by default (configurable)
- Prompts to refresh when context is stale
- Shows exactly what changed since last save

**Response Options:**
1. **Update now**: Recommended when significant changes detected
2. **Proceed anyway**: For quick reference when you know context
3. **Show changes**: Review git diff before deciding

**Manual Refresh:**
- Run `/context-save` anytime to refresh
- Shows exactly what changed since last save
- Incremental update is fast (10-30 seconds typically)
- Updates only changed patterns and files

**Threshold Customization:**
- Edit `staleness` settings in `.claude-context/metadata.json`
- Adjust `warnAfterHours` for your team's pace
- Adjust `warnAfterCommits` based on commit frequency
- Set `autoPrompt: false` to disable automatic prompts (shows warnings only)

### Security Guidelines

The plugin **automatically excludes**:
- API keys and secrets
- Authentication tokens
- Database credentials
- Private encryption keys
- Personal identifiable information (PII)
- Customer data
- Passwords and sensitive configuration

It captures only **patterns and structures**, never actual sensitive values.

**Always verify** `.claude-context/` doesn't contain secrets before committing to version control.

**Recommended**: Add `.claude-context/` to `.gitignore` if context contains any project-specific information you don't want to share.

## Troubleshooting

### Context Not Found

```
Error: No saved context found in .claude-context/
```

**Solution**: Run `/context-save` first to capture initial context.

### Outdated Context Warning

```
Warning: Context is 7 days old
```

**Solution**: Run `/context-save` to refresh with latest patterns.

### Token Budget Exceeded

```
Warning: Full context requires 15,000 tokens but budget is 8,192
```

**Solutions**:
- Use selective restoration: `/context-restore with focus on [area]`
- Increase token budget: `/context-restore with 16384 token budget`
- Use incremental mode: `/context-restore incremental mode`

### Version Mismatch

```
Warning: Saved context from commit abc123, current commit is def456
```

**Solution**: Review changes and run `/context-save` to update context.

### Corrupted Context

```
Error: Context files are corrupted or incomplete
```

**Solution**: Delete `.claude-context/` directory and run `/context-save` to regenerate.

## Configuration

### Token Budgets by Model

Recommended token budgets based on Claude model:

- **Haiku**: 2048-4096 tokens (efficient, focused context)
- **Sonnet**: 8192-16384 tokens (balanced context)
- **Opus**: 16384-32768 tokens (comprehensive context)

### Relevance Thresholds

Adjust semantic filtering:

- **0.9**: Very selective (only highly relevant patterns)
- **0.75**: Balanced (default)
- **0.6**: Comprehensive (more patterns included)

### Compression Levels

Control detail level:

- **Minimal**: Basic overview, essential patterns only
- **Standard**: Complete documentation (default)
- **Comprehensive**: Maximum detail with examples

## Adaptive Analysis

The plugin intelligently adapts to project type:

### Web Applications
- Frontend/backend architecture
- API endpoints and routes
- State management patterns
- Build and deployment configuration

### Libraries
- Public API documentation
- Usage examples
- Extension points
- Version compatibility

### Services/APIs
- Endpoint definitions
- Data models and schemas
- Authentication/authorization
- Integration patterns

### CLI Tools
- Command structure
- Configuration options
- Plugin architecture
- Usage patterns

### Data Pipelines
- Data flow and transformations
- Storage patterns
- Processing stages
- Error handling

## Advanced Features

### Multi-Project Context

Work across multiple projects:
- Each project maintains separate context
- Quick switching between projects
- Cross-reference patterns across projects

### Incremental Updates

Efficient context updates:
- Only saves changed patterns
- Tracks evolution over time
- Maintains version history

### Semantic Search

Find relevant context:
- Natural language queries
- Relevance-based ranking
- Cross-reference discovery

### Team Collaboration

Share knowledge:
- Commit `.claude-context/` to share with team (if appropriate)
- Accelerate onboarding
- Maintain institutional knowledge

## Contributing

To enhance this plugin:

1. Add new pattern detection algorithms
2. Improve semantic relevance scoring
3. Add project-type-specific analyzers
4. Enhance error detection and handling
5. Optimize token efficiency

## Support

For issues or questions:
- GitHub Issues: [Link to your repository]
- Documentation: [Link to additional docs]

## Version

**Current Version**: 1.0.0

## License

[Your License Here]

---

Built with ❤️ for seamless development workflows
