# UQDA RPM Packaging

Official RPM packaging for [UQDA Core](https://github.com/Uqda/Core), covering
Fedora and compatible RPM-based systems. The first packaging release tracks
UQDA Core `0.1.4` as RPM revision `1`, producing `uqda-0.1.4-1`.

The build consumes the checksum-pinned vendored source archive from the matching
Core release and forces Go's offline vendor mode. It produces:

- `uqda`: daemon, `uqdactl`, `uqda-latency`, and systemd units;
- `uqda-gateway`: optional NetworkManager gateway integration;
- a source RPM.

## Install from Fedora COPR

```sh
sudo dnf install -y dnf5-plugins
sudo dnf copr enable maher-xs/uqda
sudo dnf install uqda
sudo systemctl enable --now uqda
sudo uqdactl doctor
```

Install the optional gateway helper with:

```sh
sudo dnf install uqda-gateway
```

## Local build on Fedora

```sh
sudo dnf install -y rpm-build rpmdevtools rpmlint golang systemd-rpm-macros curl
./tests/spec-static.sh
./scripts/build-rpm.sh
```

Artifacts are written to `artifacts/`. Inspect and install the main package:

```sh
MAIN_RPM=$(find artifacts -name 'uqda-[0-9]*.rpm' ! -name '*.src.rpm' -print -quit)
./tests/inspect-rpm.sh "$MAIN_RPM"
sudo dnf install "./$MAIN_RPM"
sudo systemctl enable --now uqda
sudo uqdactl doctor
```

`/etc/uqda.conf` is generated with mode `0600` on first service start. It is not
owned as a replaceable payload and remains in place across upgrades and package
removal so the node identity is not silently destroyed.

## Release policy

Packaging tags use `v<core-version>-<rpm-release>`, for example `v0.1.4-1`.
Changes merge only after the RPM Release Gate passes. Official GitHub releases
include binary/source RPMs, SHA-256 checksums, a keyless Sigstore bundle, and
GitHub build-provenance attestations.

This package does not turn UQDA into an anonymity system. Keep an IPv6 firewall
enabled and protect `/etc/uqda.conf` and the local administration socket.

## Origin

This repository is inspired by
[`yggdrasil-package-rpm`](https://github.com/yggdrasil-network/yggdrasil-package-rpm)
but its specification, source verification, tests, release gates, paths, and
branding are maintained independently for UQDA. See `NOTICE.md`.
