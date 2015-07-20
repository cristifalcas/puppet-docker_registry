define docker_registry::storage::local (
  $include_config    = 'common',
  $storage_alternate = undef,
  $storage_path      = '/var/lib/docker-registry',) {
  $storage = 'local'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 01,
  }
}
