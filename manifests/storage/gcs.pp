define docker_registry::storage::gcs (
  $include_config    = 'common',
  $storage_alternate = undef,
  $boto_bucket       = undef,
  $storage_path      = '/registry',
  $gs_secure         = true,
  $gs_access_key     = undef,
  $gs_secret_key     = undef,
  $oauth2            = false,) {
  $storage = 'gcs'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 04,
  }
}
