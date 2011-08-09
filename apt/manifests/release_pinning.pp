define apt::release_pinning () {

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    cwd  => "/etc/apt/",
  }

  exec { "add (*) for $name on apt/preferences":
    command => "printf \"Package: *\nPin: release n=$name\nPin-Priority: -100\n\n\" | tee -a preferences",
    unless => "cat preferences | grep -A1 'Package: \*$' | grep 'Pin: release n=$name'",
    before => Class["apt::update"],
    require => [File["/etc/apt/preferences"],
                Exec["backup apt/preferences"]],
  }

}

