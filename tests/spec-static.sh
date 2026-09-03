#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VERSION=$(cat "$ROOT/VERSION")
RELEASE=$(cat "$ROOT/RELEASE")

SPEC_VERSION=$(rpmspec -q --qf '%{NAME} %{VERSION}\n' "$ROOT/uqda.spec" | awk '$1 == "uqda" { print $2 }')
SPEC_RELEASE=$(rpmspec -q --qf '%{NAME} %{RELEASE}\n' "$ROOT/uqda.spec" | awk '$1 == "uqda" { print $2 }')
test "$SPEC_VERSION" = "$VERSION" || { echo "spec VERSION mismatch: $SPEC_VERSION" >&2; exit 1; }
case "$SPEC_RELEASE" in "$RELEASE"*) : ;; *) echo "spec RELEASE mismatch: $SPEC_RELEASE" >&2; exit 1 ;; esac
grep -Fq 'uqda-v%{version}-vendored-source.tar.gz' "$ROOT/uqda.spec"
grep -Fq '%{_unitdir}/uqda.service' "$ROOT/uqda.spec"
grep -Fq 'install -Dpm 0644 contrib/systemd/uqda.service' "$ROOT/uqda.spec"
grep -Fq 'GOFLAGS="-mod=vendor -trimpath"' "$ROOT/uqda.spec"
grep -Fq 'golang >= 1.25.13' "$ROOT/uqda.spec"
grep -Fq 'uqda-gateway' "$ROOT/uqda.spec"
grep -Fq 'uqda-latency' "$ROOT/uqda.spec"
test "$(wc -l < "$ROOT/SOURCE_SHA256" | tr -d ' ')" = 1
if grep -Eiq '(^|[^a-z])yggdrasil([^a-z]|$)' "$ROOT/uqda.spec"; then
  echo "legacy Yggdrasil branding found in uqda.spec" >&2
  exit 1
fi
echo "RPM static gate passed for UQDA ${VERSION}-${RELEASE}"
