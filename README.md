# docker_registry #

This is the docker_registry module. It provides...


  $db_user     = 'docker_registry'
  $db_pass     = 'docker_registry_pass'
  $db_name     = 'docker_registry_index'
  $db_hostname = 'localhost'

  include postgresql::server

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => postgresql_password($db_user, $db_pass),
  }

  include mysql::server

  class { 'mysql::bindings': python_enable => true } ->
  mysql_database { $db_name: ensure => present, } ->
  mysql_user { "${db_user}@${db_hostname}": password_hash => mysql_password($db_pass), } ->
  mysql_grant { "${db_user}@${db_hostname}/${db_name}.*":
    privileges => 'ALL',
    table      => "${db_name}.*",
    user       => "${db_user}@${db_hostname}",
  }
