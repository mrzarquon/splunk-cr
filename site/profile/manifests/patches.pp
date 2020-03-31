# a really dumb class to prove a way to do patches

class profile::patches {

  # $patches = lookup('patches')

  # patches.each | $pkgname, $pkgversion | {
  #   Package <| title == $pkgname |> {
  #     ensure => $pkgversion,
  #   }
  # }

  Package <| title == 'chrony' |> {
    ensure => '3.5-1.el8'
    tags => ['patched']
  }


}
