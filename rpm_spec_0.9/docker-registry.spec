%{!?python_sitelib: %global python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

# removed "|| 0%{?rhel} >= 7" as the rhel version is maintained separately
%if 0%{?fedora} >= 19 || 0%{?rhel} >= 7
%bcond_without  systemd
%endif

Summary:        Registry server for Docker
Name:           docker-registry
Version:        0.9.0
Release:        2%{?dist}
License:        ASL 2.0
URL:            https://github.com/dotcloud/%{name}
Source:         https://github.com/dotcloud/%{name}/archive/%{version}.tar.gz
Source1:        docker-registry.service
Source2:        docker-registry.sysconfig
Source3:        docker-registry.sysvinit

BuildRequires:      python2-devel
%if %{with systemd}
BuildRequires:      systemd
Requires(post):     systemd
Requires(preun):    systemd
Requires(postun):   systemd
%else
Requires(post):     chkconfig
Requires(preun):    chkconfig
Requires(postun):   initscripts
Requires:           python-importlib
%endif

Requires:       PyYAML
Requires:       python-argparse
Requires:       python-backports-lzma
Requires:       python-blinker
Requires:       python-docker-registry-core >= 2.0.1-2
Requires:       python-flask
Requires:       python-gevent
Requires:       python-gunicorn
Requires:       python-jinja2
Requires:       python-requests
Requires:       python-rsa
Requires:       python-simplejson
Requires:       python-sqlalchemy
BuildArch:      noarch

%description
Registry server for Docker (hosting/delivering of repositories and images).

%prep
%setup -q -n %{name}-%{version}

# Remove the golang implementation
# It's not the main one (yet?)
rm -rf contrib/golang_impl
find . -name "*.py" \
         -print |\
         xargs sed -i '/flask_cors/d'

%build
%{__python} setup.py build

%install
install -d %{buildroot}%{_sysconfdir}/sysconfig
install -d %{buildroot}%{_sharedstatedir}/%{name}
install -d %{buildroot}%{python_sitelib}/%{name}

install -pm 644 %{SOURCE2} %{buildroot}%{_sysconfdir}/sysconfig/%{name}

%if %{with systemd}
install -d %{buildroot}%{_unitdir}
install -pm 644 %{SOURCE1} %{buildroot}%{_unitdir}/%{name}.service
# Make sure we set proper WorkingDir in the systemd service file
sed -i "s|#WORKDIR#|%{python_sitelib}/%{name}|" %{buildroot}%{_unitdir}/%{name}.service
%else
install -d %{buildroot}%{_initddir}
install -pm 755 %{SOURCE3} %{buildroot}%{_initddir}/%{name}
# Make sure we set proper working dir in the sysvinit file
sed -i "s|#WORKDIR#|%{python_sitelib}/%{name}|" %{buildroot}%{_initddir}/%{name}
%endif

cp -pr docker_registry tests %{buildroot}%{python_sitelib}/%{name}
cp config/config_sample.yml %{buildroot}%{_sysconfdir}/%{name}.yml
sed -i 's/\/tmp\/registry/\/var\/lib\/docker-registry/g' %{buildroot}%{_sysconfdir}/%{name}.yml

%post
%if %{with systemd}
%systemd_post %{name}.service
%else
/sbin/chkconfig --add %{name}
%endif

%preun
%if %{with systemd}
%systemd_preun %{name}.service
%else
if [ $1 -eq 0 ] ; then
    /sbin/service %{name} stop >/dev/null 2>&1
    /sbin/chkconfig --del %{name}
fi
%endif

%postun
%if %{with systemd}
%systemd_postun_with_restart %{name}.service
%else
if [ "$1" -ge "1" ] ; then
    /sbin/service %{name} condrestart >/dev/null 2>&1 || :
fi
%endif

%files
%doc AUTHORS CHANGELOG.md CONTRIBUTING.md
%doc LICENSE README.md
%config(noreplace) %{_sysconfdir}/sysconfig/%{name}
%config(noreplace) %{_sysconfdir}/%{name}.yml
%dir %{python_sitelib}/%{name}
%dir %{python_sitelib}/%{name}/docker_registry
%{python_sitelib}/%{name}/docker_registry/*.py
%{python_sitelib}/%{name}/docker_registry/*.pyc
%{python_sitelib}/%{name}/docker_registry/*.pyo
%dir %{python_sitelib}/%{name}/docker_registry/storage
%{python_sitelib}/%{name}/docker_registry/storage/*.py
%{python_sitelib}/%{name}/docker_registry/storage/*.pyc
%{python_sitelib}/%{name}/docker_registry/storage/*.pyo
%dir %{python_sitelib}/%{name}/docker_registry/lib
%{python_sitelib}/%{name}/docker_registry/lib/*.py
%{python_sitelib}/%{name}/docker_registry/lib/*.pyc
%{python_sitelib}/%{name}/docker_registry/lib/*.pyo
%dir %{python_sitelib}/%{name}/docker_registry/lib/index
%{python_sitelib}/%{name}/docker_registry/lib/index/*.py
%{python_sitelib}/%{name}/docker_registry/lib/index/*.pyc
%{python_sitelib}/%{name}/docker_registry/lib/index/*.pyo
%dir %{python_sitelib}/%{name}/docker_registry/drivers
%{python_sitelib}/%{name}/docker_registry/drivers/*.py
%{python_sitelib}/%{name}/docker_registry/drivers/*.pyc
%{python_sitelib}/%{name}/docker_registry/drivers/*.pyo
%dir %{python_sitelib}/%{name}/docker_registry/server
%{python_sitelib}/%{name}/docker_registry/server/*.py
%{python_sitelib}/%{name}/docker_registry/server/*.pyc
%{python_sitelib}/%{name}/docker_registry/server/*.pyo
%dir %{python_sitelib}/%{name}/tests
%{python_sitelib}/%{name}/tests/*.py
%{python_sitelib}/%{name}/tests/*.pyc
%{python_sitelib}/%{name}/tests/*.pyo
%dir %{python_sitelib}/%{name}/tests/data
%dir %{python_sitelib}/%{name}/tests/data/46af0962ab5afeb5ce6740d4d91652e69206fc991fd5328c1a94d364ad00e457
%{python_sitelib}/%{name}/tests/data/46af0962ab5afeb5ce6740d4d91652e69206fc991fd5328c1a94d364ad00e457/json
%{python_sitelib}/%{name}/tests/data/46af0962ab5afeb5ce6740d4d91652e69206fc991fd5328c1a94d364ad00e457/layer.tar
%dir %{python_sitelib}/%{name}/tests/data/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158
%{python_sitelib}/%{name}/tests/data/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/json
%{python_sitelib}/%{name}/tests/data/511136ea3c5a64f264b78b5433614aec563103b4d4702f3ba7d4d2698e22c158/layer.tar
%dir %{python_sitelib}/%{name}/tests/data/xattr
%{python_sitelib}/%{name}/tests/data/xattr/json
%{python_sitelib}/%{name}/tests/data/xattr/layer.tar
%dir %{python_sitelib}/%{name}/tests/fixtures
%{python_sitelib}/%{name}/tests/fixtures/test_config.yaml
%dir %{python_sitelib}/%{name}/tests/lib
%{python_sitelib}/%{name}/tests/lib/*.py
%{python_sitelib}/%{name}/tests/lib/*.pyc
%{python_sitelib}/%{name}/tests/lib/*.pyo
%dir %{python_sitelib}/%{name}/tests/lib/index
%{python_sitelib}/%{name}/tests/lib/index/*.py*
%dir %{python_sitelib}/%{name}/docker_registry/extensions
%{python_sitelib}/%{name}/docker_registry/extensions/*
%dir %{python_sitelib}/%{name}/docker_registry/extras
%{python_sitelib}/%{name}/docker_registry/extras/*
%dir %{_sharedstatedir}/%{name}
%if %{with systemd}
%{_unitdir}/%{name}.service
%else
%{_initddir}/%{name}
%endif

%changelog
* Fri Sep 05 2014 Lokesh Mandvekar <lsm5@fedoraproject.org> - 0.8.1-2
- Resolves: rhbz#1137026 - remove flask_cors (not packaged yet)
- Package owns all dirs created
- update runtime requirements

* Tue Sep 02 2014 Lokesh Mandvekar <lsm5@fedoraproject.org> - 0.8.1-1
- Resolves: rhbz#1130008 - upstream release 0.8.1

* Mon Aug 11 2014 Lokesh Mandvekar <lsm5@fedoraproject.org> - 0.7.3-1
- Resolves: rhbz#1111813 - upstream release 0.7.3
- Resolves: rhbz#1120214 - unitfile doesn't use redis.service

* Sat Jun 07 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.7.1-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Thu Jun 05 2014 Marek Goldmann <mgoldman@redhat.com> - 0.7.1-2
- Require python-importlib for EPEL 6

* Thu Jun 05 2014 Marek Goldmann <mgoldman@redhat.com> - 0.7.1-1
- Upstream release 0.7.1

* Fri Apr 18 2014 Marek Goldmann <mgoldman@redhat.com> - 0.6.8-1
- Upstream release 0.6.8

* Mon Apr 07 2014 Marek Goldmann <mgoldman@redhat.com> - 0.6.6-2
- docker-registry settings in /etc/sysconfig/docker-registry not honored,
  RHBZ#1072523

* Thu Mar 20 2014 Marek Goldmann <mgoldman@redhat.com> - 0.6.6-1
- Upstream release 0.6.6
- docker-registry cannot import module jinja2, RHBZ#1077630

* Mon Feb 17 2014 Marek Goldmann <mgoldman@redhat.com> - 0.6.5-1
- Upstream release 0.6.5

* Tue Jan 07 2014 Marek Goldmann <mgoldman@redhat.com> - 0.6.3-1
- Upstream release 0.6.3
- Added python-backports-lzma and python-rsa to R
- Removed configuration file path patch, it's in upstream

* Fri Dec 06 2013 Marek Goldmann <mgoldman@redhat.com> - 0.6.0-4
- Docker-registry does not currently support moving the config file, RHBZ#1038874

* Mon Dec 02 2013 Marek Goldmann <mgoldman@redhat.com> - 0.6.0-3
- EPEL support
- Comments in the sysconfig/docker-registry file

* Wed Nov 27 2013 Marek Goldmann <mgoldman@redhat.com> - 0.6.0-2
- Added license and readme

* Wed Nov 20 2013 Marek Goldmann <mgoldman@redhat.com> - 0.6.0-1
- Initial packaging
