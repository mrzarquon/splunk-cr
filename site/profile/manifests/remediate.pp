# a really dumb class to prove a way to do patches

class profile::remediate {

  $pkg_patches = lookup('pkg_patches')

  $pkg_patches.each | $pkgname, $pkgversion | {

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
