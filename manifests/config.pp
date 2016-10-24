class docker_registry::config (
  $log_fields = $::docker_registry::log_fields,
  $log_hooks_mail_disabled = $::docker_registry::log_hooks_mail_disabled,
  $log_hooks_mail_smtp_username = $::docker_registry::log_hooks_mail_smtp_username,
  $storage_type = $::docker_registry::storage_type,
  $storage_cache_blobdescriptor = $::docker_registry::storage_cache_blobdescriptor,
  $auth_type = $::docker_registry::auth_type,
  $http_host = $::docker_registry::http_host,
  $http_secret = $::docker_registry::http_secret,
  $http_tls = $::docker_registry::http_tls,
  $http_tls_clientcas = $::docker_registry::http_tls_clientcas,
  $http_debug_addr = $::docker_registry::http_debug_addr,
  $http_headers = $::docker_registry::http_headers,
  $redis_addr = $::docker_registry::redis_addr,
  $redis_password = $::docker_registry::redis_password,
  $proxy_remoteurl = $::docker_registry::proxy_remoteurl,
  $proxy_username = $::docker_registry::proxy_username,
)
{
  file { $::docker_registry::config_file:
    ensure  => 'file',
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("${module_name}/config.yml.erb"),
  }

  if $::docker_registry::journald_forward_enable and $::operatingsystemmajrelease == 7 {
    file { '/etc/systemd/system/docker-distribution.service.d':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    } ->
    file { '/etc/systemd/system/docker-distribution.service.d/journald.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/journald.conf.erb"),
    } ~>
    exec { 'systemctl-daemon-reload docker_registry':
      refreshonly => true,
      command     => '/usr/bin/systemctl daemon-reload',
    }
  }
}
