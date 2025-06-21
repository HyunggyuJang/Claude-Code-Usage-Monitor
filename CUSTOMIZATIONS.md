# Customizations for nixos-darwin Integration

This fork includes customizations to integrate Claude-Code-Usage-Monitor with our nixos-darwin development environment.

## Changes Made

### 1. Nix Flake Integration (`flake.nix`)
- Added Python environment with pytz package
- Created `claude-monitor` script wrapper for easy execution
- Configured npm prefix for isolated package management
- Added PATH management for both `.npm-global/bin` and `node_modules/.bin`

### 2. Installation Approach
- **Global Install**: `npm install -g ccusage` within Nix environment
- **PATH Configuration**: Uses `.npm-global/bin` for consistent ccusage access
- **Clean Directory**: Removed local `node_modules` to avoid conflicts

### 3. nixos-darwin Integration
- Added `claude-monitor` alias to system shell configuration
- Integrated with existing Nix development workflow
- Allows system-wide access via simple `claude-monitor` command

## Usage

```bash
# System-wide access (after dswitch)
claude-monitor

# Direct Nix environment
cd 3-Resources/ai-development-tools/Claude-Code-Usage-Monitor
nix develop --command claude-monitor
```

## Repository Management

- **Origin**: https://github.com/HyunggyuJang/Claude-Code-Usage-Monitor (our fork)
- **Upstream**: https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor (original)

To sync with upstream changes:
```bash
git fetch upstream
git merge upstream/main
```

## Benefits of Fork

1. **Proper Ownership**: Our customizations are maintained in our repository
2. **Upstream Tracking**: Can still pull updates from original project
3. **Integration History**: All nixos-darwin integration work is preserved
4. **Best Practices**: Follows GitHub conventions for modified open source projects