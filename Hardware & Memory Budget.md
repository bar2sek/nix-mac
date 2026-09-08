---
title: Hardware & Memory Budget
tags:
  - hardware
  - memory
  - m5-pro
  - qwen
created: 2026-08-24
---

# 🧠 Hardware & Memory Budget

## Target Specifications
* **Machine:** MacBook Pro
* **Processor:** Apple M5 Pro
* **Unified Memory:** 48 GB
* **Storage Consideration:** Fast internal NVMe (essential for rapid model weight loading)

---

## Model Sizing & RAM Allocation

The **48GB Unified Memory Architecture (UMA)** allows dynamic sharing between the CPU, GPU, and OS. Below is the realistic memory allocation breakdown:

| Workload Scenario | Qwen Model & Quantization | Model Weight RAM | Context Buffer (32k) | OS & Base Apps | Free / Container RAM |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Heavy Coding / Agentic** | **Qwen 2.5 Coder 32B (4-bit)** | ~19.5 GB | ~3.5 GB | ~6.0 GB | **~19.0 GB** |
| **Balanced Multitasking** | **Qwen 2.5 Coder 14B (4-bit)** | ~8.8 GB | ~2.0 GB | ~6.0 GB | **~31.2 GB** |
| **High Precision / Math** | **Qwen 2.5 Coder 14B (8-bit)** | ~15.5 GB | ~2.5 GB | ~6.0 GB | **~24.0 GB** |
| **Lightweight / Speed** | **Qwen 2.5 Coder 7B (4-bit)** | ~4.5 GB | ~1.2 GB | ~6.0 GB | **~36.3 GB** |

---

## Key Takeaways for 48GB Configuration

> [!NOTE]
> **Qwen 2.5 Coder 32B (4-bit)** is the sweet spot for the 48GB M5 Pro. It provides near GPT-4o-level coding intelligence while leaving ~19GB of memory completely free for Docker/OrbStack containers, IDEs, browser tabs, and compilation tasks.

### Max Context Window Guidelines
* Apple Silicon uses memory dynamically for the Key-Value (KV) cache.
* At 4-bit quantization, `Qwen2.5-Coder-32B` consumes ~0.1 GB per 1,000 tokens of context.
* Running at a full 32,768 context window adds ~3.2–3.5 GB to the model footprint.

---

## Related Notes
* [[System Architecture]]
* [[Local LLMs with MLX]]
