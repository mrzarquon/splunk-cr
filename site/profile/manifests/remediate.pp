# a really dumb class to prove a way to do patches

class profile::remediate {

  Package <| title == 'chrony' |> {
    tag    => ['pkg_locked'],
  }

  $pkg_patches = lookup('pkg_patches')

  $pkg_patches.each | $pkgname, $pkgversion | {

    Package <| title == $pkgname and tag != 'pkg_locked' |> {
      ensure => $pkgversion,
      tag    => ['remediate_patched','remediate_overriden'],
    }
  }
}
