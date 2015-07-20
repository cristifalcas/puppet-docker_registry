class docker_registry::config {
  concat { '/etc/docker-registry.yml':
    owner => root,
    group => root,
    mode  => '0640',
  }

  concat::fragment { 'common':
    target  => '/etc/docker-registry.yml',
    content => template("${module_name}/docker-registry.erb"),
    order   => 01,
  }

  if $::operatingsystemmajrelease < 7 {
    $service_file     = '/etc/rc.d/init.d/docker-registry.sh'
    $service_template = 'service/docker-registry'
    $service_chmod    = '0755'
  } else {
    $service_file     = '/etc/systemd/system/docker-registry.service'
    $service_template = 'service/docker-registry.service'
    $service_chmod    = '0644'

    exec { 'docker_registry refresh system service':
      command     => '/bin/systemctl daemon-reload',
      subscribe   => File[$service_file],
      refreshonly => true,
    }
  }

  file { $service_file:
    ensure  => file,
    owner   => 'root',
    group   => 0,
    mode    => $service_chmod,
    content => template("${module_name}/${service_template}"),
  }

  file { '/etc/sysconfig/docker-registry':
    ensure  => file,
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    content => template("${module_name}/sysconfig/docker-registry"),
  }
}
