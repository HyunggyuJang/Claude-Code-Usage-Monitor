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
            nodejs_20  # For ccusage CLI tool
            claude-monitor
          ];
          
          shellHook = ''
            echo "🎯 Claude Code Usage Monitor Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "📦 Available tools:"
            echo "  • python (${pythonEnv}/bin/python)"
            echo "  • node ($(which node))"
            echo "  • claude-monitor - Direct script runner"
            echo ""
            echo "🚀 Install ccusage globally:"
            echo "  npm install -g ccusage"
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