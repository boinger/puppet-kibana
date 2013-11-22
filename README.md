puppet-kibana
=============

Install and manage Kibana (http://kibana.org/)

## Pre-reqs
### Puppet modules
* puppet-daemontools (https://github.com/boinger/puppet-daemontools)
* nginx or other web server

### Packages
* git
* rubygems


## Usage
```puppet
  class {
    'kibana::install': ;
  }

  group { 'nginx':; }

  user {
    'nginx':
      gid        => 'nginx',
      shell      => '/bin/bash',
      managehome => false;
  }

  package {
    "nginx": ;
  }

  file {
    [
    '/var/www/html',
    '/var/www',
    ]:
      ensure => directory,
      owner  => nginx;

    "/etc/nginx/nginx.conf":
      mode    => 0644,
      source  => "puppet:///modules/conf/etc/nginx/nginx.conf",
      notify  => Service['nginx'],
      require => Package['nginx'];

    "/etc/nginx/conf.d/kibana.conf":
      mode    => 0644,
      source  => "puppet:///modules/conf/etc/nginx/conf.d/kibana.conf",
      notify  => Service['nginx'],
      require => Package['nginx'];

    "/etc/nginx/conf.d/default.conf":
      ensure  => absent,
      notify  => Service['nginx'];
  }

  service {
    'nginx':
      enable  => true,
      ensure  => running,
      require => [Package['nginx'], User['nginx']];

  }
```