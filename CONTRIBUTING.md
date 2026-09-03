# Contributing

Change `VERSION` only when tracking a new UQDA Core release. Increment `RELEASE`
for packaging-only changes and reset it to `1` for a new Core version. Update the
source checksum, changelog, spec changelog, and tests together.

Run `tests/spec-static.sh` and `scripts/build-rpm.sh` on Fedora before opening a
pull request. Releases must be produced by the repository workflow, never by
uploading locally built RPMs.
