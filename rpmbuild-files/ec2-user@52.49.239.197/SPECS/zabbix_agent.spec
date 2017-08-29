Name: zabbix_agent
Version:  3.2.6
Release: 0.3
Summary: none
License: none

Source0:	%{name}-%{version}.tar.gz

Vendor:         ido.levy@allcloud.io

%description
installing zabbix_agent on amazon linux.

%prep
%setup -q %{name}


%build


%install
mkdir -p $RPM_BUILD_ROOT/var/tmp/zabbix_agent/
mkdir -p  $RPM_BUILD_ROOT/etc/init.d/
mkdir -p  $RPM_BUILD_ROOT/usr/local/bin/
mkdir -p   $RPM_BUILD_ROOT/usr/local/bin/
mkdir -p  $RPM_BUILD_ROOT/usr/local/etc/
mkdir -p  $RPM_BUILD_ROOT/usr/sbin


install -m 755 zabbix_agent $RPM_BUILD_ROOT/etc/init.d/
install   usr/local/bin/zabbix_get  $RPM_BUILD_ROOT/usr/local/bin/
install   usr/local/bin/zabbix_sender  $RPM_BUILD_ROOT/usr/local/bin/
install   usr/local/etc/zabbix_agentd.conf  $RPM_BUILD_ROOT/usr/local/etc/
install   zabbix_agentd  $RPM_BUILD_ROOT/usr/sbin


%files
/usr/local/bin/zabbix_get
/etc/init.d/zabbix_agent
/usr/local/bin/zabbix_sender
/usr/local/etc/zabbix_agentd.conf
/usr/sbin/zabbix_agentd
%doc

%post
mkdir -p /usr/local/etc/zabbix_agent.d/
chkconfig zabbix_agent on
echo "staring agent"
service zabbix_agent start









%changelog
