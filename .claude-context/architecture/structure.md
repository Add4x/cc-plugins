# Project Structure Details

## Directory Organization

### Root Level
```
cc-plugins/
├── .claude/                    # Claude Code configuration
├── .claude-plugin/             # Plugin marketplace configuration
├── context-management/         # Plugin: Knowledge management
├── aws-profile-manager/        # Plugin: AWS credentials
└── README.md                   # Marketplace documentation
```

### Configuration Directories

#### `.claude-plugin/`
**Purpose**: Marketplace definition and plugin registry

**Files**:
- `marketplace.json` - Marketplace configuration
  - Defines marketplace name and metadata
  - Lists all available plugins
  - Includes plugin versions and sources
  - Author information for each plugin

**Schema**:
```json
{
  "name": "marketplace-name",
  "description": "Marketplace description",
  "owner": {
    "name": "Owner Name",
    "email": "owner@example.com"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "description": "Plugin description",
      "version": "1.0.0",
      "author": {
        "name": "Author Name",
        "email": "author@example.com"
      },
      "source": "./plugin-directory",
      "keywords": ["keyword1", "keyword2"]
    }
  ]
}
```

#### `.claude/`
**Purpose**: Local Claude Code settings

**Files**:
- `settings.local.json` - Permission configuration
  - Defines allowed operations without user prompt
  - Specifies denied operations
  - Lists operations requiring user confirmation

## Plugin Directory Structure

### Standard Plugin Layout
```
plugin-name/
├── agents/
│   ├── agent1.md
│   └── agent2.md
├── commands/
│   ├── command1.md
│   ├── command2.md
│   └── command3.md
├── skills/               # Optional
│   └── skill-name/
│       └── SKILL.md
├── hooks/                # Optional
│   └── hooks.json
└── README.md
```

### Agent Files (`agents/*.md`)

**Format**: Markdown with YAML frontmatter

**Frontmatter Fields**:
```yaml
---
name: agent-name              # Required: Agent identifier
description: Short description # Required: Brief summary
version: 1.0.0                # Optional: Agent version
model: haiku|sonnet|opus      # Optional: Preferred Claude model
---
```

**Content**: Natural language instructions defining:
- Agent's expertise and capabilities
- Behavioral guidelines
- Tool usage patterns
- Response methodology
- Example use cases

**Location Convention**: `<plugin-name>/agents/<agent-name>.md`

### Command Files (`commands/*.md`)

**Format**: Markdown with YAML frontmatter

**Frontmatter Fields**:
```yaml
---
name: command-name            # Required: Command identifier
description: Short description # Required: Brief summary
model: haiku|sonnet|opus      # Optional: Model for this command
---
```

**Content**: Instructions that expand when command is invoked:
- Task description
- Expected parameters (via {{arg}} placeholders)
- Step-by-step execution guide
- Output format specifications
- Error handling instructions

**Location Convention**: `<plugin-name>/commands/<command-name>.md`

**Invocation**: `/command-name [arguments]`

## Plugin: context-management

### Directory Structure
```
context-management/
├── agents/
│   └── context-manager.md      # Elite context engineering specialist
├── commands/
│   ├── context-save.md         # Capture project context
│   └── context-restore.md      # Restore saved context
└── README.md                   # Comprehensive plugin documentation
```

### Component Details

**Agent: context-manager**
- Model: Haiku (fast, cost-effective)
- Expertise: Context engineering, vector databases, knowledge graphs, RAG
- Purpose: Specialized AI for context management tasks
- Capabilities: Architecture analysis, pattern extraction, semantic search

**Command: context-save**
- Model: Inherits from agent or global default
- Purpose: Extract and save project context
- Parameters: Optional compression level, focus area, scope
- Output: `.claude-context/` directory with structured context

**Command: context-restore**
- Model: Inherits from agent or global default
- Purpose: Restore previously saved context
- Parameters: Restoration mode, token budget, relevance threshold, focus area
- Output: Rehydrated project knowledge for current session

**README.md**:
- Installation instructions
- Usage examples
- Configuration options
- Troubleshooting guide
- Best practices

## Plugin: aws-profile-manager

### Directory Structure
```
aws-profile-manager/
├── agents/
│   └── aws-profile-manager.md  # AWS credential specialist
├── commands/
│   ├── aws-auth.md             # Refresh single profile
│   ├── aws-auth-all.md         # Refresh all profiles
│   ├── aws-status.md           # Show profile status
│   ├── aws-switch.md           # Switch active profile
│   └── aws-accounts.md         # List accounts
└── README.md                   # TODO: Create documentation
```

