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

**metadata.json:**
```json
{
  "timestamp": "2025-11-18T21:42:00Z",
  "project": {
    "name": "project-name",
    "path": "/path/to/project",
    "languages": ["typescript", "python"],
    "frameworks": ["react", "flask"],
    "type": "web-application"
  },
  "git": {
    "commit": "abc123",
    "branch": "main",
    "remote": "origin"
  },
  "extraction_version": "1.0.0",
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

- Analysis time varies by project size (typically 30-120 seconds)
- Context size typically 50KB-2MB depending on complexity
- Incremental saves update only changed portions
- Large monorepos may require focused extraction

## Adaptive Analysis

The plugin intelligently adapts to what it finds:
- **Web Applications**: Extracts frontend/backend architecture, API patterns, deployment
- **Libraries**: Documents public APIs, usage examples, extension points
- **Services**: Maps endpoints, data models, integration patterns
- **Tools/CLIs**: Documents commands, configuration, plugin systems
- **Data Pipelines**: Maps data flow, transformations, storage

Begin context extraction now, discovering and documenting project knowledge without assumptions about technology stack or architecture.
