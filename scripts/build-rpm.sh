#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VERSION=$(cat "$ROOT/VERSION")
RELEASE=$(cat "$ROOT/RELEASE")
ARCHIVE="uqda-v${VERSION}-vendored-source.tar.gz"
SOURCE_URL="https://github.com/Uqda/Core/releases/download/v${VERSION}/${ARCHIVE}"
TOPDIR=${RPM_TOPDIR:-"$ROOT/rpmbuild"}
OUTDIR=${RPM_OUTDIR:-"$ROOT/artifacts"}

case "$VERSION" in *[!0-9.]*|'') echo "invalid VERSION: $VERSION" >&2; exit 1 ;; esac
case "$RELEASE" in *[!0-9]*|'') echo "invalid RELEASE: $RELEASE" >&2; exit 1 ;; esac

mkdir -p "$TOPDIR"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} "$OUTDIR"
cp "$ROOT/uqda.spec" "$TOPDIR/SPECS/uqda.spec"
curl --fail --location --retry 3 --output "$TOPDIR/SOURCES/$ARCHIVE" "$SOURCE_URL"
(cd "$TOPDIR/SOURCES" && sha256sum --check "$ROOT/SOURCE_SHA256")

rpmbuild -ba \
  --define "_topdir $TOPDIR" \
  --define "version_override $VERSION" \
  --define "release_override $RELEASE" \
  "$TOPDIR/SPECS/uqda.spec"

find "$TOPDIR/RPMS" "$TOPDIR/SRPMS" -type f -name '*.rpm' -exec cp -v {} "$OUTDIR/" \;
