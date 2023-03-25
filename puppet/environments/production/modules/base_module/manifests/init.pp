## base module to set common settings across all servers
class base_module {

# get our public ip, resolve it to the public FQDN to decide which apt repo is closest
# $pub_ip = inline_template("<%= `/usr/bin/dig +short myip.opendns.com @resolver1.opendns.com` %>")
# $pub_hostname = inline_template("<%= `/usr/bin/dig -x +short ${pub_ip}` %>")

# for troubleshooting only
#notify { "STDOUT: ${pub_ip}": }
#notify { "STDOUT: ${pub_hostname}": }

## place our own apt repo

file {'/etc/apt/sources.list':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/base_module/common/lan.apt.list',
    notify => Exec['apt refresh'],
}


# make sure we've got a clean apt cache
exec {'apt refresh':
  command     => '/usr/bin/apt clean && /usr/bin/apt update',
  refreshonly => true,
}

## install necessary packages
$base_packages = [ 'net-tools', 'nano', 'jq', 'git', 'htop', 'gpg', 'tuned-utils-systemtap', 'curl',
                  'collectd','mlocate', 'dnsutils', 'whois', 'tuned','traceroute', 'nload', 'chrony',
                  'snmpd', 'lm-sensors', 'xz-utils', 'tuned-utils', 'puppet', 'rsyslog', 'ufw', 'zsh',
                  'ntpdate', 'cron', 's-nail', 'open-vm-tools', 'dialog', 'apt-utils', 'inetutils-ping',
                  'python3', 'python3-pip', 'vnstat', 'ncdu' ]

# for local lan
package { $base_packages:
    ensure  => latest,
    require => File['/etc/apt/sources.list'],
}

/*
# firewall settings for ufw
ufw_rule { 'allow ssh':
  action         => 'allow',
  to_ports_app   => 22,
  from_addr      => '10.5.22.0/24',
}
*/

# chrony (ntp) config for clients
file {'/etc/chrony/chrony.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0655',
  source => 'puppet:///modules/base_module/common/ntp/chrony.conf',
  notify => Service['chrony'],
}

# enable chrony for all
service {'chrony':
  ensure => running,
  enable => true,
}

# set proper timedatectl for timezone
class { 'timezone':
        timezone => 'America/New_York',
}

# clear puppet ruby warning
file {'/etc/profile.d/disableRubyPuppetWarn.sh':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => "#managed by puppet\nexport RUBYOPT='-W0'\n",
}

file_line { '/etc/zsh/zshenv':
  ensure => present,
  match  => "^export RUBYOPT*",
  path   => '/etc/zsh/zshenv',
  line   => 'export RUBYOPT=\'-W0\'',
}

# add our system-wide alias to execute a puppet run
file_line {'puppet sequence':
  ensure => present,
  path   => '/etc/bash.bashrc',
  line   => 'alias runpup="cd /etc/puppetlabs/code && /usr/bin/git pull && /usr/bin/puppet apply /etc/puppetlabs/code/manifests/site.pp"',
}

# keep root cron up-to-date
file {'/etc/cron.d/puppet':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => "puppet:///modules/base_module/common/${facts['os']['distro']['codename']}.puppet_cron",
}

# fix ufw logging to syslog
file {'/etc/rsyslog.d/20-ufw.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///modules/base_module/common/20-ufw.conf',
}

# fix ufw logging to syslog
file {'/etc/rsyslog.d/40-snmp-statfs.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///modules/base_module/common/40-snmp-statfs.conf',
}

service {'rsyslog':
  ensure    => running,
  enable    => true,
  subscribe => File[ ['/etc/rsyslog.d/20-ufw.conf'], ['/etc/rsyslog.d/40-snmp-statfs.conf'] ],
}

# configure snmpd
file { '/etc/snmp/snmpd.conf':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  source  => 'puppet:///modules/base_module/common/snmpd.conf',
  require => Package['snmpd'],
}

service { 'snmpd':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/snmp/snmpd.conf'],
}

## add unprivileged user matt with sudo rights
user { 'matt':
  ensure         => present,
  groups         => 'sudo',
  managehome     => true,
  purge_ssh_keys => '/home/matt/.ssh/authorized_keys',
}

ssh_authorized_key { 'matt_ssh_key':
  ensure => present,
  user   => 'matt',
  type   => 'ssh-ed25519',
  key    => 'xxx',
}

file {'/home/matt/.zshrc':
  ensure  => present,
  owner   => 'matt',
  group   => 'matt',
  mode    => '0600',
  source  => 'puppet:///modules/base_module/common/.zshrc',
  require => User['matt'],
}

# add user for prtg monitoring
user { 'prtg':
  ensure         => present,
  groups         => 'sudo',
  password       => '*',
  managehome     => true,
  # purge_ssh_keys => '/home/prtg/.ssh/authorized_keys',
}

ssh_authorized_key { 'prtg_ssh_key':
  ensure => present,
  user   => 'prtg',
  type   => 'ssh-rsa',
  key    => @(KEY/L),
            xxx
            |-KEY
}


## let's enable passwordless sudo
file { '/etc/sudoers':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0440',
  source => 'puppet:///modules/base_module/common/sudoers',
}

## Let's customize our motd with screenfetch
# remove execute permissions to existing motd file
file { '/etc/update-motd.d/':
  ensure  => directory,
  recurse => true,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

## place new custom motd file
file { '/etc/update-motd.d/01-screenfetch':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
  source => 'puppet:///modules/base_module/common/01-screenfetch',
}

file {'/usr/bin/screenfetch':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
  source => 'puppet:///modules/base_module/common/screenfetch-dev',
}

# prefer ipv4
file { '/etc/gai.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/base_module/common/gai.conf',
}

# congestion control to google's bbr
file { '/etc/sysctl.d/01-bbr.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/base_module/common/bbr.conf',
}

# let's make sure our hosts file is correct
file { '/etc/hosts':
    ensure  => present,
    content => "# managed by puppet\n127.0.0.1 localhost localhost.localdomain\n${::ipaddress} ${::hostname}.secunit.lan ${::hostname}\n",
}

file {'/etc/needrestart/needrestart.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/base_module/common/needrestart.conf',
}

# for secunit.lan machines, enable stub resolver, fix resolv.conf symlink, make sure systemd-resolved is running
if "${facts['networking']['network']}" == "10.5.22.0" and "${facts['networking']['ip']}" != "10.5.22.12" and "${facts['networking']['ip']}" != "10.5.22.13" {

  file { '/etc/systemd/resolved.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/base_module/common/lan.resolved.conf',
    notify => Service['systemd-resolved'],
  }

  file {'/etc/resolv.conf':
    ensure => link,
    target => '/run/systemd/resolve/stub-resolv.conf',
  }

  service {'systemd-resolved':
    ensure => running,
    enable => true,
  }

}

## our two stubby dns servers are unique ##

# stop/disable this on stubby machines, create our own resolv.conf
if "${facts['networking']['ip']}" == "10.5.22.12" or "${facts['networking']['ip']}" == "10.5.22.13" {

  service {'systemd-resolved':
    ensure => stopped,
    enable => false,
  }

  file {'/etc/resolv.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "#managed by puppet, edits will be lost!\n\nnameserver 10.5.22.12\nnameserver 10.5.22.13\n\nsearch secunit.lan\n"
  }

}

# skip static IP assigned devices
if "${facts['networking']['network']}" == "10.5.22.0" and "${facts['networking']['ip']}" != "10.5.22.12" and "${facts['networking']['ip']}" != "10.5.22.13" {

# make sure we have a base netplan file in place
  file {'/etc/netplan/00.yaml':
    ensure => present,
    source => 'puppet:///modules/base_module/common/netplan-00.yaml',
    notify => Exec['/usr/sbin/netplan apply'],
  }

# remove vmware customization files that break dns
  file { '/etc/netplan/00-installer-config.yaml.BeforeVMwareCustomization':
    ensure => absent,
    notify => Exec['/usr/sbin/netplan apply'],
  }

  file { '/etc/netplan/99-netcfg-vmware.yaml':
    ensure => absent,
    notify => Exec['/usr/sbin/netplan apply'],
  }

# re-apply netplan if either vmware config file is removed
  exec {'/usr/sbin/netplan apply':
    refreshonly => true,
    subscribe   => [ File['/etc/netplan/00-installer-config.yaml.BeforeVMwareCustomization'],
                    File['/etc/netplan/99-netcfg-vmware.yaml'], File['/etc/netplan/00.yaml'] ],
  }

}

# let's make sure our hostname is correct
file {'/etc/hostname':
    ensure  => present,
    content => "#managed by puppet\n${::hostname}.secunit.lan\n",
}

# make sure puppet isn't running, since we're masterless
service { 'puppet':
  ensure => stopped,
  enable => false,
}

# fix multipath vmware errors
file {'/etc/multipathd.conf':
  ensure => present,
  source => 'puppet:///modules/base_module/common/multipath.conf',
  notify => Service['multipathd'],
}

service {'multipathd':
  ensure => running,
}

# make sure ufw is running
service { 'ufw':
  ensure => running,
  enable => true,
}

# make sure rc.local is removed
file {'/etc/rc.local':
  ensure => absent,
}

# let's place our cleanup script, just 'cause
file {'/usr/local/bin/cleanup.sh':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0700',
  source => 'puppet:///modules/base_module/cleanup.sh',
}

# keep puppet reports folder clean
tidy { 'puppet::reports':
  path    => '/var/cache/puppet/reports',
  matches => '*',
  age     => '7d',
  backup  => false,
  recurse => true,
  rmdirs  => true,
  type    => 'ctime',
}

# ensure /root/.aws exists
file {'/root/.aws':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}

# install aws creds - this is super insecure, but just for homelab
file {'/root/.aws/config':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  source  => 'puppet:///modules/base_module/common/aws/config',
  require => File['/root/.aws'],
}

file {'/root/.aws/credentials':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  source  => 'puppet:///modules/base_module/common/aws/credentials',
  require => File['/root/.aws'],
}

# install cloudwatch deb file
package {'amazon-cloudwatch-agent':
  provider => dpkg,
  source   => '/etc/puppet/code/environments/production/modules/base_module/files/common/aws/amazon-cloudwatch-agent.deb',
}

file {'/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///modules/base_module/common/aws/cloudwatch-config.json',
  require => Package['amazon-cloudwatch-agent']
}

service { 'amazon-cloudwatch-agent':
  ensure    => running,
  enable    => true,
  require   => File['/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json'],
  subscribe => File['/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json'],
}

} # end base_module
