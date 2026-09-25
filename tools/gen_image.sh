#!/usr/bin/env bash
# Image sub-agent entry point — MODEL TBD. See tools/README.md.
#
# Usage:
#   tools/gen_image.sh --selftest
#   tools/gen_image.sh "<prompt>" [reference_image_path] <output_path>
#
# Exit codes: 0 = success (file written), 3 = not configured, other = failure.
# The build loop (EXECUTION_PLAN.md T1.4) depends only on these contracts.
set -euo pipefail

MODEL="${IMAGE_MODEL_TAG:-TBD}"
COMFYUI_URL="${COMFYUI_URL:-}"
TIMEOUT_SECS=600

selftest() {
  if [ "${IMAGE_WORKER_READY:-0}" != "1" ]; then
    echo "image worker: NOT configured (IMAGE_WORKER_READY != 1). SVG placeholders remain the image set." >&2
    exit 3
  fi
  echo "image worker: ready (model=${MODEL})"
  exit 0
}

if [ "${1:-}" = "--selftest" ]; then
  selftest
fi

if [ "${IMAGE_WORKER_READY:-0}" != "1" ]; then
  echo "image worker: NOT configured (IMAGE_WORKER_READY != 1). See tools/README.md." >&2
  exit 3
fi

PROMPT="${1:?usage: gen_image.sh \"<prompt>\" [reference] <output>}"
REF="${2:-}"
OUT="${3:?usage: gen_image.sh \"<prompt>\" [reference] <output>}"

# ---------------------------------------------------------------------------
# TODO — implement once the image model is chosen (tools/README.md §Config):
#
# Strategy A (large model, GPU swap):
#   ollama stop "${OLLAMA_CODING_MODEL:-qwen3.5:9b}" || true
#   curl -sf "${COMFYUI_URL}/prompt" -H 'Content-Type: application/json' \
#     -d @workflow.json          # workflow.json built from MODEL + PROMPT (+ REF)
#   poll "${COMFYUI_URL}/history/<id>" until done (bounded by TIMEOUT_SECS)
#   download first output image -> "$OUT"
#   (Ollama auto-reloads the coding model on the next Claude Code request.)
#
# Strategy B (small model, resident):
#   curl -sf "${COMFYUI_URL}/prompt" ... same as above WITHOUT the ollama stop.
# ---------------------------------------------------------------------------
echo "image worker: model '${MODEL}' is TBD — backend not implemented." >&2
echo "Set IMAGE_WORKER_READY only after implementing the TODO block above." >&2
exit 3
