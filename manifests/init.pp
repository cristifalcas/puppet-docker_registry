# Class: docker_registry
#
# This module manages docker_registry
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class docker_registry (
  $package_ensure        = $::docker_registry::params::package_ensure,
  $port                  = $::docker_registry::params::port,
  $adress                = $::docker_registry::params::adress,
  $nr_threads            = $::docker_registry::params::nr_threads,
  $default_flavor        = $::docker_registry::params::default_flavor,
  $loglevel              = $::docker_registry::params::loglevel,
  $debug                 = $::docker_registry::params::debug,
  $standalone            = $::docker_registry::params::standalone,
  $endpoint              = $::docker_registry::params::endpoint,
  $enable_ssl            = $::docker_registry::params::enable_ssl,
  $search_database       = $::docker_registry::params::search_database,
  # sqlite
  $sqlite_path           = $::docker_registry::params::sqlite_path,
  # mysql/postgresql
  $db_user               = $::docker_registry::params::db_user,
  $db_pass               = $::docker_registry::params::db_pass,
  $db_hostname           = $::docker_registry::params::db_hostname,
  $db_name               = $::docker_registry::params::db_name,
  $db_port               = $::docker_registry::params::db_port,
  # mirroring
  $mirror_source         = $::docker_registry::params::mirror_source,
  $mirror_source_index   = $::docker_registry::params::mirror_source_index,
  $mirror_tags_cache_ttl = $::docker_registry::params::mirror_tags_cache_ttl,
  # redis
  $redis_hostname        = $::docker_registry::params::redis_hostname,
  $redis_port            = $::docker_registry::params::redis_port,
  $redis_db              = $::docker_registry::params::redis_db,
  $redis_pass            = $::docker_registry::params::redis_pass,
  # lru_redis
  $lru_redis_hostname    = $::docker_registry::params::lru_redis_hostname,
  $lru_redis_port        = $::docker_registry::params::lru_redis_port,
  $lru_redis_db          = $::docker_registry::params::lru_redis_db,
  $lru_redis_pass        = $::docker_registry::params::lru_redis_pass,
  # email settings
  $smtp_hostname         = $::docker_registry::params::smtp_hostname,
  $smtp_port             = $::docker_registry::params::smtp_port,
  $smtp_login            = $::docker_registry::params::smtp_login,
  $smtp_pass             = $::docker_registry::params::smtp_pass,
  $smtp_secure           = $::docker_registry::params::smtp_secure,
  $smtp_from_address     = $::docker_registry::params::smtp_from_address,
  $smtp_to_address       = $::docker_registry::params::smtp_to_address,
  #
  ) inherits docker_registry::params {
  case $search_database {
    'sqlite'     : {
      file { $sqlite_path:
        ensure  => $package_ensure,
        owner   => 'root',
        group   => 0,
        require => Package['docker-registry'],
      }
      $sqlalchemy_index_database = "${search_database}:///${sqlite_path}"
    }
    'mysql'      : {
      Service['mysqld'] -> Service['docker-registry']

      if $db_port {
        $real_db_port = $db_port
      } else {
        $real_db_port = 3306
      }
      $sqlalchemy_index_database = "${search_database}://${db_user}:${db_pass}@${db_hostname}:${real_db_port}/${db_name}"
    }
    'postgresql' : {
      Service['postgresqld'] -> Service['docker-registry']

      package { 'python-psycopg2': ensure => 'installed' } -> Service['docker-registry']

      if $db_port {
        $real_db_port = $db_port
      } else {
        $real_db_port = 5432
      }
      $sqlalchemy_index_database = "${search_database}://${db_user}:${db_pass}@${db_hostname}:${real_db_port}/${db_name}"
    }
    default      : {
      fail("Your input for search_database is not allowed: ${search_database}.")
    }
  }

  contain docker_registry::install
  contain docker_registry::config
  contain docker_registry::service

  Class['docker_registry::install'] ->
  Class['docker_registry::config'] ~>
  Class['docker_registry::service']
}