### Component Details

**Agent: aws-profile-manager**
- Model: Not specified (uses default)
- Expertise: AWS credential management, ALKS CLI integration
- Purpose: Manage multiple AWS accounts with temporary credentials
- Capabilities: Credential refresh, profile switching, status monitoring

**Commands**:
1. `aws-auth` - Refresh single profile credentials
   - Model: Haiku
   - Parameters: Profile name (nonprod, sandbox, preprod, prod)
   - Operation: Execute ALKS CLI for specific account

2. `aws-auth-all` - Refresh all profiles
   - Model: Sonnet (more complex, sequential operations)
   - Parameters: None
   - Operation: Execute ALKS CLI for all configured accounts

3. `aws-status` - Show profile status
   - Model: Haiku
   - Parameters: None
   - Operation: Read ~/.aws/credentials and show profile status

4. `aws-switch` - Switch active profile
   - Model: Haiku (inferred)
   - Parameters: Profile name
   - Operation: Set AWS_PROFILE environment variable

5. `aws-accounts` - List configured accounts
   - Model: Not specified
   - Parameters: None
   - Operation: Display reference table of accounts

**Configuration**:
- Hardcoded account mappings in agent definition
- Four profiles: vc-nonprod, vc-sandbox, vc-preprod, vc-prod
- ALKS CLI integration for credential management

## File Naming Conventions

### Agents
- Pattern: `<agent-name>.md`
- Example: `context-manager.md`, `aws-profile-manager.md`
- Convention: Kebab-case, descriptive name

### Commands
- Pattern: `<command-name>.md`
- Example: `context-save.md`, `aws-auth.md`
- Convention: Kebab-case, verb-noun or action-target format
- Invoked as: `/<command-name>`

### Plugins
- Pattern: `<plugin-name>/`
- Example: `context-management/`, `aws-profile-manager/`
- Convention: Kebab-case, descriptive of functionality

## Context Output Structure

When `/context-save` is executed, it creates:

```
.claude-context/
├── metadata.json
├── architecture/
│   ├── overview.md
│   ├── structure.md
│   └── decisions.md
├── patterns/
│   ├── code-patterns.json
│   ├── conventions.json
│   └── workflows.json
├── dependencies/
│   ├── external.json
│   └── internal.json
└── knowledge/
    ├── setup.md
    └── troubleshooting.md
```

## Version Control

### Tracked Files
- All `.md` files (documentation and configuration)
- `.claude-plugin/marketplace.json`
- `.claude/settings.local.json`
- README files

### Ignored Files
- `.claude-context/` (should be in .gitignore for sensitive projects)
- Temporary files
- User-specific configuration

### Git Status
- Branch: main
- Recent commits:
  1. Fix marketplace.json schema
  2. Add context management plugin
- Untracked: `aws-profile-manager/` directory
- Status: Clean working directory except for untracked plugin

## Dependencies

### External Dependencies
- **Claude Code**: Required platform (no package.json dependencies)
- **ALKS CLI**: Required for aws-profile-manager plugin
- **Git**: Version control

### Internal Dependencies
- Plugins are independent, no inter-plugin dependencies
- Each plugin can function standalone
- Marketplace provides discovery but plugins are decoupled

## Extensibility Points

### Adding New Plugins
1. Create plugin directory: `<plugin-name>/`
2. Add agents: `<plugin-name>/agents/*.md`
3. Add commands: `<plugin-name>/commands/*.md`
4. Create README: `<plugin-name>/README.md`
5. Register in marketplace: Update `.claude-plugin/marketplace.json`

### Adding Plugin Components
- **New Agent**: Add `.md` file in `agents/` directory
- **New Command**: Add `.md` file in `commands/` directory
- **New Skill**: Create `skills/<skill-name>/SKILL.md`
- **New Hook**: Define in `hooks/hooks.json`

## File Count Summary

- **Total Markdown Files**: 11
  - Root README: 1
  - Plugin READMEs: 1 (context-management)
  - Agent Files: 2
  - Command Files: 7
  - Context Documentation: 0 (generated at runtime)

- **Total JSON Files**: 2
  - marketplace.json: 1
  - settings.local.json: 1

- **Total Directories**: 10
  - Root directories: 4
  - Plugin directories: 4
  - Configuration directories: 2
