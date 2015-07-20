define docker_registry::flavor ($include_config = 'common', $exportable = true, $options,) {
  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/custom_flavor.erb"),
    order   => 20,
  }
}
