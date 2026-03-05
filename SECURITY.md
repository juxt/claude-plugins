# Security Policy

## Plugin Supply Chain Trust

Plugins sourced from external GitHub repositories (allium, glance) are referenced
by commit SHA in `.claude-plugin/marketplace.json`. This provides point-in-time
immutability but requires human review when SHAs are updated.

### Before updating a plugin SHA

1. Review the diff between old and new SHA:
   `https://github.com/juxt/<plugin>/compare/<old-sha>...<new-sha>`
2. Check for changes to agent tool declarations (especially `tools: Bash(*)`)
3. Check for changes to skill auto-activation triggers
4. Update the `last_reviewed` date in `marketplace.json`

### Permissions model

Each plugin agent lists the tools it requires. Users should review these before
installing any plugin. Agents with unrestricted `Bash` access should be treated
with particular caution as they can execute arbitrary shell commands.

### Reporting a vulnerability

Please report security issues to info@juxt.pro or open a GitHub issue tagged
`security`.
