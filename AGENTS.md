# 🤖 Agent Operational Guidelines & Repository Rules

Welcome, Agent. This repository defines the declarative configuration and operational architecture for a clean, reproducible macOS workstation (Apple Silicon M-series).

When assisting in this repository or modifying the host system, you **MUST** strictly adhere to the following rules:

---

## 1. 🏛️ The Declarative System Invariant (Absolute Rule)

* **Zero Ad-Hoc Imperative Modifications**: Never make manual, imperative changes to the host system (e.g., running manual `brew install`, manual extension installers, ad-hoc `defaults write`, or manual config file edits outside of code).
* **Code First**: Every package, system preference, app setting, CLI tool, font, or editor extension must be declared in code inside `flake.nix` or its referenced dotfiles.
* **Apply Exclusively via `just switch`**: All system state changes must be applied and verified through:
  ```bash
  just switch
  ```
  *(or `just -g switch` / `sudo darwin-rebuild switch --flake ~/.config/nix-darwin`)*.
* **Reproducibility Guarantee**: Every modification must ensure that if this machine were wiped tomorrow, running `bootstrap.sh` on a brand new Mac would reproduce the exact same state without manual intervention.

---

## 2. 🔄 Flake Synchronization Protocol

This workspace contains two tiers of flake configurations:
1. **`templates/flake.nix`**: The canonical, portable, generic template used for unboxing and bootstrapping *any* new Mac (uses placeholder `system.primaryUser = "nix_test"` and generic `MacBook-Pro`).
2. **`~/.config/nix-darwin/flake.nix`**: The active system configuration on *this* specific Mac (uses `system.primaryUser = "ryan.bartusek"` and hostname `Ryans-MacBook-Pro`).

**Whenever modifying configuration:**
* Update `templates/flake.nix` first.
* Synchronize the changes to `~/.config/nix-darwin/flake.nix` (preserving the local username and hostname).
* Test the derivation evaluation (`nix eval ~/.config/nix-darwin#darwinConfigurations.Ryans-MacBook-Pro.system`).
* Prompt or instruct the user to run `just switch`.

---

## 3. ⚡ Local AI & Anti-Bloat Architecture

* **oMLX / Apple MLX Engine**:
  * Local model inference is powered by Apple's native **MLX** framework (`mlx-lm` / `oMLX`) for zero-copy Metal GPU performance and Paged SSD KV Caching.
  * Do not introduce Ollama background daemons or unnecessary sysctl kernel overrides unless explicitly directed by the user.
* **Port Allocations**:
  * **Port 8080**: Qwen 2.5 Coder 32B (4-bit) for chat, scoped refactoring, and agent turns.
  * **Port 8081**: Qwen 2.5 Coder 14B (4-bit) for instant tab autocomplete (FIM).
* **Python Hygiene**:
  * Never install Python packages globally or modify macOS system Python.
  * Use **`uv`** and **`uvx`** exclusively for isolated, ephemeral environments.

---

## 4. 💻 Editor & Tooling Standards

* **Primary Editor**: Visual Studio Code with the **Continue.dev** extension (`Continue.continue`).
* **Continue Configuration**: Declaratively managed in `~/.continue/config.json` via `postActivation` in `flake.nix`, connecting to local oMLX / MLX endpoints (`:8080` for chat, `:8081` for tab autocomplete).
* **VS Code Settings**: Enforce JetBrainsMono Nerd Font, dark mode (`"workbench.colorTheme": "Default Dark+"`), ligatures, and telemetry disabled (`"telemetry.telemetryLevel": "off"`).

---

## 5. 🛡️ Git Hygiene & Privacy Protection

* **Never Commit Installers or DMGs**: All `*.dmg`, `*.pkg`, and `*.iso` binaries are strictly ignored via `.gitignore` to prevent repository bloat and GitHub upload failures.
* **No Leaked PII or Credentials**: Do not hardcode personal email addresses, private file paths, API tokens, or SSH keys in repository templates or documentation.
* **Keep macOS Metadata Out**: Keep `.DS_Store` and AppleDouble files ignored and untracked.

---

## 6. 🚫 Git Commit & Push Policy (Absolute Rule)

* **Assist with Commit Messages**: When work is completed, suggest clear, well-structured conventional commit messages matching repository conventions.
* **DO NOT Commit or Push**: Under NO circumstances should the agent execute `git commit` or `git push`. Only the USER is authorized to commit and push changes to version control.

