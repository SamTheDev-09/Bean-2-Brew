# Prerequisites — human-side setup (do this ONCE, before the loop)

Everything below runs on **your machine** (12 GB VRAM GPU, 32 GB RAM). The build agent never does any of this — if a check fails, fix it here and re-run the check.

**Total time:** ~20–30 minutes (mostly model download if you haven't pulled one yet).

---

## 1. Baseline tools

```bash
node -v      # needs v20.19+ or v22+ — v22 LTS recommended. (Vite 8 hard requirement)
git --version
nvidia-smi   # your 12 GB GPU visible
git config user.name  && git config user.email   # must be set (commits happen in-loop)
```

If Node is wrong: install Node 22 LTS (e.g. `nvm install 22 && nvm use 22`).

## 2. Ollama + the coding model

You already run `qwen3.5:9b` — verify it's the tag Ollama sees:

```bash
ollama list          # note the EXACT tag (e.g. qwen3.5:9b). If yours differs, substitute everywhere below.
ollama run qwen3.5:9b "Say exactly: READY"
```

**Context size — important for 12 GB VRAM.** A 9B model at Q4_K_M uses ~6 GB for weights. Claude Code needs real context, but 32k KV cache eats ~4–5 GB more and can OOM the image headroom:

```bash
export OLLAMA_CONTEXT_LENGTH=16384    # put in ~/.bashrc — safe default: ~7-8 GB total
# After the loop starts, check actual usage once with: ollama ps
# If it shows < 9 GB used and you want more headroom for Claude Code's context,
# you may try 32768 — but revert to 16384 if you see OOM/instability.
```

Expected VRAM at steady state: **~7–8 GB of 12 GB**, leaving ~4 GB free.

## 3. Claude Code + the Anthropic-API bridge (claude-code-router)

Claude Code speaks the Anthropic API; Ollama speaks OpenAI. The router translates:

```bash
npm install -g @anthropic-ai/claude-code
npm install -g @musistudio/claude-code-router
```

Create `~/.claude-code-router/config.json`:

```json
{
  "Providers": [
    {
      "name": "ollama",
      "api_base_url": "http://localhost:11434/v1/chat/completions",
      "api_key": "ollama",
      "models": ["qwen3.5:9b"]
    }
  ],
  "Router": {
    "default": "ollama,qwen3.5:9b"
  }
}
```

*Substitute your exact `ollama list` tag if it differs.*
*Optional (recommended):* if you have an Anthropic/OpenRouter key, add a second provider and route `"think"` or `"longContext"` to it. That gives you an escape hatch for the rare hard step the 9B can't do — you switch one task to the hosted model, then resume the loop. The plan's BLOCKED-and-continue protocol covers you even without this.

## 4. Claude Code plugins (skills)

Marketplace verified to exist: `freshtechbro/claudedesignskills` (26 plugins; all five names below verified). Run once:

```bash
claude plugin marketplace add freshtechbro/claudedesignskills
claude plugin install threejs-webgl@claudedesignskills
claude plugin install react-three-fiber@claudedesignskills
claude plugin install gsap-scrolltrigger@claudedesignskills
claude plugin install motion-framer@claudedesignskills
claude plugin install lightweight-3d-effects@claudedesignskills
```

Do not install more (each adds context overhead for the 9B).

## 5. Image worker (OPTIONAL — model TBD)

The image sub-agent is **not required** for the loop: if unconfigured, the site ships with the committed SVG placeholder set (visually cohesive, palette-locked) and `STATUS.md` records it.

When you pick a model (e.g. Qwen-Image or FLUX via ComfyUI + GGUF), fill in `tools/README.md` §Config and set `IMAGE_WORKER_READY=1`. See that file for the two VRAM strategies (GPU-swap vs small-model-parallel).

## 6. Deploy CLI (OPTIONAL)

```bash
npm i -g vercel
vercel login          # interactive, one-time — or use a token
vercel whoami         # must print your account
```

If you skip this, task T6.4 simply records the deploy as pending with the exact command to run.

## 7. Pre-loop smoke test (3 minutes — catches 95% of setup failures)

```bash
# 1. Repo checks
cd <repo> && npm install && npm run build      # must pass (scaffold is committed)

# 2. Model + router check — start the bridge and run a trivial tool-call task
ccr code
```

Inside the `ccr code` session, send exactly:

> Create a file called `smoke.txt` in the repo root containing the single word `ping`. Then delete it. Reply when done.

It must create, delete, and confirm with working tool calls. Then `/exit`.

**If that trivial task fails** (broken tool calls, empty edits), the router/model pairing is the problem — re-check §2–§3 before running the real loop.

## 8. Start the loop

1. `ccr code` in the repo root.
2. Paste **The Loop Prompt** (see `LOOP_PROMPT.md` — the full text is also in the handoff).
3. Walk away. Expected runtime: 1–3 hours depending on your GPU token speed.
4. Things to watch (optional): `ollama ps` (VRAM), the `git log` growing one commit per task.

---

## What runs in parallel on your machine (VRAM budget)

| Process | VRAM | RAM | Notes |
|---|---|---|---|
| Ollama + qwen3.5:9b (16k ctx) | **~7–8 GB** | ~2 GB | The coding model. Resident the whole loop. |
| claude-code-router (CCR) | 0 | ~0.2 GB | Node proxy, CPU-only. |
| Claude Code CLI | 0 | ~0.2 GB | Thin client. |
| Your browser (keep light) | ~0.3–1 GB | — | GPU-accelerated tabs cost real VRAM; keep heavy tabs closed. |
| **Total** | **~8–9 GB of 12 GB** | — | ~3 GB headroom. |

**Do NOT run in parallel:**
* a large image model (12–20B class, e.g. FLUX/Qwen-Image GGUF ≈ 11–12 GB) — it does not fit alongside the 9B. The `tools/gen_image.sh` swap flow handles this (stops the LLM, renders, LLM auto-reloads).
* a second LLM in VRAM, games, or anything else that claims >2 GB.
* **True-parallel exception:** only a *small* image model (~2–4 GB, e.g. SDXL-Turbo class) can co-reside with the 9B. That's the only "run both at once" option — and it's the lowest-quality one. Decide together with the image-model choice.
