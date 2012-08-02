class emacs::install($version) {

  case $operatingsystem {

    "Ubuntu": {
      include apt
      if $version == 24 {
        apt::ppa { "emacs_ppa":
          ppa_name => "ppa:cassou/emacs"
        }
        package { ["emacs24-nox", "texinfo"]:
          ensure => present,
          require => [Apt::Ppa["emacs_ppa"],
                      Class["apt::update"]]
        }
      }
      else {
        package { ["emacs-nox", "texinfo"]:
          ensure => latest,
          require => Class["apt::update"]
        }
      }
    }

    default: {
      err("emacs module not supported for $operatingsystem")
    }
    
  }
}