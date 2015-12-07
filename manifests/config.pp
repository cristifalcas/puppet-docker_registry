class docker_registry::config {
  file { $::docker_registry::config_file:
    ensure  => 'file',
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("${module_name}/config.yml.erb"),
  }
}
