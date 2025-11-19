# Claude Code Plugins

A marketplace of Claude Code plugins for enhanced development workflows.

## Available Plugins

### 🧠 [Context Management](./context-management/)

Intelligent context management for any project - captures and restores knowledge, architecture, and patterns.

**Features:**
- Automated context extraction from any codebase
- Technology-agnostic pattern recognition
- Semantic storage and retrieval
- Token-efficient restoration
- Security-first (excludes sensitive data)

**Commands:**
- `/context-save` - Capture project context
- `/context-restore` - Restore saved context

[View full documentation](./context-management/README.md)

## Installation

### Add This Marketplace

```bash
# Add the marketplace to Claude Code
/plugin marketplace add /Users/shyju.viswambaran/backend/cc-plugins
```

### Install Plugins

```bash
# Install context management plugin
/plugin install context-management@development-plugins-marketplace

# Verify installation
/plugin list
```

## Repository Structure

```
cc-plugins/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace configuration
├── context-management/          # Context management plugin
│   ├── agents/
│   ├── commands/
│   └── README.md
└── [future-plugins]/            # Additional plugins coming soon
```

## Adding New Plugins

To add a new plugin to this marketplace:

1. **Create plugin directory**:
   ```bash
   mkdir my-new-plugin
   cd my-new-plugin
   ```

2. **Create plugin structure**:
   ```
   my-new-plugin/
   ├── agents/              # Optional: custom agents
   ├── commands/            # Optional: slash commands
   ├── skills/              # Optional: agent skills
   ├── hooks/               # Optional: event hooks
   └── README.md            # Plugin documentation
   ```

3. **Update marketplace.json**:
   ```json
   {
     "plugins": [
       {
         "name": "my-new-plugin",
         "displayName": "My New Plugin",
         "description": "Plugin description",
         "version": "1.0.0",
         "author": "Your Name",
         "source": "./my-new-plugin",
         "keywords": ["relevant", "keywords"],
         "category": "productivity"
       }
     ]
   }
   ```

4. **Test and install**:
   ```bash
   /plugin marketplace refresh development-plugins-marketplace
   /plugin install my-new-plugin@development-plugins-marketplace
   ```

## Plugin Development Guidelines

### Plugin Structure

Each plugin should follow this structure:

- **agents/**: Markdown files defining specialized AI agents
- **commands/**: Markdown files defining slash commands
- **skills/**: Subdirectories with SKILL.md files for agent capabilities
- **hooks/**: hooks.json for event handlers
- **README.md**: Comprehensive plugin documentation

### Best Practices

1. **Documentation**: Each plugin must have a README.md
2. **Naming**: Use kebab-case for plugin directories
3. **Versioning**: Follow semantic versioning (MAJOR.MINOR.PATCH)
4. **Testing**: Test plugins before adding to marketplace
5. **Generic Design**: Avoid hardcoding project-specific details
6. **Security**: Never include sensitive data in plugins

## Contributing

To contribute a plugin:

1. Fork this repository
2. Create your plugin in a new directory
3. Update `.claude-plugin/marketplace.json`
4. Create comprehensive README.md
5. Test thoroughly
6. Submit pull request

## Support

For issues or questions:
- Create an issue in this repository
- Refer to individual plugin documentation
- Check [Claude Code documentation](https://code.claude.com/docs)

## License

[Your License Here]

---

**Current Version**: 1.0.0
**Plugins**: 1
**Status**: Active Development
