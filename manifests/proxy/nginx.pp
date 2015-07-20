class docker_registry::proxy::nginx (
  $port      = $::docker_registry::params::ssl_port,
  $auth_user = $::docker_registry::params::auth_user,
  $auth_pass = $::docker_registry::params::auth_pass,
  $server_name = $::fqdn
  #
  ) {
  include ::nginx

  $proxy = 'docker_registry'

  if $auth_user and $auth_pass {
    htpasswd { $auth_user:
      cryptpasswd => ht_sha1($auth_pass),
      target      => "${::nginx::config::conf_dir}/docker_registry.htpasswd",
    }
    $auth_basic           = 'Restricted'
    $auth_basic_user_file = "${::nginx::config::conf_dir}/docker_registry.htpasswd"
  } else {
    $auth_basic           = 'off'
    $auth_basic_user_file = undef
  }

  nginx::resource::vhost { $server_name:
    listen_port          => $port,
    www_root             => '/usr/share/nginx/html',
    use_default_location => false,
    access_log           => '/var/log/nginx/docker_registry.access.log',
    error_log            => '/var/log/nginx/docker_registry.error.log info',
    ssl                  => true,
    ssl_cert             => "${::settings::ssldir}/certs/${::clientcert}.pem",
    ssl_key              => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
    vhost_cfg_append     => {
      'client_max_body_size'      => 0,
      'chunked_transfer_encoding' => 'on',
    }
  }

  nginx::resource::location { '/':
    vhost                => $::fqdn,
    ssl_only             => true,
    proxy                => "http://${proxy}",
    auth_basic           => $auth_basic,
    auth_basic_user_file => $auth_basic_user_file,
  }

  nginx::resource::location { ['/_ping', '/v1/_ping']:
    vhost      => $::fqdn,
    ssl_only   => true,
    proxy      => "http://${proxy}",
    auth_basic => 'off',
  }

  nginx::resource::upstream { $proxy: members => ["localhost:${docker_registry::port}",], }
}
