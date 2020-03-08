# simple class that toggles on ssl and valid cert for splunk
class profile::splunk (
  String  $server_name,
) {

  service {'splunk':
    ensure => running,
    enable => true,
  }

  Ini_setting {
    path    => '/opt/splunk/etc/system/local/web.conf',
    require => Letsencrypt::Certonly[$server_name],
    notify  => Service['splunk']
  }

  ini_setting { 'splunk_web_enableSplunkWebSSL':
    ensure  => present,
    section => 'settings',
    setting => 'enableSplunkWebSSL',
    value   => 1,
  }

  ini_setting { 'splunk_web_serverCert':
    ensure  => present,
    section => 'settings',
    setting => 'serverCert',
    value   => "/etc/letsencrypt/live/${server_name}/cert.pem",
  }

  ini_setting { 'splunk_web_privKeyPath':
    ensure  => present,
    section => 'settings',
    setting => 'privKeyPath',
    value   => "/etc/letsencrypt/live/${server_name}/privkey.pem",
  }

  ini_setting { 'splunk_web_httpport':
    ensure  => present,
    section => 'settings',
    setting => 'httpport',
    value   => 443,
  }
}
