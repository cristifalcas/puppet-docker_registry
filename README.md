# docker_registry #

# THIS MODULE WAS RENAMED DOCKER_DISTRIBUTION #
# YOU CAN FIND THE NEW MODULE AT #
# https://github.com/cristifalcas/puppet-docker_distribution #

[![Build Status](https://travis-ci.org/cristifalcas/puppet-docker_registry.png?branch=master)](https://travis-ci.org/cristifalcas/puppet-docker_registry)

Puppet module for installing, configuring and managing [Docker Registry 2.0](https://github.com/docker/distribution)



## Support

This module is currently only for RedHat clones 6.x, 7.x and OpenSuSE:

The Docker toolset to pack, ship, store, and deliver content.

## Usage:

          include docker_registry

### Use tls (it will use puppet certificates) and enable email hooks:

	  class { '::docker_registry':
	    log_fields               => {
	      service     => 'registry',
	      environment => 'production'
	    }
	    ,
	    log_hooks_mail_disabled  => false,
	    log_hooks_mail_levels    => ['panic', 'error'],
	    log_hooks_mail_to        => 'docker_registry@company.com',
	    filesystem_rootdirectory => '/srv/registry',
	    http_addr                => ':1443',
	    http_tls                 => true,
	  }

## Journald forward:

The class support a parameter called journald_forward_enable.

This was added because of the PIPE signal that is sent to go programs when systemd-journald dies.

For more information read here: https://github.com/projectatomic/forward-journald

### Usage:

	  include ::forward_journald
	  Class['forward_journald'] -> Class['docker_registry']
