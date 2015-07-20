class docker_registry::defaults {
  include docker_registry

  docker_registry::storage::local { 'local': }
  docker_registry::storage::elliptics { 'elliptics': }
  docker_registry::storage::azureblob { 'azureblob': }
  docker_registry::storage::s3 { 's3': }
  docker_registry::storage::s3 { 'ceph-s3': s3_region => '~' }
  docker_registry::storage::gcs { 'gcs': }
  docker_registry::storage::oss { 'oss': }
  docker_registry::storage::swift { 'swift': }

  docker_registry::flavor { 'dev':
    include_config => 'local',
    options        => {
      loglevel       => '_env:LOGLEVEL:debug',
      debug          => '_env:DEBUG:true',
      search_backend => '_env:SEARCH_BACKEND:sqlalchemy',
    }
  }

  docker_registry::flavor { 'test':
    exportable     => false,
    include_config => 'dev',
    options        => {
      index_endpoint => 'https://registry-stage.hub.docker.com',
      standalone     => true,
      storage_path   => '_env:STORAGE_PATH:./tmp/test',
    }
  }

  docker_registry::flavor { 'prod':
    exportable     => false,
    include_config => 's3',
    options        => {
      storage_path => '_env:STORAGE_PATH:/prod',
    }
  }
}
