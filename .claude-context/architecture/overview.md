# Architecture Overview

## Project Type
**Claude Code Plugin Marketplace** - A collection of reusable plugins that extend Claude Code functionality.

## Project Classification
- **Type**: Plugin Marketplace / Repository
- **Domain**: Developer Productivity Tools
- **Framework**: Claude Code Plugin System
- **Architecture Pattern**: Plugin-based architecture with marketplace distribution

## High-Level Structure

This project is a **plugin marketplace** that hosts multiple Claude Code plugins. Each plugin is self-contained and provides specific functionality through:
- Custom agents (specialized AI assistants)
- Slash commands (user-facing operations)
- Skills (reusable capabilities for agents)
- Hooks (event-driven integrations)

### Project Organization

```
cc-plugins/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace configuration and plugin registry
├── .claude/
│   └── settings.local.json       # Local Claude Code settings and permissions
├── context-management/            # Plugin: Context management system
│   ├── agents/
│   │   └── context-manager.md    # Agent: Context engineering specialist
│   ├── commands/
│   │   ├── context-save.md       # Command: Capture project context
│   │   └── context-restore.md    # Command: Restore saved context
│   └── README.md
├── aws-profile-manager/           # Plugin: AWS credential management
│   ├── agents/
│   │   └── aws-profile-manager.md
│   ├── commands/
│   │   ├── aws-auth.md           # Command: Refresh single profile
│   │   ├── aws-auth-all.md       # Command: Refresh all profiles
│   │   ├── aws-status.md         # Command: Show profile status
│   │   ├── aws-switch.md         # Command: Switch active profile
│   │   └── aws-accounts.md       # Command: List accounts
│   └── README.md (pending)
└── README.md                      # Marketplace documentation
```

## Core Components

### 1. Marketplace Configuration (`.claude-plugin/marketplace.json`)
- **Purpose**: Defines the marketplace and registers available plugins
- **Key Elements**:
  - Marketplace metadata (name, description, owner)
  - Plugin registry with versions and sources
  - Author information
  - Plugin keywords for discoverability

### 2. Plugin Structure
Each plugin follows a standardized structure:
- **agents/**: Markdown files defining specialized AI agents with specific expertise
- **commands/**: Markdown files defining slash commands for user operations
- **skills/**: Optional reusable capabilities
- **hooks/**: Optional event-driven integrations
- **README.md**: Plugin documentation

### 3. Agent System
Agents are specialized AI assistants with:
- **Defined Expertise**: Specific domain knowledge and capabilities
- **Model Selection**: Choice of Claude model (haiku for speed, sonnet for balance)
- **Behavioral Instructions**: Detailed prompt engineering for consistent behavior
- **Tool Access**: Access to Claude Code tools (Bash, Read, Write, etc.)

### 4. Command System
Slash commands provide:
- **User-Facing Operations**: Simple command interface (e.g., `/context-save`)
- **Natural Language Parameters**: Commands can accept arguments
- **Prompt Expansion**: Commands expand into detailed instructions for Claude
- **Model Override**: Per-command model selection for performance

## Architecture Patterns

### Pattern 1: Plugin Isolation
- Each plugin is self-contained in its own directory
- No cross-plugin dependencies
- Independent versioning
- Plugins can be installed/uninstalled independently

### Pattern 2: Marketplace Distribution
- Central marketplace configuration
- Plugins registered in `marketplace.json`
- Installation via marketplace reference: `plugin@marketplace-name`
- Version management per plugin

### Pattern 3: Markdown-Based Configuration
- Agents and commands defined in markdown with YAML frontmatter
- Human-readable and version-controllable
- Embedded instructions in natural language
- Metadata in frontmatter (name, description, version, model)

### Pattern 4: Agent Specialization
- Each agent has a narrow, well-defined expertise
- Agents use specific Claude models appropriate for their task
- Detailed behavioral instructions ensure consistency
- Tool usage patterns embedded in agent prompts

### Pattern 5: Command-Driven Workflows
- Commands encapsulate complex multi-step operations
- Commands can invoke agents for specialized tasks
- Natural language parameters provide flexibility
- Commands provide clear user feedback

## Key Design Decisions

### Decision 1: Markdown for Configuration
**Rationale**: Markdown provides human-readable configuration that's easy to edit, version control, and understand. YAML frontmatter adds structured metadata while keeping the main content natural.

### Decision 2: Agent-Based Architecture
**Rationale**: Specialized agents with deep domain expertise provide better results than general-purpose prompts. Each agent can be optimized for its specific task.

### Decision 3: Marketplace Model
**Rationale**: Centralized marketplace makes plugin discovery and installation easier. Users can install from trusted sources with version guarantees.

### Decision 4: Model Selection Per Task
**Rationale**: Different tasks have different performance requirements. Simple operations use Haiku (fast/cheap), complex tasks use Sonnet (balanced), critical tasks can use Opus (best quality).

### Decision 5: Plugin Isolation
**Rationale**: Self-contained plugins prevent dependency conflicts, make maintenance easier, and allow independent evolution of each plugin.

## Integration Points

### Claude Code Integration
- Plugins integrate with Claude Code's tool system
- Access to file operations (Read, Write, Edit)
- Bash execution for system operations
- Web operations for external data
- Git operations for version control

### User Interface Integration
- Slash commands appear in Claude Code's command palette
- Natural language interaction through chat interface
- Todo list integration for task tracking
- Permission system for sensitive operations

## Technology Stack

- **Platform**: Claude Code (Anthropic)
- **Configuration Format**: Markdown with YAML frontmatter
- **Version Control**: Git
- **Distribution**: Git-based marketplace
- **AI Models**: Claude Haiku, Sonnet, Opus

## Extensibility

The marketplace is designed for extensibility:
- **New Plugins**: Add new plugin directories with standard structure
- **Plugin Updates**: Update `marketplace.json` and plugin files
- **Agent Enhancement**: Add new agents to existing plugins
- **Command Addition**: Add new commands to plugins
- **Cross-Plugin Learning**: Patterns from one plugin can inform others

## Current State

**Plugins**: 2 total
1. **context-management** (v1.0.0) - Production ready, fully documented
2. **aws-profile-manager** (v1.0.0) - In development, commands complete, documentation pending

**Marketplace**: Active development
**Git Status**: On main branch, 2 commits, untracked aws-profile-manager directory
