---
title: IDE Configuration Guide (VS Code + Antigravity)
tags:
  - ide
  - vscode
  - continue
  - configuration
  - setup
  - macos
created: 2026-08-24
---

# ⚡ Visual Studio Code + Antigravity Setup

**Visual Studio Code** is your primary editor canvas for coding on macOS, fully paired with **Continue.dev** for zero-latency local AI completions and **Antigravity** for macro-level agentic orchestration.

* **Familiar & Robust:** Deep ecosystem of language servers, debuggers, and extensions.
* **Local AI Integration via Continue.dev:** Connects directly to local OpenAI-compatible endpoints (`mlx-lm` / `oMLX` on Apple Silicon) for keystroke autocompletion (FIM) and inline refactoring.
* **Dual-Tier Synergy:** Seamlessly coexists with Antigravity Desktop / CLI for multi-file autonomous planning and background tasks.

---

## 🛠️ Step 1: Install VS Code via `nix-darwin`

Visual Studio Code is declared directly in your `templates/flake.nix` under `homebrew.casks`:
```nix
homebrew.casks = [
  "visual-studio-code"
  "obsidian"
  "orbstack"
  "appcleaner"
  "ghostty"
];
```

---

## ⚙️ Step 2: Essential Extensions

Install the recommended extensions to match the workstation's typography, aesthetics, and local AI capabilities:

```bash
# Local AI Autocomplete & Chat
code --install-extension Continue.continue

# Aesthetics & Typography
code --install-extension PKief.material-icon-theme
code --install-extension enkia.tokyo-night
code --install-extension zhuangtongfa.material-theme

# Language & Tooling Support
code --install-extension bbenoist.Nix
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
```

---

## 🤖 Step 3: Local AI Configuration with Continue.dev

[Continue.dev](https://continue.dev) connects VS Code to your local Apple MLX models running on `localhost:8080` (chat & refactor) and `localhost:8081` (tab autocomplete).

Edit or create **`~/.continue/config.json`**:

```json
{
  "models": [
    {
      "title": "Local Qwen 2.5 Coder 32B (MLX)",
      "provider": "openai",
      "model": "mlx-community/Qwen2.5-Coder-32B-Instruct-4bit",
      "apiBase": "http://localhost:8080/v1"
    },
    {
      "title": "Local Qwen 2.5 Coder 14B (MLX)",
      "provider": "openai",
      "model": "mlx-community/Qwen2.5-Coder-14B-Instruct-4bit",
      "apiBase": "http://localhost:8080/v1"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Local Qwen 2.5 Coder 1.5B (Tab FIM)",
    "provider": "openai",
    "model": "mlx-community/Qwen2.5-Coder-1.5B-Instruct-4bit",
    "apiBase": "http://localhost:8081/v1"
  },
  "customCommands": [
    {
      "name": "test",
      "prompt": "{{{ input }}}\n\nWrite comprehensive unit tests for the selected code.",
      "description": "Generate unit tests"
    }
  ],
  "allowAnonymousTelemetry": false
}
```

---

## 🎨 Step 4: Ergonomic Editor Settings

Configure your VS Code user settings (`~/Library/Application Support/Code/User/settings.json`) to align with Ghostty and your hardware preferences:

```json
{
  "workbench.colorTheme": "Tokyo Night",
  "workbench.iconTheme": "material-icon-theme",
  "editor.fontFamily": "'JetBrainsMono Nerd Font', Menlo, Monaco, 'Courier New', monospace",
  "editor.fontSize": 14,
  "editor.lineHeight": 22,
  "editor.fontLigatures": true,
  "editor.cursorBlinking": "smooth",
  "editor.cursorSmoothCaretAnimation": "on",
  "editor.smoothScrolling": true,
  "editor.minimap.enabled": true,
  "editor.renderWhitespace": "selection",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "editor.formatOnSave": true,
  "files.autoSave": "onFocusChange",
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'",
  "terminal.integrated.fontSize": 13,
  "telemetry.telemetryLevel": "off"
}
```

---

## ⌨️ AI Keyboard Shortcuts Cheat Sheet

| Action | Shortcut (macOS) | Description |
| :--- | :--- | :--- |
| **Accept Autocomplete** | `Tab` | Accept predicted inline code completion |
| **Partial Accept** | `Cmd + Right` | Accept code suggestion word-by-word |
| **Inline AI Edit** | `Cmd + I` | Highlight code and instruct local Qwen to edit |
| **Open AI Chat Sidebar** | `Cmd + L` | Discuss selected code or ask architectural questions |
| **Quick File Open** | `Cmd + P` | Fuzzy search and open files |
| **Command Palette** | `Cmd + Shift + P` | Access VS Code commands |
| **Toggle Terminal** | `Ctrl + ~` | Open/hide integrated terminal |

---

## 🤝 The Dual-Tier Workflow in Practice

```
┌─────────────────────────────────────────────────────────────┐
│                    DAILY CODING ROUTINE                     │
│                                                             │
│ 1. Launch local MLX servers via terminal / Justfile:        │
│    `just serve-all`                                         │
│    • Port 8080: Qwen 2.5 Coder 32B (Chat / Edit)            │
│    • Port 8081: Qwen 2.5 Coder 1.5B (Tab Autocomplete)      │
│                                                             │
│ 2. Code inside VS CODE                                      │
│    • Real-time local tab completion via Continue.dev        │
│    • Instant inline refactoring with `Cmd + I`              │
│                                                             │
│ 3. Complex Architecture / Multi-File Planning               │
│    • Open ANTIGRAVITY on the same workspace folder          │
│    • Run autonomous builds, tests, and subagent swarms      │
└─────────────────────────────────────────────────────────────┘
```

---

## Related Notes
* [[Dual-Tier AI Workflow]]
* [[Local LLMs with MLX]]
* [[Nix-Darwin Guide]]
* [[Setup Checklist]]
