Name:           uqda
Version:        0.1.4
Release:        1%{?dist}
Summary:        Encrypted self-organizing IPv6 overlay network

License:        LGPL-3.0-only WITH LicenseRef-UQDA-Static-Linking-Exception
URL:            https://github.com/Uqda/Core
Source0:        https://github.com/Uqda/Core/releases/download/v%{version}/uqda-v%{version}-vendored-source.tar.gz

BuildRequires:  golang >= 1.25.13
BuildRequires:  systemd-rpm-macros
Requires:       iproute
Requires:       iputils
Requires:       systemd
Recommends:     kmod

%description
UQDA creates encrypted, self-organizing IPv6 overlay networks over existing
IPv4 or IPv6 links. This package contains the node daemon, the local
administration client, latency diagnostics, and systemd integration.

%package gateway
Summary:        Home and cafe gateway helper for UQDA
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:       NetworkManager
Requires:       iproute
Requires:       iw
Requires:       nftables
Requires:       radvd

%description gateway
The optional UQDA gateway helper configures a NetworkManager-based home or
hardened cafe access point and advertises the node's routed UQDA IPv6 prefix.

%prep
%autosetup -c -n %{name}-%{version}

%build
export CGO_ENABLED=0
export GOFLAGS="-mod=vendor -trimpath"
export PKGNAME="uqda"
export PKGVER="%{version}"
./build -t -p

%install
install -Dpm 0755 uqda %{buildroot}%{_bindir}/uqda
install -Dpm 0755 uqdactl %{buildroot}%{_bindir}/uqdactl
install -Dpm 0755 contrib/performance/uqda-latency %{buildroot}%{_bindir}/uqda-latency
install -Dpm 0755 contrib/gateway/uqda-gateway %{buildroot}%{_bindir}/uqda-gateway
install -Dpm 0644 contrib/systemd/uqda.service %{buildroot}%{_unitdir}/uqda.service
install -Dpm 0644 contrib/systemd/uqda-default-config.service %{buildroot}%{_unitdir}/uqda-default-config.service

%check
export CGO_ENABLED=0
export GOFLAGS="-mod=vendor -trimpath"
go test ./...
./uqda -version | grep -F "Build version: %{version}"
./uqdactl -version | grep -F "Build version: %{version}"
sh -n contrib/performance/uqda-latency
sh -n contrib/gateway/uqda-gateway

%files
%license LICENSE
%doc NOTICE.md README.md README_AR.md SECURITY.md
%{_bindir}/uqda
%{_bindir}/uqdactl
%{_bindir}/uqda-latency
%{_unitdir}/uqda.service
%{_unitdir}/uqda-default-config.service

%files gateway
%{_bindir}/uqda-gateway

%post
%systemd_post uqda.service
%systemd_post uqda-default-config.service

%preun
%systemd_preun uqda.service
%systemd_preun uqda-default-config.service

%postun
%systemd_postun_with_restart uqda.service
%systemd_postun_with_restart uqda-default-config.service

%changelog
* Thu Sep 03 2026 UQDA Project <maintainers@uqda.invalid> - 0.1.4-1
- First official UQDA RPM packaging release.
- Build offline from the verified vendored source archive.
- Add systemd, latency diagnostics, and optional gateway integration.
