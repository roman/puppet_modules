class emacs::install($use_ppa) {

  case $operatingsystem {

    "Ubuntu": {
      include apt
      if $use_ppa {
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
        package { ["emacs23-nox", "texinfo"]:
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