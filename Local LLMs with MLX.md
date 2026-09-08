---
title: Local LLMs with MLX
tags:
  - mlx
  - llm
  - qwen
  - setup
  - python
created: 2026-08-24
---

# ⚡ Local LLMs with Apple MLX

## Why Apple MLX?
[Apple MLX](https://github.com/ml-explore/mlx) is an open-source machine learning framework engineered specifically for Apple Silicon and Metal GPU acceleration. 

* **Zero-copy memory sharing:** CPU and GPU share the same memory without PCIe transfer overhead.
* **Native 4-bit / 8-bit quantization:** Minimizes memory footprint while preserving accuracy.
* **Optimized token generation:** Outperforms generic CPU/cross-platform runtimes on M-series chips.

---

## Zero-Bloat Execution with `uv`

To avoid polluting your global macOS environment with Python packages, use **`uv`** (by Astral) to run `mlx-lm` in ephemeral virtual environments.

### 1. Install `uv`
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Launch OpenAI-Compatible MLX Server

Run the server on-demand without installing anything permanently into system Python:

#### Primary Workhorse: Qwen 2.5 Coder 32B (4-bit)
```bash
uvx --from mlx-lm mlx_lm.server \
  --model mlx-community/Qwen2.5-Coder-32B-Instruct-4bit \
  --port 8080 \
  --chat-template-name chatml
```

#### Fast Multitasking: Qwen 2.5 Coder 14B (4-bit)
```bash
uvx --from mlx-lm mlx_lm.server \
  --model mlx-community/Qwen2.5-Coder-14B-Instruct-4bit \
  --port 8080
```

---

## 🚀 oMLX: The Ultimate Inference Server for AI Coding Agents

[oMLX](https://github.com/jundot/omlx) is an advanced MLX-based inference server specifically engineered for **local coding agents** (Claude Code, Cursor, Zed, Aider, OpenHands) on Apple Silicon Macs.

### The Problem with Standard Local Servers in Agentic Workflows
In multi-turn coding sessions, agents repeatedly send large prompt prefixes (system instructions + codebase summaries + conversation history). 
* With vanilla `mlx-lm` or `llama.cpp`, the server recomputes the entire context from scratch on every turn, causing **5–15 second latency delays (Time-to-First-Token)**.

### How oMLX Fixes It (Paged SSD KV Caching)
* **Tier 1 (RAM):** Active KV cache blocks remain in unified memory.
* **Tier 2 (NVMe SSD):** Historical and branched KV cache blocks are saved to your Mac's ultra-fast internal SSD in `safetensors` format.
* **Instant Prefix Restoration:** When an agent sends a new turn with a known prefix, oMLX loads the cached state from SSD in milliseconds.
* **Result:** Time-to-First-Token (TTFT) drops from **10+ seconds to $< 0.5$ seconds**!

### Key Features of oMLX
1. **Dual API Compatibility:** Exposes both **OpenAI** (`/v1/chat/completions`) and **Anthropic** (`/v1/messages`) endpoints.
2. **Native macOS Menu Bar App:** Written in PyObjC (zero Electron bloat) for monitoring token speeds and memory usage.
3. **Continuous Batching:** Processes concurrent requests without blocking.

### Running oMLX
```bash
# Launch via oMLX.app GUI menu bar app, or via CLI:
omlx serve --model mlx-community/Qwen2.5-Coder-32B-Instruct-4bit --port 8080
```

---

---

## ✍️ Tab Autocomplete (FIM) vs. Chat / Agent Models

Tab autocomplete has fundamentally different latency and architectural requirements than chat/agent pair-programming:

| Modality | Target Latency | Best Local Model Size | Recommended Tooling |
| :--- | :--- | :--- | :--- |
| **Tab Autocomplete (FIM)** | `< 50ms` per keystroke | **Qwen 2.5 Coder 1.5B / 7B (Base)** | **VS Code + Continue.dev** or **Zed** |
| **Chat, Refactoring & Agents** | `200ms – 1s` | **Qwen 2.5 Coder 32B (Instruct)** | **Antigravity**, **Cursor**, **Aider** |

### How IDEs Handle Local Tab Completion:
1. **Antigravity IDE**: Uses **Antigravity Tab** (Google DeepMind's proprietary next-intent speculative decoding engine). It is optimized for cloud sub-50ms latency and does not natively support rerouting autocomplete to a custom local endpoint.
2. **VS Code + [Continue.dev](https://continue.dev)**: The industry standard for local tab-completion. Allows you to set `tabAutocompleteModel` to your local MLX/Ollama endpoint using a lightweight model (`qwen2.5-coder:1.5b-base`).
3. **Zed Editor**: Native macOS Rust editor with built-in native support for local Ollama/MLX autocompletion.
4. **Cursor**: Features built-in custom OpenAI API support for chat, while its proprietary "Cursor Tab" routes through Cursor's multi-token prediction engine.

---

## Model Cache Location & Cleanup

MLX caches downloaded Hugging Face model weights in:
`~/.cache/huggingface/hub/`

To inspect or clean up model storage:
```bash
# Check size of downloaded models
du -sh ~/.cache/huggingface/hub/

# Delete a specific model to free disk space
rm -rf ~/.cache/huggingface/hub/models--mlx-community--Qwen2.5-Coder-32B-Instruct-4bit
```

---

## Related Notes
* [[Hardware & Memory Budget]]
* [[System Architecture]]
* [[Mac Cleanliness & Anti-Bloat Guide]]
