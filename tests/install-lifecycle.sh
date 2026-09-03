#!/bin/sh
set -eu

RPM=${1:?usage: install-lifecycle.sh path-to-uqda-rpm}
VERSION=$(cat "$(dirname "$0")/../VERSION")

dnf -y install "$RPM"
uqda -version | grep -F "Build version: $VERSION"
uqdactl -version | grep -F "Build version: $VERSION"
uqda-latency ::1 --help >/dev/null
systemd-analyze verify /usr/lib/systemd/system/uqda.service /usr/lib/systemd/system/uqda-default-config.service

umask 077
uqda -genconf > /etc/uqda.conf
test "$(stat -c '%a' /etc/uqda.conf)" = 600
BEFORE=$(sha256sum /etc/uqda.conf)
dnf -y reinstall "$RPM"
test "$BEFORE" = "$(sha256sum /etc/uqda.conf)"
uqda -useconffile /etc/uqda.conf -address | grep -Eq '^2[0-9a-f:]+$'

dnf -y remove uqda
test -f /etc/uqda.conf
echo "Install, reinstall, identity-preservation and removal lifecycle passed"
