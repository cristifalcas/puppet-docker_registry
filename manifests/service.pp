class docker_registry::service {
  service { 'docker-registry':
    ensure => running,
    enable => true,
  }
}
