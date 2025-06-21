{
  description = "Claude Code Usage Monitor development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        # Python environment with required packages
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pytz
        ]);
        
        # Shell script for running the monitor
        claude-monitor = pkgs.writeShellScriptBin "claude-monitor" ''
          cd ${toString ./.}
          ${pythonEnv}/bin/python ccusage_monitor.py "$@"
        '';
        
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            pythonEnv
            nodejs_20  # includes npm
            claude-monitor
          ];
          
          shellHook = ''
            # Create local npm prefix for packages
            export npm_config_prefix="$PWD/.npm-global"
            export PATH="$PWD/.npm-global/bin:$PATH"
            mkdir -p "$PWD/.npm-global"
            
            echo "🎯 Claude Code Usage Monitor Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "📦 Available tools:"
            echo "  • python (${pythonEnv}/bin/python)"
            echo "  • node ($(which node))"
            echo "  • npm ($(which npm))"
            echo "  • claude-monitor - Direct script runner"
            echo ""
            echo "🚀 Setup ccusage (run once):"
            echo "  npm install ccusage"
            echo ""
            echo "💡 Usage examples:"
            echo "  claude-monitor                    # Default (Pro plan)"
            echo "  claude-monitor --plan max5        # Max5 plan"
            echo "  claude-monitor --reset-hour 9     # Custom reset time"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          '';
        };
        
        # Provide the monitor script as a package
        packages.default = claude-monitor;
      });
}