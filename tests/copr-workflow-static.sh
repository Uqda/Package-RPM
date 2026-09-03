#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WORKFLOW="$ROOT/.github/workflows/copr.yml"

test -f "$WORKFLOW"
grep -Fq 'types: [published]' "$WORKFLOW"
grep -Fq 'workflow_dispatch:' "$WORKFLOW"
grep -Fq 'COPR_CONFIG: ${{ secrets.COPR_CONFIG }}' "$WORKFLOW"
grep -Fq 'chmod 0600 "${HOME}/.config/copr"' "$WORKFLOW"
grep -Fq -- "--pattern '*.src.rpm'" "$WORKFLOW"
grep -Fq 'copr-cli build maher-xs/uqda' "$WORKFLOW"
if grep -Fq 'echo "${COPR_CONFIG}"' "$WORKFLOW" || grep -Eq '^[[:space:]]*set -x' "$WORKFLOW"; then
  echo "COPR workflow may expose credentials" >&2
  exit 1
fi

echo "COPR publishing workflow static gate passed"
