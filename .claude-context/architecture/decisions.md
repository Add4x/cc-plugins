# Architectural Decision Records

## ADR-001: Markdown-Based Plugin Configuration

**Date**: November 2025
**Status**: Accepted
**Context**: Need human-readable, version-controllable plugin definitions

### Decision
Use Markdown files with YAML frontmatter for agent and command definitions.

### Rationale
- **Human-Readable**: Natural language instructions are easy to understand and modify
- **Version Control Friendly**: Plain text files work well with Git
- **Flexible**: Markdown supports rich formatting, code blocks, and structure
- **Metadata Support**: YAML frontmatter provides structured metadata
- **Low Barrier to Entry**: Developers already familiar with Markdown
- **Claude-Native**: Works naturally with Claude's instruction-following capabilities

### Consequences
**Positive**:
- Easy to create and maintain plugins
- Clear documentation embedded in configuration
- Simple to review changes in pull requests
- No build step required
- Portable across systems

**Negative**:
- No compile-time validation of configuration
- Potential for inconsistencies in format
- Requires runtime parsing

### Alternatives Considered
- **JSON**: Too verbose, less human-readable
- **YAML**: Good for data, poor for long instructions
- **Custom DSL**: Unnecessary complexity

---

## ADR-002: Plugin Marketplace Architecture

**Date**: November 2025
**Status**: Accepted
**Context**: Need centralized plugin discovery and management

### Decision
Implement a marketplace model with central registry in `marketplace.json`.

### Rationale
- **Discoverability**: Users can browse available plugins
- **Version Management**: Track plugin versions centrally
- **Installation Simplicity**: Single command to install plugins
- **Trust Model**: Marketplace provides curated, trusted sources
- **Metadata**: Store plugin descriptions, authors, keywords
- **Scalability**: Can grow to support many plugins

### Consequences
**Positive**:
- Easy plugin discovery
- Consistent installation experience
- Version guarantees
- Clear ownership and authorship

**Negative**:
- Central configuration file requires coordination
- Marketplace becomes single point of truth
- May need to handle marketplace conflicts

### Implementation
```json
{
  "name": "development-plugins-marketplace",
  "plugins": [
    {
      "name": "plugin-name",
      "version": "1.0.0",
      "source": "./plugin-directory"
    }
  ]
}
```

---

## ADR-003: Specialized Agents Per Domain

**Date**: November 2025
**Status**: Accepted
**Context**: Need deep expertise for complex domain-specific tasks

### Decision
Create specialized agents with narrow, well-defined expertise rather than general-purpose agents.

### Rationale
- **Deep Expertise**: Agents can have detailed domain knowledge
- **Consistent Behavior**: Specialized prompts ensure predictable outputs
- **Performance Optimization**: Can choose appropriate Claude model per agent
- **Maintainability**: Easier to update single-purpose agents
- **Composability**: Agents can be combined for complex workflows

### Examples
- **context-manager**: Expert in context engineering, vector databases, knowledge graphs
- **aws-profile-manager**: Expert in AWS credentials, ALKS CLI, profile management

### Consequences
**Positive**:
- Higher quality responses for domain tasks
- Clear separation of concerns
- Easy to add new expertise domains
- Model selection optimized per task

**Negative**:
- More agents to maintain
- Potential duplication of common knowledge
- Users need to know which agent to use

---

## ADR-004: Model Selection Strategy

**Date**: November 2025
**Status**: Accepted
**Context**: Different tasks have different performance requirements

### Decision
Allow per-agent and per-command model selection, with defaults:
- **Haiku**: Simple, fast operations (status checks, single actions)
- **Sonnet**: Complex, multi-step operations (batch operations, analysis)
- **Opus**: Critical, high-stakes operations (not yet used)

### Rationale
- **Cost Efficiency**: Use cheaper models for simple tasks
- **Performance**: Use faster models where quality difference is minimal
- **Quality**: Use better models for complex reasoning
- **Flexibility**: Override model per command or agent as needed

### Implementation
```yaml
---
name: aws-auth
model: haiku  # Fast for simple credential refresh
---

---
name: aws-auth-all
model: sonnet  # More complex sequential operations
---
```

### Consequences
**Positive**:
- Optimized cost/performance tradeoff
- Faster responses for simple operations
- Better quality for complex tasks

**Negative**:
- Need to decide model per component
- Inconsistent response quality across operations
- Cost tracking more complex

---

## ADR-005: Plugin Isolation

**Date**: November 2025
**Status**: Accepted
**Context**: Need plugins to be independently maintainable and deployable

### Decision
Each plugin is completely self-contained with no cross-plugin dependencies.

### Rationale
- **Independence**: Plugins can be developed independently
- **No Conflicts**: No dependency version conflicts between plugins
- **Selective Installation**: Users install only what they need
- **Easier Maintenance**: Update one plugin without affecting others
- **Clear Boundaries**: Each plugin owns its domain

### Structure
```
plugin-name/
├── agents/       # Plugin's agents
├── commands/     # Plugin's commands
└── README.md     # Plugin documentation
```

### Consequences
**Positive**:
- Clean separation of concerns
- Parallel development possible
- Easy to remove plugins
- Clear ownership

**Negative**:
- Potential code duplication across plugins
- No shared utilities between plugins
- Each plugin must be self-sufficient

### Future Consideration
- May introduce shared utilities if duplication becomes significant
- Could create "core" plugin with common patterns

---

## ADR-006: Context Storage Format

**Date**: November 2025
**Status**: Accepted
**Context**: Need standardized format for saving project context

