define apt::pinning ($release, $priority) {

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    cwd  => "/etc/apt/",
  }

  exec { "add $name to apt/preferences":
    command => "printf \"Package: $name\nPin: release n=$release\nPin-Priority: $priority\n\n\" | tee -a preferences",
    unless => "cat preferences | grep \"Package: $name$\"",
    before => Class["apt::update"],
    require => [File["/etc/apt/preferences"],
                Exec["backup apt/preferences"],
                Exec["add (*) for $release on apt/preferences"]],
  }

}


