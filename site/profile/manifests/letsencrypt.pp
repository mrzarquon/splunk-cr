# get a cert for a hostname

# server {
#  server_name puppet-lhr.c.splunk-217321.internal;
#  listen 0.0.0.0:80 ipv6only=off;
#  return 301 https://$server_name$request_uri;
#}

class profile::letsencrypt (
  String  $server_name,
  Integer $ssl_listen_port = 443,
  Boolean $enable_http_redirect = true,
  Boolean $ipv6_only = false,
  String  $ssl_listen_address = '0.0.0.0',
  String  $nginx_name = 'pe-nginx',
  String  $nginx_confd = '/etc/puppetlabs/nginx/conf.d',
  String  $cron_success_command = '/bin/systemctl reload pe-nginx',
) {

  $webroot_paths = '/var/www/letsencrypt'

  $http_redirect_file_ensure = $enable_http_redirect ? {
    true    => file,
    default => absent,
  }

  $letsencrypt_dir_ensure = $enable_http_redirect ? {
    true    => directory,
    default => absent,
  }

  $redirect_return_base = '301 https://$server_name$request_uri'
  $redirect_return_port = $ssl_listen_port ? {
    443     => '',
    default => ":${ssl_listen_port}"
  }

  $_ipv6_only = $ipv6_only ? {
    true => 'on',
    false => 'off'
  }

  file {['/var/www', '/var/www/letsencrypt']:
    ensure => $letsencrypt_dir_ensure,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { "${$nginx_confd}/letsencrypt_redirect.conf":
    ensure  => $http_redirect_file_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('profile/letsencrypt_redirect.conf.epp', {
      server_name    => $server_name,
      listen_address => $ssl_listen_address,
      return_value   => "${redirect_return_base}${redirect_return_port}",
      ipv6_only      => $_ipv6_only,
      webroot_paths  => $webroot_paths,
    }),
    notify  => Service[$nginx_name],
    require => Package[$nginx_name],
  }

  class { 'letsencrypt':
    email          => 'cbarker@puppet.com',
    package_ensure => 'latest',
    configure_epel => true,
  }


  letsencrypt::certonly { $server_name:
    domains              => [$server_name],
    plugin               => 'webroot',
    webroot_paths        => [$webroot_paths],
    manage_cron          => true,
    cron_hour            => [0,12],
    cron_minute          => '30',
    cron_success_command => $cron_success_command,
    suppress_cron_output => true,
    require              => [
      File["${$nginx_confd}/letsencrypt_redirect.conf"],
      File[$webroot_paths],
      Service[$nginx_name]
    ],
  }
}
