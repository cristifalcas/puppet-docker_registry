class docker_registry::params {
  $package_ensure        = 'installed'
  $port                  = 5000
  $adress                = '0.0.0.0'
  $nr_threads            = $::processorcount
  $default_flavor        = 'dev'

  $loglevel              = 'info'
  $debug                 = false
  $standalone            = true
  $endpoint              = 'https://index.docker.io'
  $enable_ssl            = true

  $search_database       = 'sqlite'
  $db_name               = 'docker_registry_index'
  $db_user               = 'docker_registry'
  $db_pass               = 'docker_registry_pass'
  $db_hostname           = 'localhost'
  $db_port               = undef
  $sqlite_path           = "/var/lib/docker-registry/${db_name}.db"

  $mirror_source         = 'https://registry-1.docker.io'
  $mirror_source_index   = 'https://index.docker.io'
  $mirror_tags_cache_ttl = 172800

  $redis_hostname        = undef
  $redis_port            = 6379
  $redis_db              = 0
  $redis_pass            = 'mysecretpassword'

  $lru_redis_hostname    = undef
  $lru_redis_port        = 6379
  $lru_redis_db          = 0
  $lru_redis_pass        = 'mysecretpassword'

  $smtp_hostname         = 'localhost'
  $smtp_port             = 25
  $smtp_login            = undef
  $smtp_pass             = undef
  $smtp_secure           = false
  $smtp_from_address     = "docker-registry@${::fqdn}"
  $smtp_to_address       = 'root@localhost'

  $ssl_port              = 443
  $auth_user             = undef
  $auth_pass             = undef
}
