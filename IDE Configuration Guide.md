---
title: IDE Configuration Guide (Zed + Antigravity)
tags:
  - ide
  - zed
  - configuration
  - setup
  - rust
  - macos
created: 2026-08-24
---

# ⚡ Zed Editor + Antigravity Setup

**[Zed](https://zed.dev)** is a high-performance, GPU-accelerated code editor built from scratch in **Rust** specifically for macOS. It aligns with your anti-bloat, declarative philosophy:

* **Zero Electron Bloat:** Starts in $\sim 5\text{ms}$ and consumes $< 100\text{MB}$ of RAM.
* **Metal GPU Rendering:** Butter-smooth 120Hz ProMotion scrolling on Apple Silicon.
* **Native Local LLM Integration:** First-class support for local OpenAI-compatible endpoints (MLX) built directly into the editor core without requiring third-party extensions.

---

## 🛠️ Step 1: Install Zed via `nix-darwin`

Zed is declared directly in your `templates/flake.nix`:
```nix
homebrew.casks = [
  "zed"
  "obsidian"
  "orbstack"
  "appcleaner"
  "ghostty"
];
```

---

## ⚙️ Step 2: Automated VS Code Layout & Settings

> [!TIP]
> **100% Automated by Nix:** When you run `nix-darwin`, our `flake.nix` activation script automatically writes this exact `settings.json` configured with the **VS Code layout, keymap, and panel docking**.

```json
{
  "theme": "One Dark",
  "base_keymap": "VSCode",
  "icon_theme": "Material Icon Theme",

  // 1. Auto-Installed Extensions (Material Icons, Color Themes)
  "auto_install_extensions": {
    "material-icon-theme": true,
    "tokyo-night": true,
    "catppuccin": true,
    "nix": true
  },

  // 2. Typography & Editor (Matching Ghostty & VS Code)
  "buffer_font_family": "JetBrainsMono Nerd Font",
  "buffer_font_size": 14,
  "buffer_font_weight": 400,
  "ui_font_size": 14,
  "cursor_blink": true,
  "cursor_shape": "bar",
  "current_line_highlight": "all",
  "show_whitespaces": "selection",

  // 3. VS Code Ergonomics (Minimap, Inlay Hints, Indent Guides)
  "minimap": {
    "show": "always"
  },
  "line_numbers": "on",
  "indent_guides": {
    "enabled": true,
    "coloring": "indent_aware"
  },
  "inlay_hints": {
    "enabled": true
  },
  "autosave": "on_focus_change",
  "format_on_save": "on",
  "auto_signature_help": true,
  "show_inline_completions": true,

  // 4. VS Code-Style Panel Docks & Color File Icons
  "project_panel": {
    "dock": "left",
    "git_status": true,
    "file_icons": true,
    "folder_icons": true,
    "auto_reveal_entries": true,
    "default_width": 260
  },
  "outline_panel": {
    "dock": "left"
  },
  "terminal": {
    "dock": "bottom",
    "font_family": "JetBrainsMono Nerd Font",
    "font_size": 13,
    "line_height": "comfortable",
    "default_height": 260
  },
  "assistant": {
    "dock": "right",
    "default_width": 360,
    "version": "2",
    "default_model": {
      "provider": "openai",
      "model": "mlx-community/Qwen2.5-Coder-32B-Instruct-4bit"
    }
  },

  // 5. VS Code Navigation & Breadcrumbs
  "toolbar": {
    "breadcrumbs": true,
    "quick_actions": true
  },
  "tabs": {
    "git_status": true,
    "file_icons": true,
    "close_position": "right"
  },
  "scrollbar": {
    "show": "auto",
    "git_diff": true
  },

  // 6. Privacy & Telemetry
  "telemetry": {
    "metrics": false,
    "diagnostics": false
  },

  // 7. Dual-Tier AI Models: Local Qwen (MLX) + Google Cloud (Gemini / Antigravity)
  "language_models": {
    "openai": {
      "version": "1",
      "api_url": "http://localhost:8080/v1",
      "available_models": [
        {
          "name": "mlx-community/Qwen2.5-Coder-32B-Instruct-4bit",
          "display_name": "Local Qwen 2.5 Coder 32B (MLX)",
          "max_tokens": 32768
        },
        {
          "name": "mlx-community/Qwen2.5-Coder-14B-Instruct-4bit",
          "display_name": "Local Qwen 2.5 Coder 14B (MLX)",
          "max_tokens": 32768
        }
      ]
    },
    "google": {
      "api_url": "https://generativelanguage.googleapis.com"
    }
  }
}
```

---

## ⌨️ VS Code Muscle-Memory Keybinding Cheat Sheet in Zed

With `"base_keymap": "VSCode"` enabled, all standard VS Code shortcuts work identically:

| Action | VS Code Shortcut (macOS) | What It Does in Zed |
| :--- | :--- | :--- |
| **Quick File Open** | `Cmd + P` | Fuzzy search & jump to any file |
| **Command Palette** | `Cmd + Shift + P` | Access all editor commands |
| **Toggle Left Sidebar (File Explorer)** | `Cmd + B` | Show / Hide project file tree |
| **Toggle Bottom Terminal** | `Ctrl + ~` or `Cmd + J` | Show / Hide integrated terminal |
| **Global Project Search** | `Cmd + Shift + F` | Search text across entire project |
| **Multi-Cursor Select** | `Cmd + D` | Select next matching word |
| **Move Line Up / Down** | `Option + Up / Down` | Re-order line position |
| **Toggle Line Comment** | `Cmd + /` | Comment / uncomment lines |
| **Inline AI Transformation** | `Ctrl + Enter` (or `Cmd + ?`) | Prompt local Qwen at cursor/selection |
| **Toggle AI Assistant Chat** | `Cmd + Shift + E` | Open right-hand AI assistant panel |

---

## 🤝 The Dual-Tier Workflow in Practice

```
┌─────────────────────────────────────────────────────────────┐
│                    DAILY CODING ROUTINE                     │
│                                                             │
│ 1. Type `just serve-32b` in terminal                        │
│    (Launches MLX server on localhost:8080)                  │
│                                                             │
│ 2. Code inside ZED                                          │
│    • Instant, zero-lag editing (Rust + Metal GPU)           │
│    • Press `Ctrl + Enter` for instant local code generation │
│                                                             │
│ 3. Complex Architecture / Multi-File Planning               │
│    • Open ANTIGRAVITY on the same workspace folder          │
│    • Run autonomous builds, tests, and subagents            │
└─────────────────────────────────────────────────────────────┘
```

---

## Related Notes
* [[Dual-Tier AI Workflow]]
* [[Local LLMs with MLX]]
* [[Nix-Darwin Guide]]
* [[Setup Checklist]]
