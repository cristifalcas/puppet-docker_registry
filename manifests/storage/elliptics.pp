define docker_registry::storage::elliptics (
  $include_config            = 'common',
  $storage_alternate         = undef,
  $nodes                     = undef,
  $groups                    = undef,
  $wait_timeout              = 60,
  $check_timeout             = 60,
  $io_thread_num             = 2,
  $net_thread_num            = 2,
  $nonblocking_io_thread_num = 2,
  $verbosity                 = 4,
  $logfile                   = '/dev/stderr',
  $addr_family               = '2',) {
  $storage = 'elliptics'

  concat::fragment { $name:
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/storage/${storage}.erb"),
    order   => 06,
  }
}
