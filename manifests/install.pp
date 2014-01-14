class kibana::install (
  $kibana_source   = 'https://github.com/elasticsearch/kibana.git',
  $clobber_default = true,
  $default_route   = '/dashboard/file/default.json',
) {

  Exec     { path => ["/usr/bin", "/bin", "/sbin"], }
  Package  { ensure => "installed", }
  File     { ensure => present, owner => root, group => root, mode => 0755, }

  exec {
    'git clone kibana':
      cwd     => '/opt',
      user    => root,
      command => "git clone ${kibana_source}",
      creates => "/opt/kibana",
      require => Package['git'];
  }

  file {
    "/opt/kibana/src/config.js":
      content => template("${module_name}/config.js.erb"),
      mode    => 0644,
      require => Exec['git clone kibana'];
  }

  if ($clobber_default) {
    file {
      "/opt/kibana/src/app/dashboards/default.json":
        content => template("${module_name}/default.json.erb"),
        mode    => 0644,
        require => Exec['git clone kibana'];
    }
  }
}