# a really dumb class to prove a way to do patches

class profile::patches {

  $patches = lookup('patches')

  patches.each | $pkgname, $pkgversion | {
    notify {"hello ${pkgname} and ${pkgversion}":}

    Package <| title == $pkgname |> {
      ensure => $pkgversion,
      tag    => ['remediate_patched','remediate_overriden'],
    }
  }

  # Package <| title == 'chrony' |> {
  #   ensure => '3.5-1.el8',
  #   tag    => ['patched'],
  # }


}
