# simple class to deploy the forwarder

class profile::splunk::winforwarder (
  $version = '7.1.3',
  $build = '51d9cac7b837',
  $server = 'splunk.c.splunk-217321.internal',
) {
  class { '::splunk::params':
    version  => $version,
    build    => $build,
    server   => $server,
    src_root => 'https://download.splunk.com',
  }

  class { '::splunk::forwarder':
    purge_outputs => true,
    purge_inputs => true,
  }

}
