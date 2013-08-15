puppet-kibana
=============

Install and manage Kibana (http://kibana.org/)

## Pre-reqs
### Puppet modules
* puppet-daemontools (https://github.com/boinger/puppet-daemontools)

### Packages
* git
* rubygems

## Usage
  class {
    'kibana::install':
      port          => 9292,
      java_provider => 'external',
      es_host       => 'elasticsearch0.internal.whatever.com',
  }