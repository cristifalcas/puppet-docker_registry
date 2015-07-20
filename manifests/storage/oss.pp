define docker_registry::storage::oss (
  $include_config    = 'common',
  $storage_alternate = undef,
  $storage_path      = '/registry',
  $host              = undef,
  $bucket            = undef,
  $accessid          = undef,
  $accesskey         = undef,) {
  $storage = 'oss'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 05,
  }
}
