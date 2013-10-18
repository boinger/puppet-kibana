class kibana::install (
  $es_host,
  $es_port        = 9200,
  $kibana_user    = 'daemon',
  $kibana_gid     = 'daemon',
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

  daemontools::setup{
    $module_name:
      user    => $kibana_user,
      loguser => $kibana_user,
      run     => template("${module_name}/service/run.erb"),
      logrun  => template("${module_name}/service/log/run.erb"),
      notify  => Daemontools::Service[$module_name];
  }

  daemontools::service {
    $module_name:
      source  => "/etc/${module_name}",
      require => Daemontools::Setup[$module_name];
  }
}