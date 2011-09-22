class java::install {

  case $operatingsystem {

    "Ubuntu": {
      include apt
      package { ["openjdk-6-jdk", "default-jdk"]:
        ensure => present,
        require => Class["apt::update"],
      }
    }

    "Archlinux": {
      include pacman
      package { "openjdk6":
        ensure => present,
        require => Class["pacman::config"],
      }
    }

    default: {
      err("java module not supported for $operatingsystem")
    }

  }
}
