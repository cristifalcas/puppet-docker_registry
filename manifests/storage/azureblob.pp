define docker_registry::storage::azureblob (
  $include_config       = 'common',
  $storage_alternate    = undef,
  $storage_account_name = undef,
  $storage_account_key  = undef,
  $storage_container    = 'registry',
  $use_https            = true,) {
  $storage = 'azureblob'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 03,
  }
}