### Decision
Use hierarchical directory structure with JSON for data, Markdown for documentation.

### Structure
```
.claude-context/
├── metadata.json              # Structured metadata
├── architecture/*.md          # Documentation
├── patterns/*.json            # Structured pattern data
├── dependencies/*.json        # Dependency graphs
└── knowledge/*.md             # Knowledge articles
```

### Rationale
- **Separation of Concerns**: Data vs. documentation
- **Human-Readable**: Markdown files can be reviewed easily
- **Machine-Parseable**: JSON files for structured data
- **Hierarchical**: Logical organization by category
- **Extensible**: Easy to add new categories

### Consequences
**Positive**:
- Clear organization
- Both human and machine readable
- Easy to extend with new categories
- Version control friendly

**Negative**:
- More files to manage
- Need to maintain consistency across formats
- File I/O overhead for many small files

---

## ADR-007: Security-First Context Management

**Date**: November 2025
**Status**: Accepted
**Context**: Context files may accidentally capture sensitive data

### Decision
Explicitly exclude sensitive data from saved context:
- API keys, passwords, tokens
- Database credentials
- Private encryption keys
- PII and customer data

### Rationale
- **Security**: Prevent credential leakage
- **Compliance**: Protect PII and sensitive business data
- **Best Practice**: Capture patterns, not values
- **User Trust**: Users can save context confidently

### Implementation
- Document security guidelines in plugin README
- Warn users to review context before committing
- Recommend adding `.claude-context/` to `.gitignore` for sensitive projects
- Focus on capturing structure and patterns, not actual data

### Consequences
**Positive**:
- Prevents accidental credential exposure
- Builds user trust
- Compliant with security policies

**Negative**:
- Relies on correct implementation
- Cannot capture example data with real values
- Users must understand security implications

---

## ADR-008: Natural Language Command Parameters

**Date**: November 2025
**Status**: Accepted
**Context**: Commands need to accept user input flexibly

### Decision
Support natural language parameters using `{{arg}}` placeholders.

### Example
```markdown
---
name: aws-auth
---

Refresh AWS credentials for: **{{arg}}**

If user requests: `/aws-auth nonprod`
The {{arg}} expands to: "nonprod"
```

### Rationale
- **Flexibility**: Users can express intent naturally
- **Simple Syntax**: Easy to understand and use
- **Claude-Native**: Works naturally with Claude's language understanding
- **No Complex Parsing**: Let Claude interpret the parameters

### Consequences
**Positive**:
- Intuitive command interface
- No need for complex argument parsing
- Flexible parameter formats
- Natural language works better with Claude

**Negative**:
- No strong typing of parameters
- Potential ambiguity in parameter interpretation
- Harder to validate parameters upfront

---

## ADR-009: Permission-Based Security Model

**Date**: November 2025
**Status**: Accepted
**Context**: Some operations should not require user confirmation every time

### Decision
Use permission configuration in `.claude/settings.local.json` to define:
- Allowed operations (no prompt)
- Denied operations (always blocked)
- Ask operations (require user confirmation)

### Current Configuration
```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "Bash(tree:*)",
      "Bash(curl:*)",
      "Bash(git commit:*)"
    ],
    "deny": [],
    "ask": []
  }
}
```

### Rationale
- **User Control**: Users decide which operations are safe
- **Productivity**: No prompts for trusted operations
- **Security**: Sensitive operations can require confirmation
- **Flexibility**: Per-project permission configuration

### Consequences
**Positive**:
- Streamlined workflow for common operations
- User maintains control
- Can be customized per project

**Negative**:
- Users must understand security implications
- Misconfiguration could allow unintended operations
- Configuration required for optimal experience

---

## ADR-010: Git-Based Distribution

**Date**: November 2025
**Status**: Accepted
**Context**: Need simple distribution mechanism for marketplace

### Decision
Distribute marketplace via Git repository with local path installation.

### Installation
```bash
/plugin marketplace add /path/to/cc-plugins
/plugin install context-management@development-plugins-marketplace
```

### Rationale
- **Simple**: Leverages existing Git infrastructure
- **Version Control**: Full history of plugin changes
- **Access Control**: Can use Git repository permissions
- **No Infrastructure**: No need for package registry
- **Works Internally**: Compatible with internal Git servers

### Consequences
**Positive**:
- Zero additional infrastructure
- Familiar workflow for developers
- Works with internal/private repositories
- Version control built-in

**Negative**:
- Requires Git access
- Local path installation less portable
- No automatic updates
- Must manually pull updates

### Future Enhancement
- Could add support for Git URLs
- Could implement update notifications
- Could create public marketplace registry

---

## Future Architectural Decisions

### Under Consideration

1. **Shared Utilities**: Should we create common utilities for plugins?
2. **Plugin Dependencies**: Should plugins be able to depend on other plugins?
3. **Dynamic Plugin Loading**: Should plugins be hot-reloadable?
4. **Marketplace Registry**: Should we build a public registry service?
5. **Plugin Testing**: Should we standardize plugin testing approaches?
6. **Version Compatibility**: How to handle Claude Code version compatibility?
7. **Plugin Sandboxing**: Should plugins have restricted permissions?
8. **Analytics**: Should we track plugin usage for improvements?

### Deferred Decisions

- **Plugin Publishing**: Process for contributing to marketplace (deferred until more contributors)
- **Breaking Changes**: How to handle breaking changes in plugins (deferred until v2.0.0)
- **Deprecation Policy**: How to sunset old plugins (no deprecated plugins yet)
