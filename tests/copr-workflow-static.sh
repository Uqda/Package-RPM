#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
WORKFLOW="$ROOT/.github/workflows/copr.yml"

test -f "$WORKFLOW"
grep -Fq 'types: [published]' "$WORKFLOW"
grep -Fq "'copr/v[0-9]+.[0-9]+.[0-9]+-[0-9]+'" "$WORKFLOW"
grep -Fq 'workflow_dispatch:' "$WORKFLOW"
grep -Fq 'COPR_CONFIG: ${{ secrets.COPR_CONFIG }}' "$WORKFLOW"
grep -Fq 'chmod 0600 "${HOME}/.config/copr"' "$WORKFLOW"
grep -Fq -- "--pattern '*.src.rpm'" "$WORKFLOW"
grep -Fq 'gh release view "${TAG}" --repo Uqda/Package-RPM' "$WORKFLOW"
grep -Fq 'copr-cli build maher-xs/uqda' "$WORKFLOW"
grep -Fq 'needs: publish' "$WORKFLOW"
grep -Fq 'image: [fedora:43, fedora:44]' "$WORKFLOW"
grep -Fq 'dnf -y copr enable maher-xs/uqda' "$WORKFLOW"
grep -Fq 'dnf -y install uqda uqda-gateway' "$WORKFLOW"
grep -Fq 'rpm -V uqda uqda-gateway' "$WORKFLOW"
if grep -Fq 'echo "${COPR_CONFIG}"' "$WORKFLOW" || grep -Eq '^[[:space:]]*set -x' "$WORKFLOW"; then
  echo "COPR workflow may expose credentials" >&2
  exit 1
fi

echo "COPR publishing workflow static gate passed"
