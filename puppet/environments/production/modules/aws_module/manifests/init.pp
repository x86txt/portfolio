## base module to set common settings across all servers
class aws_module {

## install necessary packages
$base_packages = [ 'net-tools', 'nano', 'jq', 'git', 'htop', 'gpg', 'tuned-utils-systemtap', 'curl',
                  'collectd','mlocate', 'dnsutils', 'whois', 'tuned','traceroute', 'nload', 'chrony',
                  'snmpd', 'lm-sensors', 'xz-utils', 'tuned-utils', 'puppet', 'rsyslog', 'ufw', 'zsh',
                  'ntpdate', 'cron', 's-nail', 'open-vm-tools', 'dialog', 'apt-utils', 'inetutils-ping',
                  'python3', 'python3-pip', 'vnstat', 'ncdu', 'awscli' ]

# for local lan
package { $base_packages:
    ensure  => latest,
}

# set the script that will set our hostname
file {'/usr/local/bin/set_awsHostname.sh':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0700',
  source => 'puppet:///modules/aws_module/set_awsHostname.sh',
}

# set our ec2 hostname to match the tag 'name'
exec { '/usr/local/bin/set_awsHostname.sh':
  command => '/usr/local/bin/set_awsHostname.sh',
  creates => '/tmp/hostname.set',
  require => [ Package['awscli'], File['/usr/local/bin/set_awsHostname.sh'] ],
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

# congestion control to google's bbr
file { '/etc/sysctl.d/01-bbr.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/base_module/common/bbr.conf',
}

# make sure puppet isn't running, since we're masterless
service { 'puppet':
  ensure => stopped,
  enable => false,
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

# place puppet cron file
file { '/etc/cron.d/puppet':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  source  => 'puppet:///modules/aws_module/puppet_cron',
  require => Package['puppet'],
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
  #purge_ssh_keys => '/home/matt/.ssh/authorized_keys',
}

ssh_authorized_key { 'matt_ssh_key':
  ensure => present,
  user   => 'matt',
  type   => 'ssh-ed25519',
  key    => 'AAAAC3NzaC1lZDI1NTE5AAAAIIN7FM6SYloQXfxyFOekumtgUOLpyEFCJ09a6xXLh2I5',
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
            AAAAB3NzaC1yc2EAAAADAQABAAABgQC4bSXjbe9k9jG8N9OAU1m/kHhgpft+w0oUDfFg04NVDaC6BucgtytxOochfd3VAhpRC8eJ1yIqxwi38f0aHuONt41X\
            IKtFr9aWTZmbuJmiFIqs8rpHh5C+7jxLGG6+yTLCoFm6hzjP+6+YfEOoiTQFv4yZGeXuIywMoPApoGzzKoucg6svWbNNmOWLMhAhFwD/Jm4nPlIHXyZKHHFYl\
            lwpV3avbn7zwaLC0R3rEL4P9zbjxVSVAVMjAJ85IbwgzrzuwiWcAB0G5+PDqmhYTvRyxANfveJOfQS0zrGvE5e6kLyrdSx9lFc3hcvOqlAwJ6f5vqeBa0f4ZOA\
            w0gRqnPBqVSF24ceKaaolwt2lsTncub8f0PoWXlAkHGFMZLibkWxLsdO1zDMx0xA/kU7vFo+l7x35Avj87DDyWIiAI64EbAIpEnvZhK0iqk22BmsiO513p10lFGk\
            /A+RloYJyd1yhy3zlJFL6WcwHurJ/RS/YY1PTUrTYaIpmKxOAfl33tp0=
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

file {'/etc/needrestart/needrestart.conf':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/base_module/common/needrestart.conf',
}

# make sure ufw is running
service { 'ufw':
  ensure => running,
  enable => true,
}


}
