class kibana::install (
  $es_host,
  $es_port        = 9200,
  $kibana_user    = 'daemon',
  $kibana_gid     = 'daemon',
  $port           = '5601',
  $bind_to        = '0.0.0.0',
  $java_provider  = 'package',
  $java_package   = 'java-1.7.0-openjdk',
) {

  if $java_provider == 'package' {
    if ! defined(Package[$java_package]) {
      package { "$java_package": }
    }
  }


  exec {
    'git clone Kibana':
      cwd     => '/opt',
      user    => root,
      command => "git clone https://github.com/rashidkpc/Kibana.git",
      creates => "/opt/Kibana";

/*
    'get jruby':
      cwd     => '/opt',
      command => 'wget http://jruby.org.s3.amazonaws.com/downloads/1.6.8/jruby-bin-1.6.8.tar.gz; tar -xzf jruby-bin-1.6.8.tar.gz',
      creates => '/opt/jruby-1.6.8/bin';
*/

    'gem install bundler':
      cwd     => '/opt',
      path    => ['/bin', '/usr/bin'],
      unless  => 'gem list | grep bundler',
      require => [Exec['git clone Kibana'],];

    'Kibana bundle install':
      cwd     => '/opt/Kibana',
      path    => ['/bin', '/usr/bin'],
      command => 'bundle install && touch Bundle.installedbypuppet',
      creates => '/opt/Kibana/Bundle.installedbypuppet',
      require => [Exec['gem install bundler'],];

  }

  file {
    "/opt/Kibana/KibanaConfig.rb":
      mode    => 644,
      owner   => "$kibana_user",
      group   => "$kibana_gid",
      content => template("kibana/KibanaConfig.rb.erb"),
      #notify  => Daemontools::Service['kibana'],
      require => Exec['git clone Kibana'];
  }
}