define docker_registry::storage::s3 (
  $include_config      = 'common',
  $storage_alternate   = undef,
  $s3_region           = undef,
  $s3_bucket           = undef,
  $storage_path        = '/registry',
  $s3_encrypt          = true,
  $s3_secure           = true,
  $s3_access_key       = undef,
  $s3_secret_key       = undef,
  $boto_bucket         = undef,
  $boto_host           = undef,
  $boto_port           = undef,
  $boto_debug           = 0,
  $boto_calling_format = undef,) {
  $storage = 's3'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 02,
  }
}
