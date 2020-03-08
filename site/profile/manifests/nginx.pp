# class to install nginx and make sure it is running
class profile::nginx {
  package {'nginx':
    ensure => present,
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/profile/nginx.conf',
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

  service {'nginx':
    ensure    => running,
    enable    => true,
    subscribe => Package['nginx']
  }
}
