class docker_registry::service {
  service { $docker_registry::service_name:
    ensure => $::docker_registry::service_ensure,
    enable => $::docker_registry::service_enable,
  }
}
