## base module to set common settings across all nginx server
class nginx {

## place our own main nginx.conf
file {'/etc/nginx/nginx.conf':
  owner  => 'matt',
  group  => 'matt',
  mode   => '0664',
  source => 'puppet:///modules/nginx/nginx.conf',
  notify => Service['nginx'],
}

## our main conf.d folder
file {'/etc/nginx/conf.d':
  owner   => 'matt',
  group   => 'matt',
  mode    => '0664',
  recurse => true,
  source  => 'puppet:///modules/nginx/conf.d',
  notify  => Service['nginx'],
}

## our main ssl folder
file {'/etc/nginx/ssl':
  owner   => 'matt',
  group   => 'matt',
  mode    => '0664',
  recurse => true,
  source  => 'puppet:///modules/nginx/ssl',
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure => running,
  enable => true,
}

}
