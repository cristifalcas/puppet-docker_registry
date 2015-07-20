class docker_registry::install {
  package { ['docker-registry']: ensure => $::docker_registry::package_ensure, }
  if $docker_registry::enable_ssl {
    include docker_registry::proxy::nginx
  }
}
