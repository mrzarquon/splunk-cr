# set us up for runs every 5 minutes so we have some traffic

class profile::agent_settings {

  $puppet_conf = $facts['os']['family'] ? {
    'windows'          => 'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf',
    default            => '/etc/puppetlabs/puppet/puppet.conf',
  }

  Pe_ini_setting {
    ensure  => present,
    path    => $puppet_conf,
    section => 'agent',
  }

  pe_ini_setting { 'enable splay':
    setting => 'splay',
    value   => true,
  }

  pe_ini_setting { 'set splaylimit':
    setting => 'splaylimit',
    value   => '5m',
  }

  pe_ini_setting { 'shorten runinterval':
    setting => 'runinterval',
    value   => '5m',
  }

}
