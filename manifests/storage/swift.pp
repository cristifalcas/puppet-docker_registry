define docker_registry::storage::swift (
  $include_config    = 'common',
  $storage_alternate = undef,
  $storage_path      = '/registry',
  $authurl           = undef,
  $container         = undef,
  $user              = undef,
  $password          = undef,
  $tenant_name       = undef,
  $region_name       = undef,) {
  $storage = 'swift'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 05,
  }
}
