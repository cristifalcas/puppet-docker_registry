class docker_registry::install {
  package { [$::docker_registry::package_name]: ensure => $::docker_registry::package_ensure, }
}
