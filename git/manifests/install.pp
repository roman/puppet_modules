class git::install {

  case $operatingsystem {

    "Ubuntu": {
      include apt

      package { "git-core":
        ensure => present,
        require => Class["apt::update"],
      }

    }

    "Archlinux": {
      include pacman

      package { "git":
        ensure => present,
        require => Class["pacman::config"],
      }

    }

    default: {
      err("git module not supported for $operatingsystem")
    }

  }
}
