class kibana::install (
  $kibana_source  = 'https://github.com/elasticsearch/kibana.git',
) {

  Exec     { path => ["/usr/bin", "/bin", "/sbin"], }
  Package  { ensure => "installed", }
  File     { ensure => present, owner => root, group => root, mode => 0755, }

  exec {
    'git clone Kibana':
      cwd     => '/opt',
      user    => root,
      command => "git clone ${kibana_source}",
      creates => "/opt/kibana",
      require => Package['git'];
  }
}