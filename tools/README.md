# Image worker (sub-agent) — contract & config

**Status: MODEL TBD** — the interface below is final; the model, download, and backend are intentionally left to one config block so the rest of the project never changes when you pick.

The build loop treats this as an **optional upgrade**: task T1.4 runs `tools/gen_image.sh --selftest`. Exit 0 → the worker generates the 8 images; any other exit → the committed SVG placeholders in `public/img/` are the final image set. The loop completes either way.

## Interface (final)

```bash
tools/gen_image.sh --selftest
tools/gen_image.sh "<prompt>" [reference_image_path] <output_path>
```

| Exit code | Meaning |
|---|---|
| 0 | success — image written to `<output_path>` |
| 3 | worker not configured (IMAGE_WORKER_READY != 1) |
| other | generation failed — caller keeps existing file |

Rules:
* Output must be a raster image (`.webp` preferred, `.png` fine) suitable for web.
* Generation must be bounded: the script enforces a 10-minute `timeout` per image.
* The worker must never modify the LLM's config permanently.

## VRAM strategies (pick one with your model)

Your GPU: **12 GB VRAM, 32 GB RAM**. Ollama + qwen3.5:9b at 16k context occupies ~7–8 GB resident.

### Strategy A — large model, GPU swap (recommended for FLUX-12B / Qwen-Image-20B GGUF)

Both models cannot co-reside (6 GB + 11–12 GB > 12 GB). Instead the script **swaps**:

1. `ollama stop qwen3.5:9b` → frees ~7–8 GB (the coding loop is blocked on this bash call anyway — the model is idle).
2. ComfyUI (started with `--reserve-vram 1`) renders with the GPU fully available (~11 GB).
3. Script exits; Ollama auto-reloads the 9B on the next Claude Code request (~10–30 s cold load, invisible to the loop).

Cost: ~30–60 s extra per image batch. Benefit: full-quality model at full speed.

### Strategy B — small model, true parallel (e.g. SDXL-Turbo class, ~2–4 GB)

The image backend stays resident in the ~4 GB of free VRAM alongside the LLM. No swap, instant generation, lower quality and weaker reference-image support.

**Reference-image note:** if the chosen model supports image-conditioned generation (img2img / reference / edit mode), pass the existing SVG or a previous image as `reference_image` for a cohesive set. If not, rely on the shared style suffix in the prompt list.

## Config block (fill in once the model is chosen)

```bash
# In the shell profile where Claude Code runs:
export IMAGE_WORKER_READY=1
export COMFYUI_URL="http://localhost:8188"      # Strategy A only
export IMAGE_MODEL_TAG="TBD"                     # exact model id used by the backend
```

Then implement the `TODO` section inside `tools/gen_image.sh`:
* **Strategy A:** `ollama stop qwen3.5:9b` → POST the prompt (+ reference) to ComfyUI `/prompt` using a saved workflow JSON → poll `/history` → download the first image to `<output_path>`.
* **Strategy B:** call the resident backend's HTTP endpoint directly (no ollama stop).

## Prompt list (8 images, stable filenames)

Shared style suffix for every prompt (keep it identical — that's what makes the set cohesive):

> `warm natural light, cozy artisanal cafe, cream and espresso brown palette with terracotta accents, soft depth of field, premium editorial photography, no text, no watermark`

| Target file | Prompt (prefix + shared suffix) |
|---|---|
| `public/img/hero-bg.webp` | `wide cinematic shot of a cozy cafe interior at golden morning hour, wooden tables, soft steam rising from cups, plants by the window` + suffix |
| `public/img/story-space.webp` | `the front counter of a small neighborhood cafe, a friendly barista mid-pour, warm wooden bar, shelves of jars behind` + suffix |
| `public/img/gallery-01.webp` | `cafe interior wide angle, warm light through large windows, wooden stools and plants` + suffix |
| `public/img/gallery-02.webp` | `close-up of a vanilla latte with delicate latte art on a cream ceramic cup, wooden table` + suffix |
| `public/img/gallery-03.webp` | `almond croissants and pastries in a glass display case, warm backlight` + suffix |
| `public/img/gallery-04.webp` | `barista pouring espresso into a small cup, steam, motion and warmth` + suffix |
| `public/img/gallery-05.webp` | `cafe exterior in the morning, awning, chalkboard menu on the sidewalk, soft street light` + suffix |
| `public/img/gallery-06.webp` | `window seat with a cup of coffee and fresh pastries, morning light, inviting` + suffix |

If a generated image looks off-brand or contains text/artifacts: re-run that one prompt with a stricter prefix (e.g. add `plain, uncluttered, no people` or `empty table, no faces`). Max 2 retries per image, then keep the SVG placeholder for that slot (record it in `STATUS.md`).
