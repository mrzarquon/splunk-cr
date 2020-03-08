# get a cert for a hostname

class profile::letsencrypt (
  String[1] $fqdn = undef,
) {

  letsencrypt::certonly { $fqdn:
    domains              => [$fqdn],
    plugin               => 'webroot',
    webroot_paths        => ['/var/www/html'],
    manage_cron          => true,
    cron_hour            => [0,12],
    cron_minute          => '30',
    cron_success_command => '/bin/systemctl reload pe-nginx',
    suppress_cron_output => true,
  }
}
