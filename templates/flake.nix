{
  description = "Mac AI Workstation - M5 Pro 48GB";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, config, ... }: {
      # ----------------------------------------------------------------------
      # 1. System Packages (Managed via Nix)
      # ----------------------------------------------------------------------
      environment.systemPackages = [
        pkgs.git
        pkgs.uv
        pkgs.ripgrep
        pkgs.fd
        pkgs.jq
        pkgs.just
        pkgs.htop
        pkgs.tree
        pkgs.eza
        pkgs.bat
        pkgs.zoxide
        pkgs.fzf
        pkgs.zsh-powerlevel10k
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting

        # Cloud & Kubernetes Homelab Tooling
        pkgs.kubectl
        pkgs.talosctl
        pkgs.kubernetes-helm
        pkgs.k9s
        pkgs.ansible
        pkgs.sops
        pkgs.age
        pkgs.cilium-cli
        pkgs.stern
        pkgs.yamllint
        pkgs.tflint
      ];

      # Shell Aliases (Modern, Colorized with Nerd Font Icons)
      environment.shellAliases = {
        # Kubernetes & Homelab Shortcuts
        k = "kubectl";
        kc = "kubectl";
        k9 = "k9s";
        talos = "talosctl";
        tf = "terraform";

        # Modern Eza Listing (Colors + File Icons + Git status)
        ls = "eza --icons --group-directories-first";
        ll = "eza -lah --icons --group-directories-first --git";
        la = "eza -a --icons --group-directories-first";
        l = "eza -lh --icons --group-directories-first";
        tree = "eza --tree --icons";

        # Modern Bat Syntax-Highlighted File Viewing
        cat = "bat --paging=never --style=plain";
        preview = "bat --style=numbers,changes,header";

        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "~" = "cd ~";
        md = "mkdir -p";
        c = "clear";

        # Git Essentials
        g = "git";
        gs = "git status -sb";
        ga = "git add";
        gaa = "git add -A";
        gc = "git commit -m";
        gca = "git commit -am";
        gp = "git push";
        gpl = "git pull --rebase";
        gco = "git checkout";
        gb = "git branch";
        gd = "git diff";
        gl = "git log --oneline --graph --decorate -n 20";

        # System & Network
        reload = "exec zsh";
        flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
        myip = "curl -s https://ipinfo.io/ip";
        localip = "ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1";
        agy-awake = "caffeinate -s";
      };

      # Zsh Shell with Powerlevel10k, Auto-suggestions, Zoxide & FZF
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        promptInit = ''
          if [ -x "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
          fi
          export PATH="$HOME/.local/bin:$PATH"
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
          eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        '';
      };

      # ----------------------------------------------------------------------
      # 2. Homebrew Integration (Declarative Casks & Apps)
      # ----------------------------------------------------------------------
      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          cleanup = "zap"; # Automatically deletes unlisted apps/casks
          upgrade = true;
        };

        taps = [
          "hashicorp/tap"
        ];

        # CLI Developer & Cloud Tools (Python managed purely via uv)
        brews = [
          "awscli"                   # AWS CLI
          "azure-cli"                 # Microsoft Azure CLI (az)
          "hashicorp/tap/terraform"   # HashiCorp Terraform CLI
          "node"                      # Node.js runtime & npm
        ];

        # GUI Applications
        casks = [
          # Browsers
          "brave-browser"
          "microsoft-edge"

          # Productivity, Notes & Keyboards
          "google-drive"
          "microsoft-onenote"
          "keymapp"
          "navigator"
          "obsidian"
          "appcleaner"

          # Developer & AI
          "visual-studio-code"
          "ghostty"
          "orbstack"
          "google-gemini"
        ];

        # Mac App Store Applications (Optional, requires numeric App ID)
        masApps = {
          # "Keynote" = 409183694;
        };
      };

      # ----------------------------------------------------------------------
      # 3. macOS System Defaults & UI Preferences
      # ----------------------------------------------------------------------
      system.defaults = {
        # Dock settings matching your exact preferences from screenshot
        dock = {
          # Size & Magnification (20% larger default size + max magnification on hover)
          tilesize = 44;
          magnification = true;
          largesize = 128;

          # Position & Animations
          orientation = "bottom";
          mineffect = "genie";
          minimize-to-application = true;
          autohide = true;
          launchanim = true;
          show-process-indicators = true;
          show-recents = true;

          # Ordered Dock Layout: Browsers (Left) -> Apple Core & OneNote (Middle) -> Developer (Right)
          persistent-apps = [
            # 1. Browsers (Farthest Left, immediately right of Finder)
            "/System/Cryptexes/App/System/Applications/Safari.app"
            "/Applications/Microsoft Edge.app"
            "/Applications/Brave Browser.app"

            # 2. Apple Core Productivity & OneNote (Middle)
            "/System/Applications/Messages.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Maps.app"
            "/System/Applications/Photos.app"
            "/System/Applications/FaceTime.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Contacts.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Notes.app"
            "/Applications/Microsoft OneNote.app"

            # 3. Developer & AI Workstation Tools (Farthest Right)
            "/Applications/Gemini.app"
            "/Applications/Antigravity.app"
            "/Applications/Ghostty.app"
            "/Applications/Visual Studio Code.app"
            "/Applications/Obsidian.app"
            "/Applications/OrbStack.app"
          ];
        };

        # Finder settings & Developer ergonomics
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          FXPreferredViewStyle = "Nlsv"; # List view
          _FXShowPosixPathInTitle = true;
          ShowPathbar = true;            # Breadcrumb path bar at bottom
          ShowStatusBar = true;          # Status bar with item count & free SSD space
          FXDefaultSearchScope = "SCcf"; # Search current folder by default (not entire Mac)
          FXEnableExtensionChangeWarning = false; # Disable extension change popup
        };

        # Trackpad settings
        trackpad = {
          Clicking = true; # Tap to click
        };

        # Screenshot settings (Clean Documentation)
        screencapture = {
          location = "~/Pictures/Screenshots";
          type = "png";
          disable-shadow = true; # No massive drop shadows around window screenshots
        };

        # Control Center & Menu Bar
        controlcenter = {
          BatteryShowPercentage = true; # Always show battery percentage
        };

        # Global macOS preferences (Developer Typing Ergonomics)
        NSGlobalDomain = {
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
          "com.apple.swipescrolldirection" = true; # Natural scrolling
          AppleInterfaceStyle = "Dark";            # System-wide Dark Mode
          AppleInterfaceStyleSwitchesAutomatically = false; # Keep permanently Dark
          ApplePressAndHoldEnabled = false;        # Enable key repeating for vim/coding
          NSDocumentSaveNewDocumentsToCloud = false; # Save to local disk by default, NEVER iCloud

          # Disable smart typography (prevents terminal command corruption)
          NSAutomaticQuoteSubstitutionEnabled = false; # No curved "smart" quotes
          NSAutomaticDashSubstitutionEnabled = false;  # No em-dash conversion (keeps --flags intact)
          NSAutomaticCapitalizationEnabled = false;     # No auto-capitalization
          NSAutomaticSpellingCorrectionEnabled = false; # No auto-correct interference
        };

        # Custom system & browser preferences (Telemetry & Search Engines)
        CustomUserPreferences = {
          "NSGlobalDomain" = {
            AppleActionOnDoubleClick = "Maximize"; # Window title bar double-click: Zoom/Maximize
          };
          "com.apple.finder" = {
            FXICloudDriveDesktop = false;   # Never sync Desktop to iCloud
            FXICloudDriveDocuments = false; # Never sync Documents to iCloud
          };
          # Network & USB Hygiene (Avoid .DS_Store clutter)
          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          # Desktop & Stage Manager (from screenshot)
          "com.apple.WindowManager" = {
            EnableStandardClickToShowDesktop = true; # Click wallpaper to show desktop: Always
            HideDesktop = true;                      # Show items on Desktop: OFF
            StageManagerHideWidgets = true;          # Show items in Stage Manager: OFF
            GloballyEnabled = false;                 # Stage Manager: OFF
            AppWindowGroupingBehavior = 1;           # Show windows from an app: All at Once
          };

          # Brave Browser (Zero Telemetry + Google Default Search)
          "com.brave.Browser" = {
            BraveRewardsP3AEnabled = false;          # Disable P3A product analytics
            BraveStatsPing = false;                  # Disable stats ping
            MetricsReportingEnabled = false;         # Disable metrics reporting
            DefaultSearchProviderEnabled = true;
            DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
            DefaultSearchProviderName = "Google";
          };

          # Microsoft Edge (Zero Telemetry + Google Default Search)
          "com.microsoft.Edge" = {
            MetricsReportingEnabled = false;         # Disable diagnostic telemetry
            SendSiteInfoToImproveServices = false;   # Disable site reporting
            PersonalizationReportingEnabled = false; # Disable personalized tracking
            DiagnosticData = 0;                      # Turn off optional diagnostics
            DefaultSearchProviderEnabled = true;
            DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
            DefaultSearchProviderName = "Google";
          };

          # System Crash & Ad Tracking Suppression
          "com.apple.CrashReporter" = {
            DialogType = "none";
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
        };
      };

      # ----------------------------------------------------------------------
      # 4. Networking & Firewall
      # ----------------------------------------------------------------------
      networking.applicationFirewall = {
        enable = true;
        allowSigned = true;
        enableStealthMode = true;
      };

      # ----------------------------------------------------------------------
      # 5. Keyboard Remapping
      # ----------------------------------------------------------------------
      system.keyboard.enableKeyMapping = false;
      system.keyboard.remapCapsLockToEscape = false;

      # ----------------------------------------------------------------------
      # 6. Declarative Fonts (Nerd Fonts for VS Code & Ghostty)
      # ----------------------------------------------------------------------
      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      # ----------------------------------------------------------------------
      # 7. Core Nix & User Settings
      # ----------------------------------------------------------------------
      system.primaryUser = "nix_test";
      nix.enable = false; # Disable nix-darwin management of Nix to allow Determinate Nix daemon
      system.stateVersion = 5;
      nixpkgs.hostPlatform = "aarch64-darwin";

      # ----------------------------------------------------------------------
      # 8. Automated App Configs & System Fluff Purge
      # ----------------------------------------------------------------------
      system.activationScripts.postActivation.text = ''
        PRIMARY_USER="${config.system.primaryUser}"
        USER_HOME="/Users/$PRIMARY_USER"

        echo "--> Purging removable Apple bloatware & heavy audio libraries..."
        rm -rf /Applications/GarageBand.app 2>/dev/null || true
        rm -rf /Applications/iMovie.app 2>/dev/null || true
        rm -rf "/Library/Application Support/GarageBand" 2>/dev/null || true
        rm -rf "/Library/Application Support/Logic" 2>/dev/null || true
        rm -rf "/Library/Audio/Apple Loops" 2>/dev/null || true

        echo "--> Purging diagnostic logs, crash reports, and local APFS snapshots..."
        rm -rf "$USER_HOME/Library/Logs/DiagnosticReports"/* 2>/dev/null || true
        tmutil thinlocalsnapshots / 9999999999 4 2>/dev/null || true

        # Ensure Screenshots folder exists
        mkdir -p "$USER_HOME/Pictures/Screenshots"
        chown -R "$PRIMARY_USER" "$USER_HOME/Pictures/Screenshots" 2>/dev/null || true

        # Reset any hardware modifier key remappings (ensures Caps Lock behaves normally)
        hidutil property --set '{"UserKeyMapping":[]}' > /dev/null 2>&1 || true

        # Declarative per-device modifier swap for ZSA Voyager (VendorID 12951, ProductID 6519)
        # Swaps Control and Command ONLY for the Voyager; built-in MacBook keyboard remains untouched.
        echo "--> Applying ZSA Voyager modifier key mapping (Ctrl <-> Cmd)..."
        sudo -u "$PRIMARY_USER" defaults -currentHost write -g "com.apple.keyboard.modifiermapping.12951-6519-0" -array \
          '<dict><key>HIDKeyboardModifierMappingDst</key><integer>30064771299</integer><key>HIDKeyboardModifierMappingSrc</key><integer>30064771296</integer></dict>' \
          '<dict><key>HIDKeyboardModifierMappingDst</key><integer>30064771296</integer><key>HIDKeyboardModifierMappingSrc</key><integer>30064771299</integer></dict>' \
          '<dict><key>HIDKeyboardModifierMappingDst</key><integer>30064771303</integer><key>HIDKeyboardModifierMappingSrc</key><integer>30064771300</integer></dict>' \
          '<dict><key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer><key>HIDKeyboardModifierMappingSrc</key><integer>30064771303</integer></dict>'

        echo "--> Deploying declarative Continue.dev & VS Code configuration..."
        mkdir -p "$USER_HOME/.continue"
        cat << 'EOF' > "$USER_HOME/.continue/config.json"
{
  "tabAutocompleteModel": {
    "title": "Local Qwen 14B Autocomplete (MLX)",
    "provider": "openai",
    "model": "mlx-community/Qwen2.5-Coder-14B-Instruct-4bit",
    "apiBase": "http://localhost:8081/v1"
  },
  "models": [
    {
      "title": "Local Qwen 32B Chat (oMLX)",
      "provider": "openai",
      "model": "mlx-community/Qwen2.5-Coder-32B-Instruct-4bit",
      "apiBase": "http://localhost:8080/v1"
    },
    {
      "title": "Local Qwen 14B Chat (MLX)",
      "provider": "openai",
      "model": "mlx-community/Qwen2.5-Coder-14B-Instruct-4bit",
      "apiBase": "http://localhost:8080/v1"
    }
  ]
}
EOF
        chown -R "$PRIMARY_USER" "$USER_HOME/.continue"

        mkdir -p "$USER_HOME/Library/Application Support/Code/User"
        cat << 'EOF' > "$USER_HOME/Library/Application Support/Code/User/settings.json"
{
  "editor.fontFamily": "'JetBrainsMono Nerd Font', Menlo, Monaco, 'Courier New', monospace",
  "editor.fontSize": 14,
  "editor.fontLigatures": true,
  "editor.lineNumbers": "on",
  "editor.minimap.enabled": true,
  "editor.formatOnSave": true,
  "editor.inlineSuggest.enabled": true,
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "material-icon-theme",
  "telemetry.telemetryLevel": "off",
  "update.mode": "default"
}
EOF
        chown -R "$PRIMARY_USER" "$USER_HOME/Library/Application Support/Code"

        echo "--> Installing declarative VS Code extensions..."
        CODE_CLI="/opt/homebrew/bin/code"
        [ -x "$CODE_CLI" ] || CODE_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        if [ -x "$CODE_CLI" ]; then
          for ext in \
            "Continue.continue" \
            "ms-vscode-remote.remote-containers" \
            "ms-azuretools.vscode-docker" \
            "ms-vscode-remote.remote-ssh" \
            "PKief.material-icon-theme" \
            "jnoortheen.nix-ide" \
            "hashicorp.terraform" \
            "amazonwebservices.aws-toolkit-vscode" \
            "ms-kubernetes-tools.vscode-kubernetes-tools"; do
            sudo -H -u "$PRIMARY_USER" env HOME="$USER_HOME" "$CODE_CLI" --install-extension "$ext" --force 2>/dev/null || true
          done
        fi

        echo "--> Deploying declarative Ghostty configuration..."
        mkdir -p "$USER_HOME/.config/ghostty"
        cat << 'EOF' > "$USER_HOME/.config/ghostty/config"
# Font & Typography
font-family = "JetBrainsMono Nerd Font"
font-size = 14
font-feature = ["calt", "liga"]

# Theme & Appearance
theme = "tokyonight"
background-opacity = 0.95
background-blur-radius = 20
macos-titlebar-style = "tabs"

# Performance & Cursor
cursor-style = "block"
cursor-style-blink = false
macos-option-as-alt = true
EOF
        chown -R "$PRIMARY_USER" "$USER_HOME/.config/ghostty"

        # Ensure ~/.p10k.zsh is owned by the user
        [ ! -f "$USER_HOME/.p10k.zsh" ] || chown "$PRIMARY_USER" "$USER_HOME/.p10k.zsh"

        # Refresh macOS Dock and live Dark Mode appearance immediately
        sudo -u "$PRIMARY_USER" osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true
        killall Dock 2>/dev/null || true
      '';
    };
  in
  {
    darwinConfigurations = {
      "MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
      "default" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
  };
}
