#!/usr/bin/env bash
# Bean 2 Brew — Stop-hook loop guard. READ-ONLY for the build agent.
# Claude Code runs this every time the agent tries to end its turn.
#   exit 0 -> allow the stop
#   exit 2 -> block the stop; stderr is fed back to the agent as its next instruction
# Allows the stop when: no tasks remain, a STOP file exists, or 3 stops in a row made no progress.
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/..}" 2>/dev/null || exit 0
cat >/dev/null 2>&1   # drain hook JSON from stdin (not needed)
[ -f STATUS.md ] || exit 0
[ -f STOP ] && { echo "Loop guard: STOP file present, allowing stop." >&2; exit 0; }

todo=$(grep -cE '^- \[ \] T[0-9]+\.[0-9]+' STATUS.md)
done_=$(grep -cE '^- \[[x!]\] T[0-9]+\.[0-9]+' STATUS.md)
[ "$todo" -eq 0 ] && exit 0

next=$(grep -m1 -E '^- \[ \] T[0-9]+\.[0-9]+' STATUS.md | sed -E 's/^- \[ \] (T[0-9]+\.[0-9]+).*/\1/')
state="${TMPDIR:-/tmp}/b2b-loop-$(pwd | cksum | cut -d' ' -f1)"
prev_done=-1; stalls=0
[ -f "$state" ] && read -r prev_done stalls < "$state"
if [ "$done_" -eq "$prev_done" ]; then stalls=$((stalls + 1)); else stalls=0; fi
echo "$done_ $stalls" > "$state"

if [ "$stalls" -ge 3 ]; then
  echo "Loop guard: no task finished across 3 stop attempts; allowing stop. Log the cause under STATUS.md → Open issues." >&2
  exit 0
fi

phase_start=""
case "$next" in T*.1) phase_start=" A new phase starts: re-read CLAUDE.md (loop + hard rules) and open only the phase file for $next.";; esac
echo "Loop guard: $todo task(s) remain. Do not stop. Continue with $next per CLAUDE.md: one task, bash scripts/check.sh $next, commit, next.${phase_start} If you just recovered from context compaction, re-read CLAUDE.md and STATUS.md first." >&2
exit 2
