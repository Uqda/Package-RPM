#!/bin/sh
set -eu

RPM=${1:?usage: inspect-rpm.sh path-to-uqda-rpm}
VERSION=$(cat "$(dirname "$0")/../VERSION")

test "$(rpm -qp --qf '%{NAME}' "$RPM")" = uqda
test "$(rpm -qp --qf '%{VERSION}' "$RPM")" = "$VERSION"
rpm -qlp "$RPM" | grep -Fx '/usr/bin/uqda'
rpm -qlp "$RPM" | grep -Fx '/usr/bin/uqdactl'
rpm -qlp "$RPM" | grep -Fx '/usr/bin/uqda-latency'
rpm -qlp "$RPM" | grep -Fx '/usr/lib/systemd/system/uqda.service'
rpm -qlp "$RPM" | grep -Fx '/usr/lib/systemd/system/uqda-default-config.service'
rpm -qplv "$RPM" | grep -E -- '-rwxr-xr-x.* /usr/bin/uqda$'
rpm -qplv "$RPM" | grep -E -- '-rw-r--r--.* /usr/lib/systemd/system/uqda.service$'
echo "RPM payload inspection passed"
