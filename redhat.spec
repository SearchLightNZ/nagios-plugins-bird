%define nagiospluginsdir %{_libdir}/nagios/plugins

Name: nagios-plugins-bird
Version: 0.4.2
Release: 1%{?dist}
Summary: Nagios plugins for Bird
Source0: https://codeload.github.com/ninech/nagios-plugins-bird/tar.gz/upstream/%{version}

License: MIT
URL: https://github.com/ninech/nagios-plugins-bird

BuildRequires: perl-generators
BuildRequires: perl(ExtUtils::MakeMaker)
BuildRequires: perl(Test::More)
BuildRequires: perl(Module::Install)
BuildRequires: perl(Monitoring::Plugin)
BuildRequires: perl(Readonly)

Requires: nagios-plugins
Requires: yum-plugin-security
Requires: perl(Monitoring::Plugin)

%description
This package provides a set of plugins to monitor the bird service.

%prep
%setup -q -n nagios-plugins-bird-upstream-%{version}

%build

%install
rm -rf %{buildroot}
install -d %{buildroot}%{nagiospluginsdir}
install -m 0755 src/plugins/* %{buildroot}%{nagiospluginsdir}

%files
%doc AUTHORS CHANGELOG README.md LICENSE
%{nagiospluginsdir}/*
