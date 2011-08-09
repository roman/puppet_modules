class apt {
  include apt::update

  file { "/etc/apt/preferences":
    ensure => file,
  }

  exec { "remove old apt/preferences.bak":
    cwd => "/etc/apt/",
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    command => "rm preferences.bak",
    onlyif  => "test -s /etc/apt/preferences.bak",
    before  => Exec["backup apt/preferences"],
  }

  exec { "backup apt/preferences":
    cwd => "/etc/apt/",
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    command => "cp preferences preferences.bak",
    creates => "/etc/apt/preferences.bak",
  }

}
